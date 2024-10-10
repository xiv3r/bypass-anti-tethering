#!/bin/sh

# List of packages to install on OpenWRT
OPENWRT_PACKAGES="nftables kmod-nft-nat kmod-nft-core kmod-nft-nat kmod-nfnetlink"
# List of packages to install on generic Linux (Debian-based)
GENERIC_LINUX_PACKAGES="nftables"

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

echo "adding nftables to /etc/nftables.conf"

echo "#!/bin/sh" > /etc/nftables.conf

# NFTABLE for IPv4 (recommended)
# ______________________________

echo "nft add table inet custom_table" >> /etc/nftables.conf
# Prerouting: Change TTL on incoming packets from wlan0
echo "nft add chain inet custom_table prerouting { type filter hook prerouting priority 0 \; }" >> /etc/nftables.conf
echo "nft add rule inet custom_table prerouting iif "wlan0" ip ttl set 65" >> /etc/nftables.conf

# Postrouting: Enable masquerading on eth0 and set outgoing TTL for wlan0
echo "nft add chain inet custom_table postrouting { type nat hook postrouting priority 100 \; }" >> /etc/nftables.conf
echo "nft add rule inet custom_table postrouting oif "eth0" masquerade" >> /etc/nftables.conf
echo "nft add rule inet custom_table postrouting oif "wlan0" ip ttl set 64" >> /etc/nftables.conf

# Forwarding: Allow traffic between wlan0 and eth0 in both directions
echo "nft add chain inet custom_table forward { type filter hook forward priority 0 \; }" >> /etc/nftables.conf
echo "nft add rule inet custom_table forward iif "wlan0" oif "eth0" accept" >> /etc/nftables.conf
echo "nft add rule inet custom_table forward iif "eth0" oif "wlan0" accept" >> /etc/nftables.conf

# NFTABLE for IPv6 (optional)
# ___________________________

# Prerouting: Change HL=1 to HL=64 on incoming packets from wlan0
echo "nft add chain inet custom_table prerouting { type filter hook prerouting priority 0 \; }" >> /etc/nftables.conf
echo "nft add rule inet custom_table prerouting iif "wlan0" ip6 hl set 65" >> /etc/nftables.conf

# Postrouting: Enable masquerading on eth0 and set outgoing HL for wlan0
echo "nft add chain inet custom_table postrouting { type nat hook postrouting priority 100 \; }" >> /etc/nftables.conf
# nft add rule inet custom_table postrouting oif "eth0" masquerade
echo "nft add rule inet custom_table postrouting oif "wlan0" ip6 hl set 64" >> /etc/nftables.conf

# Forwarding: Allow traffic between wlan0 and eth0 in both directions
# nft add chain inet custom_table forward { type filter hook forward priority 0 \; }
# nft add rule inet custom_table forward iif "wlan0" oif "eth0" accept
# nft add rule inet custom_table forward iif "eth0" oif "wlan0" accept

chmod +x /etc/nftables.conf
sh /etc/nftables.conf

echo "Done installing config to /etc/nftables.conf"
echo "nftable is running now on wlan0 to eth0 with a ttl=64"
