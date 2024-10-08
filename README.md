 <h1 align="center"> <summary>
      
### [Bypass WiFi Anti-Tethering (TTL /HL=1)](https://github.com/xiv3r/anti-tethering-bypasser)
   
10.0.0.1 ttl=1 => WiFi Repeater/Extender => 10.0.0.1 ttl=64
</summary> </h1>

# Auto Install for Linux
   
    sudo apt update ; sudo apt install curl ; curl https://raw.githubusercontent.com/xiv3r/bypass-anti-tethering/refs/heads/main/install.sh | sudo sh

# Auto Install for OpenWRT

    opkg update ; opkg install curl ; curl https://raw.githubusercontent.com/xiv3r/bypass-anti-tethering/refs/heads/main/install.sh | sh
    

### Note!
- Openwrt iptables `NAT`  doesn't work properly on version 1.8.7.
- Applicable only for openwrt router, linux and rooted phones.
- Take note that the `wlan0` is your `ISP` and the destination is `eth0`.

# IPv4 IPTables and IPv6 IP6Tables to extend TTL/HL=1 into TTL/HL=64

```
# IPv4 Iptables
# Flush all rules in the filter table
iptables -F

# Flush all rules in the mangle table
iptables -t mangle -F

#Setting TTL for incoming traffic on wlan0
iptables -t mangle -A PREROUTING -i wlan0 -j TTL --ttl-set 64

#Setting TTL for outgoing traffic on wlan0
iptables -t mangle -A POSTROUTING -o wlan0 -j TTL --ttl-set 64

# Allow forwarding of packets from wlan0 to br-lan
iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT

# Allow forwarding of packets br-lan to wlan0
iptables -A FORWARD -i eth0 -o wlan0 -j ACCEPT

# Allow Loop Back
iptables -A INPUT -i wlan0 -j ACCEPT
iptables -A OUTPUT -o wlan0 -j ACCEPT
iptables -A INPUT -i eth0 -j ACCEPT
iptables -A OUTPUT -o eth0 -j ACCEPT

# Ensure FORWARD chain policy is set to ACCEPT
iptables -P FORWARD ACCEPT

##___________________________________________________

#IPv6 Ip6tables
# Flush all rules in the filter table
ip6tables -F

# Flush all rules in the mangle table
ip6tables -t mangle -F

# Setting TTL for incoming traffic on wlan0
ip6tables -t mangle -A PREROUTING -i wlan0 -j HL --hl-set 64

# Setting TTL for outgoing traffic on wlan0
ip6tables -t mangle -A POSTROUTING -o wlan0 -j HL --hl-set 64

# Allow forwarding of packets from wlan0 to br-lan
ip6tables -A FORWARD -i wlan0 -o eth0 -j ACCEPT

# Allow forwarding of packets from br-lan to wlan0
ip6tables -A FORWARD -i eth0 -o wlan0 -j ACCEPT

# Allow Loop Back
ip6tables -A INPUT -i wlan0 -j ACCEPT
ip6tables -A OUTPUT -o wlan0 -j ACCEPT
ip6tables -A INPUT -i eth0 -j ACCEPT
ip6tables -A OUTPUT -o eth0 -j ACCEPT

# Ensure FORWARD chain policy is set to ACCEPT
ip6tables -P FORWARD ACCEPT

exit 0
```

## How to check?
• IPv4 iptables
    
    iptables -vnL --line-numbers

• IPv6 ip6tables
   
    ip6tables -vnL ---line-numbers
    

## How to clear Iptables existing rules?
• IPv4 iptables
    
    iptables -F
    iptables -t mangle -F
    
• IPv6 ip6tables
   
    ip6tables -F
    ip6tables -t mangle -F

    
