 <h1 align="center"> <summary>
      
### [Bypass WiFi Anti-Tethering (TTL /HL=1)](https://github.com/xiv3r/anti-tethering-bypasser)
   
10.0.0.1 ttl=1

👇

Openwrt/Linux WiFi Repeater/Extender mode

👇

10.0.0.1 ttl=64

</summary> </h1>

# Auto Install for Linux
   
    sudo apt update ; sudo apt install curl ; curl https://raw.githubusercontent.com/xiv3r/bypass-anti-tethering/refs/heads/main/install.sh | sudo sh

# Auto Install for OpenWRT

    opkg update ; opkg install curl ; curl https://raw.githubusercontent.com/xiv3r/bypass-anti-tethering/refs/heads/main/install.sh | sh

    
### Note!
- Connect your Router/PC to Internet for Installation.
- Configure your router or pc to Extender/Repeater Mode and done!.
- Openwrt iptables `NAT`  doesn't work properly on version 1.8.7.
- Applicable only for openwrt router, linux and rooted phones.
- Take note that the `wlan0` is your `ISP` and the destination is `eth0`.

# IPTables and IP6Tables to Bypass Anti-Tethering Restriction

```
# IPTABLES for IPv4 WISP with Anti-Tethering

# Change incoming TTL=1 to TTL=65 on wlan0
iptables -t mangle -A PREROUTING -i wlan0 -j TTL --ttl-set 65
iptables -t mangle -A POSTROUTING -o wlan0 -j TTL --ttl-set 64

# Enable NAT (Masquerade) for eth0
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# Allow forwarding between wlan0 and eth0
iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth0 -o wlan0 -j ACCEPT

#__________________________________________________________________

# IP6TABLES for IPv6 WISP with Anti-Tethering

# Change incoming hop limit=1 to hop limit=65 on wlan0
ip6tables -t mangle -A PREROUTING -i wlan0 -j HL --hl-set 65
ip6tables -t mangle -A POSTROUTING -o wlan0 -j HL --hl-set 64

# Allow forwarding between wlan0 and eth0
ip6tables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
ip6tables -A FORWARD -i eth0 -o wlan0 -j ACCEPT

```

## How to check?
• IPv4 iptables
    
    iptables -vnL --line-numbers

• IPv6 ip6tables
   
    ip6tables -vnL ---line-numbers

# Features
- Bypass ISP Hotspot sharing restriction
- Support 65 Hops Nodes
- Can Shared or tethered across multiple devices
- Free Internet
    
# Tested on
- Termux Custom Bridge interfaces
- All OpenWRT/XWRT/IMWRT
- All Debian based Distros
- All Arch based Distro
- Almost all OS supported by Iptables

## How to clear Iptables existing rules?
• IPv4 iptables
    
    iptables -F
    iptables -t mangle -F
    
• IPv6 ip6tables
   
    ip6tables -F
    ip6tables -t mangle -F

    
