<h1 align="center">
 
   Anti-Tethering bypasser allow you to expand the network even if your isp restricts the tethering to 1 hop. By increasing the ttl value using iptables and nftables allows you to bypass the restriction.
<h1 align="center">
 
 10.0.0.1 ttl=1

👇

Openwrt/Linux WiFi Repeater/Extender mode

👇

10.0.0.1 ttl=64
 </h1>
 
 <h1 align="center"> Using IPTABLES & IP6TABLES </h1>
 

### Auto Install IPTABLES for Linux distro
```sh
 sudo apt update && wget -qO- https://raw.githubusercontent.com/xiv3r/bypass-anti-tethering/refs/heads/main/install | sudo bash
```
### Auto Install IPTABLES/IP6TABLES for OpenWRT router
```sh
opkg update && opkg install bash wget && wget -qO- https://raw.githubusercontent.com/xiv3r/bypass-anti-tethering/refs/heads/main/install | bash
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
iptables -t mangle -F

# Change incoming TTL=1 to TTL=64
iptables -t mangle -A PREROUTING -j TTL --ttl-set 64

# IP6TABLES for IPv6 (optional)
# _____________________________
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
wget -qO- https://raw.githubusercontent.com/xiv3r/anti-tethering-bypasser/refs/heads/main/ttl64 | bash
```

# Auto install for Linux
```sh
sudo apt update ; wget -qO- https://raw.githubusercontent.com/xiv3r/bypass-anti-tethering/refs/heads/main/nftable | sudo bash
```
# Auto install for Openwrt using Nftables
```sh
opkg update && opkg install wget bash ; wget -qO- https://raw.githubusercontent.com/xiv3r/bypass-anti-tethering/refs/heads/main/nftable | bash
```

```sh
chain mangle_prerouting_ttl64 {
    type filter hook prerouting priority 300; policy accept;
    ip ttl set 64
    ip6 hoplimit set 64
}
```

# Check the existing ruleset
```sh
nftables list ruleset && nft list ruleset
```

# For cli
```
nft 'add table inet mangle'

nft 'add chain inet mangle mangle_prerouting_ttl64 { type filter hook prerouting priority 300; policy accept; }'

nft 'add rule inet mangle mangle_prerouting_ttl64 ip ttl set 64'

nft 'add rule inet mangle mangle_prerouting_ttl64 ip6 hoplimit set 64'
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

```
netsh int ipv4 set glob defaultcurhoplimit=64
netsh int ipv6 set glob defaultcurhoplimit=64
```
> alternative
```
netsh interface ipv4 set global ttl=64
netsh interface ipv6 set global ttl=64
```
