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

# Flush all rules int the nat table
echo "iptables -t nat -F" >> /etc/rc.local

# IPTABLES for IPv4
# Change incoming TTL=1 to TTL=64 on wlan0
echo "iptables -t mangle -A PREROUTING -i wlan0 -m ttl --ttl-eq 1 -j TTL --ttl-set 64

# Allow forwarding between wlan0 and eth0
echo "iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT" >> /etc/rc.local
echo "iptables -A FORWARD -i eth0 -o wlan0 -j ACCEPT" >> /etc/rc.local

# Enable NAT (Masquerade) for eth0
echo "iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE" >> /etc/rc.local

# Forward Chain
echo "iptables -P FORWARD ACCEPT" >> /etc/rc.local

#__________________________________________

# Flush ip6tables filter table
echo "ip6tables -F" >> /etc/rc.local

# Flush ip6tables mangle table
echo "ip6tables -t mangle -F" >> /etc/rc.local

# IP6TABLES for IPv6
# Change incoming hop limit=1 to hop limit=64 on wlan0
echo "ip6tables -t mangle -A PREROUTING -i wlan0 -m hl --hl-eq 1 -j HL --hl-set 64" >> /etc/rc.local

# Allow forwarding between wlan0 and eth0
echo "ip6tables -A FORWARD -i wlan0 -o eth0 -j ACCEPT" >> /etc/rc.local
echo "ip6tables -A FORWARD -i eth0 -o wlan0 -j ACCEPT" >> /etc/rc.local

# Forward Chain 
echo "ip6tables -P FORWARD ACCEPT" >> /etc/rc.local

echo "exit 0" >> /etc/rc.local

chmod +x /etc/rc.local

echo "Done Installing iptables and ip6tables to /etc/rc.local..."

echo "Required router reboot to apply the settings"
