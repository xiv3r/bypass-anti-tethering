 <h1 align="center"><summary>
  
### [Bypass WiFi Anti-Tethering (TTL /HL=1)](https://github.com/xiv3r/anti-tethering-bypasser)

</summary></h1>

<h4 align="center">
 
   Wireless Sharing Protection (anti-tethering) is a mechanism employed by wisp carriers to restrict tethering or hotspot sharing on wifi users by modifying the interface broadcast ttl value to 1 hops. To circumvent these restrictions, iptables can be utilized to modify network traffic characteristics, allowing users to bypass wireless sharing protection (anti-tethering) effectively.

<h1 align="center">
 
 10.0.0.1 ttl=1

👇

Openwrt/Linux WiFi Repeater/Extender mode

👇

10.0.0.1 ttl=64
 </h1>
 
 <h1 align="center"> Using IPTABLES & IP6TABLES </h1>
 

# Auto Install IPTABLES for Linux distro
```sh
 sudo apt update ; wget -qO- https://raw.githubusercontent.com/xiv3r/bypass-anti-tethering/refs/heads/main/install.sh | sudo sh
```
# Auto Install IPTABLES/IP6TABLES for OpenWRT router
```sh
opkg update ; wget -qO- https://raw.githubusercontent.com/xiv3r/bypass-anti-tethering/refs/heads/main/install.sh | sh
```
# Android
> need root

[https://github.com/Mygod/VPNHotspot/](https://github.com/Mygod/VPNHotspot/)

# Note
> [!Note]
> Connect your Router/PC to Internet for Installation.
> Configure your router or pc to Extender/Repeater Mode and done!.
> Openwrt iptables `NAT`  doesn't work properly on version 1.8.7.
> Applicable only for openwrt router, linux and rooted phones.
> Take note that the `wlan0` is your `ISP` and the destination is `eth0`.
> Check your interfaces before proceeding to auto install otherwise if doesn't match you need to manually edit wlan0 and eth0 to your current interface where the traffic goes on.

# IPTables and IP6Tables to Bypass Tethering Restriction
> interface is unspecified so that all incoming packets will be altered and mangled before prerouting decision is made 
```sh
# IPTABLES for IPv4 (recommended)
# _______________________________

iptables -F
iptables -t nat -F
iptables -t mangle -F

# Change incoming TTL=1 to TTL=64
iptables -t mangle -A PREROUTING -j TTL --ttl-set 64


# Enable NAT (Masquerade) for eth0
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# Allow forwarding between wlan0 and eth0
iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth0 -o wlan0 -j ACCEPT

# IP6TABLES for IPv6 (optional)
# _____________________________

ip6tables -F
ip6tables -t mangle -F

# Change incoming hop limit=1 to hop limit=64
ip6tables -t mangle -A PREROUTING -j HL --hl-set 64
```

# How to check?
• IPv4 iptables
```sh
iptables -vnL --line-numbers
```
• IPv6 ip6tables
```sh
ip6tables -vnL ---line-numbers
```
# Features
- Bypass ISP Hotspot sharing restriction (allow tethering)
- Support 64 Hop Nodes
- Can Shared or tethered across multiple devices
    
# Tested on
- All OpenWRT Router
- All Linux distros

# How to clear Iptables existing rules?
• IPv4 iptables
```sh
iptables -F
iptables -t mangle -F
 ```   
• IPv6 ip6tables
```sh
ip6tables -F
ip6tables -t mangle -F
```

<h1 align="center"> Using NFTABLES </h1>

To achieve the setup where incoming packets with TTL=1 on the wlan0 interface are modified to have TTL=64 and forwarded to the eth0 interface, and the outgoing packets are modified with TTL=64 when sent back from eth0 to wlan0, you can configure nftables as follows:

# Setup
> [!Note]
> Connect your Router/PC to Internet for Installation.
> Configure your router to Extender/Repeater Mode.
> Openwrt iptables `NAT POSTROUTING`  doesn't work properly on version 1.8.7.
> Applicable only for openwrt router, linux and rooted phones.
> Take note that the `wlan0` is your `ISP` and the destination is `eth0/LAN`.
> Check your interfaces before proceeding to auto install otherwise if doesn't match you need to manually edit wlan0 and eth0 to your current interface where the traffic goes on.

 
# Auto Install Nftables ttl64.nft for Openwrt (stable & recommended)
> `fw4 check passed`

> built-in from fw4 firewall

> support `ipv4` ISP

> support `ipv6` ISP 
```sh
wget -qO- https://raw.githubusercontent.com/xiv3r/anti-tethering-bypasser/refs/heads/main/ttl64.sh | sh
```

# Auto install for Linux
```sh
sudo apt update ; wget -qO- https://raw.githubusercontent.com/xiv3r/bypass-anti-tethering/refs/heads/main/nftable.sh | sudo sh
```
# Auto install for Openwrt using Nftables.conf (ipv4 only)
```sh
opkg update ; wget -qO- https://raw.githubusercontent.com/xiv3r/bypass-anti-tethering/refs/heads/main/nftable.sh | sh
```

```sh
# NFTABLE for IPv4 (recommended)
# ______________________________

nft add table inet custom_table
# Prerouting: Change TTL on incoming packets from wlan0
nft add chain inet custom_table prerouting { type filter hook prerouting priority 0 \; }
nft add rule inet custom_table prerouting iif "wlan0" ip ttl set 65

# Postrouting: Enable masquerading on eth0 and set outgoing TTL for wlan0
nft add chain inet custom_table postrouting { type nat hook postrouting priority 100 \; }
nft add rule inet custom_table postrouting oif "eth0" masquerade
nft add rule inet custom_table postrouting oif "wlan0" ip ttl set 64

# Forwarding: Allow traffic between wlan0 and eth0 in both directions
nft add chain inet custom_table forward { type filter hook forward priority 0 \; }
nft add rule inet custom_table forward iif "wlan0" oif "eth0" accept
nft add rule inet custom_table forward iif "eth0" oif "wlan0" accept
```
# Check existing ruleset
```sh
nftables list ruleset && nft list ruleset
```

# Using nftables.nft (recommended)
> /etc/nftables.d/
```sh
chain mangle_prerouting_ttl64 {
  type filter hook prerouting priority 300; policy accept;
   counter ip ttl set 64
   counter ip6 hoplimit set 64
}
```

<img src="https://github.com/xiv3r/anti-tethering-bypasser/blob/main/Nftables.nft.png">

# Check nftables existing ruleset
```sh
fw4 check && nft list ruleset
```
## Explanation

> Prerouting chain: Incoming packets on wlan0 with TTL=1 are changed to TTL=64 before forwarding.

> Postrouting chain: Outgoing packets through wlan0 are set to TTL=64.

> Forward chain: Allows forwarding between wlan0 and eth0 in both directions.

<h1 align="center">Windows
</h1>

```sh
netsh int ipv4 set glob defaultcurhoplimit=65
netsh int ipv6 set glob defaultcurhoplimit=65
```
