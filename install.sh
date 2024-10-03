# Linux dependencies
sudo apt update ; sudo apt install iptables -y

# Openwrt dependcies
opkg install iptables-mod-ipopt kmod-ipt-ipopt kmod-ipt-nat iptables-zz-legacy iptables ip6tables ip6tables-zz-legacy ip6tables-mod-nat kmod-ipt-nat6 kmod-ip6tables

echo "#!/bin/bash" >> /etc/rc.local
# Clearing rc.local
echo "" > /etc/rc.local
# IPv4 Iptables
# Flush all rules in the filter table
echo "iptables -F" >> /etc/rc.local

# Flush all rules in the mangle table
echo "iptables -t mangle -F" >> /etc/rc.local

#Setting TTL for incoming traffic on wlan0
echo "iptables -t mangle -A PREROUTING -i wlan0 -j TTL --ttl-set 64" >> /etc/rc.local

#Setting TTL for outgoing traffic on wlan0
echo "iptables -t mangle -A POSTROUTING -o wlan0 -j TTL --ttl-set 64" >> /etc/rc.local

# Allow forwarding of packets from wlan0 to br-lan
echo "iptables -A FORWARD -i wlan0 -o br-lan -j ACCEPT" >> /etc/rc.local

# Allow forwarding of packets br-lan to wlan0
echo "iptables -A FORWARD -i br-lan -o wlan0 -j ACCEPT" >> /etc/rc.local

# Ensure FORWARD chain policy is set to ACCEPT
echo "iptables -P FORWARD ACCEPT" >> /etc/rc.local

#IPv6 Ip6tables
# Flush all rules in the filter table
echo "ip6tables -F" >> /etc/rc.local

# Flush all rules in the mangle table
echo "ip6tables -t mangle -F" >> /etc/rc.local

# Setting TTL for incoming traffic on wlan0
echo "ip6tables -t mangle -A PREROUTING -i wlan0 -j HL --hl-set 64" >> /etc/rc.local

# Setting TTL for outgoing traffic on wlan0
echo "ip6tables -t mangle -A POSTROUTING -o wlan0 -j HL --hl-set 64" >> /etc/rc.local

# Allow forwarding of packets from wlan0 to br-lan
echo "ip6tables -A FORWARD -i wlan0 -o br-lan -j ACCEPT" >> /etc/rc.local

# Allow forwarding of packets from br-lan to wlan0
echo "ip6tables -A FORWARD -i br-lan -o wlan0 -j ACCEPT" >> /etc/rc.local

# Ensure FORWARD chain policy is set to ACCEPT
echo "ip6tables -P FORWARD ACCEPT" >> /etc/rc.local

echo "exit 0" >> /etc/rc.local

chmod +x /etc/rc.local
