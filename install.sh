#!/bin/sh

# List of packages to install on OpenWRT
OPENWRT_PACKAGES="iptables-mod-ipopt kmod-ipt-ipopt kmod-ipt-nat iptables-zz-legacy iptables ip6tables ip6tables-zz-legacy ip6tables-mod-nat kmod-ipt-nat6 kmod-ip6tables"

# List of packages to install on generic Linux (Debian-based)
GENERIC_LINUX_PACKAGES="iptables"

# Function to detect OpenWRT
is_openwrt() {
    [ -f /etc/openwrt_release ]
}

# Function to detect Debian-based Linux
is_debian() {
    [ -f /etc/debian_version ]
}

# Function to install packages on OpenWRT
install_openwrt_packages() {
    echo "Installing Dependencies on OpenWRT: $OPENWRT_PACKAGES"
    opkg install $OPENWRT_PACKAGES
}

# Function to install packages on Debian-based Linux
install_generic_linux_packages() {
    echo "Installing Dependencies on Linux: $GENERIC_LINUX_PACKAGES"
    sudo apt install -y $GENERIC_LINUX_PACKAGES
}

# Main logic
if is_openwrt; then
    echo "OpenWRT detected."
    install_openwrt_packages
elif is_debian; then
    echo "Debian-based Linux detected."
    install_generic_linux_packages
else
    echo "Unsupported OS. This script is intended for OpenWRT or Debian-based Linux."
    exit 1
fi

# Ipv4 and Ipv6 Forwarding
echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.conf
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

echo "Installing iptables rule in /etc/rc.local..."
sed -i 's/exit 0//' /etc/rc.local

# Header
echo "#!/bin/bash" >>/etc/rc.local

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
echo "iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT" >> /etc/rc.local

# Allow forwarding of packets br-lan to wlan0
echo "iptables -A FORWARD -i eth0 -o wlan0 -j ACCEPT" >> /etc/rc.local

echo "iptables -A INPUT -i wlan0 -j ACCEPT" >> /etc/rc.local
echo "iptables -A OUTPUT -o wlan0 -j ACCEPT" >> /etc/rc.local
echo "iptables -A INPUT -i eth0 -j ACCEPT" >> /etc/rc.local
echo "iptables -A OUTPUT -o eth0 -j ACCEPT" >> /etc/rc.local

# Ensure FORWARD chain policy is set to ACCEPT
echo "iptables -P FORWARD ACCEPT" >> /etc/rc.local

#IPv6 Ip6tables
echo "Installing Ip6tables rule in /etc/rc.local..."

# Flush all rules in the filter table
echo "ip6tables -F" >> /etc/rc.local

# Flush all rules in the mangle table
echo "ip6tables -t mangle -F" >> /etc/rc.local

# Setting TTL for incoming traffic on wlan0
echo "ip6tables -t mangle -A PREROUTING -i wlan0 -j HL --hl-set 64" >> /etc/rc.local

# Setting TTL for outgoing traffic on wlan0
echo "ip6tables -t mangle -A POSTROUTING -o wlan0 -j HL --hl-set 64" >> /etc/rc.local

# Allow forwarding of packets from wlan0 to br-lan
echo "ip6tables -A FORWARD -i wlan0 -o eth0 -j ACCEPT" >> /etc/rc.local

# Allow forwarding of packets from br-lan to wlan0
echo "ip6tables -A FORWARD -i eth0 -o wlan0 -j ACCEPT" >> /etc/rc.local

echo "ip6tables -A INPUT -i wlan0 -j ACCEPT" >> /etc/rc.local
echo "ip6tables -A OUTPUT -o wlan0 -j ACCEPT" >> /etc/rc.local
echo "ip6tables -A INPUT -i eth0 -j ACCEPT" >> /etc/rc.local
echo "ip6tables -A OUTPUT -o eth0 -j ACCEPT" >> /etc/rc.local

# Ensure FORWARD chain policy is set to ACCEPT
echo "ip6tables -P FORWARD ACCEPT" >> /etc/rc.local

echo "exit 0" >> /etc/rc.local

chmod +x /etc/rc.local

echo "Done Installing iptables and ip6tables into /etc/rc.local..."

echo "Required router reboot to apply the settings"
