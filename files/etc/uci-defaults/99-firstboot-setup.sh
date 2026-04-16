#!/bin/sh
# 99-firstboot-setup.sh — runs once on first boot via uci-defaults

# ── 网络：LAN IP ─────────────────────────────────────────────────
uci set network.lan.ipaddr='192.168.2.1'
uci set network.lan.netmask='255.255.255.0'
uci commit network

# ── 系统：主机名 + 时区 ──────────────────────────────────────────
uci set system.@system[0].hostname='OpenWrt'
uci set system.@system[0].timezone='CST-8'
uci set system.@system[0].zonename='Asia/Shanghai'
uci commit system

# ── NTP ──────────────────────────────────────────────────────────
if ! uci -q get system.ntp > /dev/null 2>&1; then
  uci set system.ntp='timeserver'
fi
uci -q delete system.ntp.server || true
uci add_list system.ntp.server='ntp.aliyun.com'
uci add_list system.ntp.server='ntp.tencent.com'
uci add_list system.ntp.server='cn.pool.ntp.org'
uci commit system
[ -x /etc/init.d/sysntpd ] && /etc/init.d/sysntpd restart 2>/dev/null || true

# ── DHCP：dnsmasq 监听 53，转发到 AdGuardHome 的 3053 ────────────
uci set dhcp.@dnsmasq[0].cachesize='1000'
uci set dhcp.@dnsmasq[0].ednspacket_max='1232'
uci set dhcp.@dnsmasq[0].port='53'
uci -q delete dhcp.@dnsmasq[0].server || true
uci add_list dhcp.@dnsmasq[0].server='127.0.0.1#3053'
uci commit dhcp

# ── AdGuardHome：强制监听 3053，避免与 dnsmasq 在 53 端口冲突 ────
AGH_CONF="/etc/adguardhome/AdGuardHome.yaml"
if [ -f "$AGH_CONF" ]; then
  # 将 dns.port 从默认 53 改为 3053
  sed -i 's/^\(\s*port:\s*\)53\s*$/\13053/' "$AGH_CONF" || true
  echo "✅ AdGuardHome DNS 端口已设为 3053"
fi
# 若配置文件尚未生成（首次启动前），写入一个最小配置占位
if [ ! -f "$AGH_CONF" ]; then
  mkdir -p /etc/adguardhome
  cat > "$AGH_CONF" << 'AGHEOF'
dns:
  port: 3053
  bootstrap_dns:
    - 119.29.29.29
    - 223.5.5.5
  upstream_dns:
    - https://doh.pub/dns-query
    - https://dns.alidns.com/dns-query
http:
  address: 0.0.0.0:3000
AGHEOF
  echo "✅ AdGuardHome 最小配置已写入（DNS:3053, Web:3000）"
fi

# ── CPU 超频：performance governor（写入 rc.local 持久化）────────
# 先对当前会话立即生效
for cpu_gov in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
  [ -f "$cpu_gov" ] && echo performance > "$cpu_gov" 2>/dev/null || true
done

# FIX: 使用独立文件，不覆盖已有 rc.local 内容
# rc.local 由其他包管理；改用 /etc/rc.d/S99-cpufreq 独立脚本
cat > /etc/init.d/cpufreq-performance << 'EOF'
#!/bin/sh /etc/rc.common
START=99
start() {
  for g in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    [ -f "$g" ] && echo performance > "$g" 2>/dev/null || true
  done
}
EOF
chmod +x /etc/init.d/cpufreq-performance
/etc/init.d/cpufreq-performance enable 2>/dev/null || true

# ── Docker：数据目录 + daemon 配置 ───────────────────────────────
mkdir -p /opt/docker
mkdir -p /etc/docker
cat > /etc/docker/daemon.json << 'EOF'
{
  "data-root": "/opt/docker",
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "storage-driver": "overlay2"
}
EOF

# ── FileBrowser：工作目录 ─────────────────────────────────────────
mkdir -p /opt/filebrowser

# ── opkg：关闭签名校验 + 首次异步更新包列表 ──────────────────────
# FIX: 此段原来在 exit 0 之后，永远不执行，现已移到这里
uci set opkg.@opkg[0].check_signature='0' 2>/dev/null || true
if ! grep -q "option check_signature" /etc/opkg.conf 2>/dev/null; then
  echo "option check_signature off" >> /etc/opkg.conf
fi
( sleep 30 && opkg update > /tmp/opkg-update.log 2>&1 ) &

# FIX: exit 0 必须在脚本最末尾，否则上方代码被截断
exit 0
