#!/bin/sh
# 360V6 (IPQ6000) 首次启动网络配置
# 兼容 VIKINGYFY fork 新内核（eth0~eth4）和旧内核（lan1~lan4/wan）DSA 命名
LOG="/tmp/firstboot-network.log"
exec >> "$LOG" 2>&1
echo "=== firstboot network setup: $(date) ==="

# 等待网络接口就绪（最多 15 秒）
READY=false
for i in $(seq 1 15); do
    if ip link show eth0 >/dev/null 2>&1 || ip link show lan1 >/dev/null 2>&1; then
        READY=true
        break
    fi
    sleep 1
done
[ "$READY" = "false" ] && echo "Warning: network interfaces not ready after 15s"

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
# 使用独立 uci 命令避免 heredoc 在部分 busybox 版本下的兼容问题
uci -q delete network.lan_dev
uci set network.lan_dev=device
uci set network.lan_dev.name=br-lan
uci set network.lan_dev.type=bridge

uci set network.lan=interface
uci set network.lan.device=br-lan
uci set network.lan.proto=static
uci set network.lan.ipaddr=192.168.1.1
uci set network.lan.netmask=255.255.255.0
uci set network.lan.ip6assign=60

uci set network.wan=interface
uci set network.wan.device="$WAN_IFACE"
uci set network.wan.proto=dhcp

uci set network.wan6=interface
uci set network.wan6.device="$WAN_IFACE"
uci set network.wan6.proto=dhcpv6

for p in $LAN_PORTS; do
    if ip link show "$p" >/dev/null 2>&1; then
        uci add_list network.lan_dev.ports="$p"
    else
        echo "Warning: interface $p not found, skipping"
    fi
done

uci commit network || { echo "Error: network commit failed"; exit 1; }
echo "Network config committed"

# 防火墙 wan 区域（动态查找索引，不硬编码）
WZ=""
i=0
while uci -q get "firewall.@zone[$i]" >/dev/null 2>&1; do
    if [ "$(uci -q get "firewall.@zone[$i].name")" = "wan" ]; then
        WZ=$i
        break
    fi
    i=$((i+1))
done

if [ -n "$WZ" ]; then
    uci -q del_list "firewall.@zone[${WZ}].network=wan6" 2>/dev/null || true
    uci -q del_list "firewall.@zone[${WZ}].network=wan"  2>/dev/null || true
    uci add_list "firewall.@zone[${WZ}].network=wan"
    uci add_list "firewall.@zone[${WZ}].network=wan6"
    uci commit firewall || echo "Warning: firewall commit failed"
    echo "Firewall wan zone updated (index $WZ)"
else
    echo "Warning: firewall wan zone not found"
fi

# 系统基础设置
uci set system.@system[0].hostname=OpenWrt-360V6
uci set system.@system[0].timezone=CST-8
uci set system.@system[0].zonename=Asia/Shanghai
uci commit system || echo "Warning: system commit failed"

echo "=== firstboot network setup done ==="
exit 0
