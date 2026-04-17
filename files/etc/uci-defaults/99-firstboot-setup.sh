#!/bin/sh
# 360V6 (IPQ6000) 首次启动网络配置
# 兼容 VIKINGYFY fork 新内核（eth0~eth4）和旧内核（lan1~lan4/wan）DSA 命名
LOG="/tmp/firstboot-network.log"
exec >> "$LOG" 2>&1
echo "=== firstboot network setup: $(date) ==="

# 等待网络接口就绪（最多 15 秒）
for i in $(seq 1 15); do
    ip link show eth0 >/dev/null 2>&1 && break
    ip link show lan1 >/dev/null 2>&1 && break
    sleep 1
done

# 探测接口命名风格
# 新内核（6.1/6.6）：eth0-eth3=LAN, eth4=WAN
# 旧内核（5.15）：lan1-lan4=LAN, wan=WAN
if ip link show eth0 >/dev/null 2>&1; then
    LAN_PORTS="eth0 eth1 eth2 eth3"
    WAN_IFACE="eth4"
    echo "Style: new-kernel (eth)"
else
    LAN_PORTS="lan1 lan2 lan3 lan4"
    WAN_IFACE="wan"
    echo "Style: legacy-dsa (lan/wan)"
fi

echo "LAN: $LAN_PORTS  WAN: $WAN_IFACE"

# 写入网络配置
uci -q batch << EOF
delete network.lan_dev
set network.lan_dev=device
set network.lan_dev.name=br-lan
set network.lan_dev.type=bridge
set network.lan=interface
set network.lan.device=br-lan
set network.lan.proto=static
set network.lan.ipaddr=192.168.1.1
set network.lan.netmask=255.255.255.0
set network.lan.ip6assign=60
set network.wan=interface
set network.wan.device=${WAN_IFACE}
set network.wan.proto=dhcp
set network.wan6=interface
set network.wan6.device=${WAN_IFACE}
set network.wan6.proto=dhcpv6
EOF

for p in $LAN_PORTS; do
    ip link show "$p" >/dev/null 2>&1 \
        && uci add_list network.lan_dev.ports="$p" \
        || echo "Warning: $p not found"
done

uci commit network || { echo "Error: network commit failed"; exit 1; }

# 防火墙 wan 区域（动态查找，不硬编码索引）
WZ=""
i=0
while uci -q get "firewall.@zone[$i]" >/dev/null 2>&1; do
    [ "$(uci -q get "firewall.@zone[$i].name")" = "wan" ] && WZ=$i && break
    i=$((i+1))
done
if [ -n "$WZ" ]; then
    uci -q del_list "firewall.@zone[${WZ}].network=wan6" 2>/dev/null || true
    uci -q del_list "firewall.@zone[${WZ}].network=wan"  2>/dev/null || true
    uci add_list "firewall.@zone[${WZ}].network=wan"
    uci add_list "firewall.@zone[${WZ}].network=wan6"
    uci commit firewall
fi

# 系统基础设置
uci -q batch << EOF
set system.@system[0].hostname=OpenWrt-360V6
set system.@system[0].timezone=CST-8
set system.@system[0].zonename=Asia/Shanghai
EOF
uci commit system

echo "=== done ==="
exit 0
