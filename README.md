# Anti Tethering Bypasser
Anti tethering bypass tool that allows you to expand the network even if your isp restricts the tethering limiy to 1 hop. By increasing the ttl value using iptables and nftables allows you to bypass the restriction.

<h1 align="center">
10.0.0.1 ttl=1

👇

Openwrt/Linux WiFi Repeater/Extender Mode

👇

10.0.0.1 ttl=64
 </h1>
 
# Using IPTABLES & IP6TABLES
- Linux distro
```
 sudo apt update && wget -qO- https://raw.githubusercontent.com/xiv3r/bypass-anti-tethering/refs/heads/main/install | sudo bash
```
- OpenWRT
```
opkg update && opkg install bash wget && wget -qO- https://raw.githubusercontent.com/xiv3r/bypass-anti-tethering/refs/heads/main/install | bash
```

# Android
> Root is needed 
[https://github.com/Mygod/VPNHotspot/](https://github.com/Mygod/VPNHotspot/)

# IPTables and IP6Tables config
> interface is unspecified so that all incoming packets will be altered and mangled before prerouting decision is made.
```
# IPTABLES for IPv4
iptables -t mangle -F

# Change incoming TTL=1 to TTL=64
iptables -t mangle -I PREROUTING -j TTL --ttl-set 64

# IP6TABLES for IPv6
ip6tables -t mangle -F

# Change incoming hop limit=1 to hop limit=64
ip6tables -t mangle -I PREROUTING -j HL --hl-set 64
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
- Bypass WiFi Hotspot ttl=1 hop limit (allow tethering)
    
# Tested on
- All OpenWRT Routers
- All Linux Distros

# Clear Iptables
• IPv4 iptables
```
iptables -F
iptables -t mangle -F
 ```   
• IPv6 ip6tables
```
ip6tables -F
ip6tables -t mangle -F
```

-----------------

# NFTABLES
 - Nftables (stable & recommended)
> `fw4 check passed`

> built-in from fw4 firewall

> support `ipv4`

> support `ipv6` 
```
wget -qO- https://raw.githubusercontent.com/xiv3r/bypass-anti-tethering/refs/heads/main/nftables | bash
```

# Install for Linux
```
sudo apt update && wget -qO- https://raw.githubusercontent.com/xiv3r/bypass-anti-tethering/refs/heads/main/nftables | sudo bash
```
# Install for Openwrt
```sh
opkg update && opkg install wget bash ; wget -qO- https://raw.githubusercontent.com/xiv3r/bypass-anti-tethering/refs/heads/main/nftables | bash
```
# Nftables config
```
chain mangle_prerouting_ttl64 {
                type filter hook prerouting priority 300; policy accept;
                ip ttl set 64
                ip6 hoplimit set 64
        }
```

# Check the ruleset
```
nft list ruleset
```

<img src="https://github.com/xiv3r/anti-tethering-bypasser/blob/main/Nftables.nft.png">

# Check nftables existing ruleset
```
nft list ruleset
```
------------
# Windows
```
netsh int ipv4 set glob defaultcurhoplimit=64
netsh int ipv6 set glob defaultcurhoplimit=64
```
> alternative
```
netsh interface ipv4 set global ttl=64
netsh interface ipv6 set global ttl=64
```
