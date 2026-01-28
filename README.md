# Bypass Anti Tethering
Anti tethering bypass tool allows you to expand the network even if your isp restricts the tethering limit to 1 ttl/hop. By increasing the ttl value using iptables or nftables you can bypass the restrictions.

<h3 align="center">
10.0.0.1 ttl=1

👇

Openwrt/Linux WiFi Repeater/Extender Mode

👇

10.0.0.1 ttl=64
 </h1>

 
# Android
> Root is needed 
[https://github.com/Mygod/VPNHotspot/](https://github.com/Mygod/VPNHotspot/)
## Android terminal CLI
```
iptables -t mangle -A PREROUTING -j TTL --ttl-set 64
```

# IPTABLES & IP6TABLES 
> Optional

- ## Auto install for Linux distro
```
sudo apt update && sudo apt install wget -y && wget -qO- https://raw.githubusercontent.com/xiv3r/bypass-anti-tethering/refs/heads/main/iptables-linux| sudo bash
```
- ## Auto install for OpenWRT
```
apk update && apk install wget && wget -qO- https://raw.githubusercontent.com/xiv3r/bypass-anti-tethering/refs/heads/main/iptables-openwrt | sh
```

# IPTables and IP6Tables config
> interface is unspecified so that all incoming packets will be altered and mangled before prerouting decision is made.
```
# Change ipv4 incoming ttl=1 to ttl=64
iptables -t mangle -A PREROUTING -j TTL --ttl-set 64

# Change ipv6 incoming ttl=1 to ttl=64
ip6tables -t mangle -A PREROUTING -j HL --hl-set 64
```

# How to Check?
• IPv4 iptables
```
iptables -vnL --line-numbers
```
• IPv6 ip6tables
```
ip6tables -vnL ---line-numbers
```

-----------------

# NFTABLES
> Nftables (stable & recommended)
   
- ## Auto Install for Linux Distro 
```
sudo apt update && sudo apt install -y nftables wget && wget -qO- https://raw.githubusercontent.com/xiv3r/bypass-anti-tethering/refs/heads/main/nftables | sudo bash
```
- ## Auto Install for Openwrt
```sh
opkg update && opkg install wget && wget -qO- https://raw.githubusercontent.com/xiv3r/bypass-anti-tethering/refs/heads/main/nftables | sh
```
# Nftables config
```
chain mangle_prerouting_ttl64 {
                type filter hook prerouting priority 300; policy accept;
                ip ttl set 64
                ip6 hoplimit set 64
        }
```

# Check ruleset
```
nft list ruleset
```

<img src="https://github.com/xiv3r/anti-tethering-bypasser/blob/main/Nftables.nft.png">

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
