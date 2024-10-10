#!/bin/sh

opkg install nftables kmod-nft-nat kmod-nft-core kmod-nft-nat kmod-nfnetlink
apt install nftable -y

echo "adding nftables to /etc/nftables.conf"

echo "#!/bin/sh" > /etc/nftables.conf
echo "nft add table inet custom_table" >> /etc/nftables.conf

# Prerouting: Change TTL on incoming packets from wlan0
echo "nft add chain inet custom_table prerouting { type filter hook prerouting priority 0 \; }" >> /etc/nftables.conf
echo "nft add rule inet custom_table prerouting iif "wlan0" ip ttl set 64" >> /etc/nftables.conf

# Postrouting: Enable masquerading on eth0 and set outgoing TTL for wlan0
echo "nft add chain inet custom_table postrouting { type nat hook postrouting priority 100 \; }" >> /etc/nftables.conf
echo "nft add rule inet custom_table postrouting oif "eth0" masquerade" >> /etc/nftables.conf
echo "nft add rule inet custom_table postrouting oif "wlan0" ip ttl set 64" >> /etc/nftables.conf

# Forwarding: Allow traffic between wlan0 and eth0 in both directions
echo "nft add chain inet custom_table forward { type filter hook forward priority 0 \; }" >> /etc/nftables.conf
echo "nft add rule inet custom_table forward iif "wlan0" oif "eth0" accept" >> /etc/nftables.conf
echo "nft add rule inet custom_table forward iif "eth0" oif "wlan0" accept" >> /etc/nftables.conf

chmod +x /etc/nftables.conf
echo "Done installing config to /etc/nftables.conf"
echo "Required router reboot to apply the settings"
echo "Rebooting...!"
reboot
