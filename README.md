 <h1 align="center"> <summary>
      
### [Bypass WiFi Anti-Tethering (TTL /HL=1)](https://github.com/xiv3r/anti-tethering-bypasser)
   
10.0.0.1 ttl=1 => WiFi Repeater/Extender => 10.0.0.1 ttl=64
</summary> </h1>

## Dependencies 
   - linux

    sudo apt update ; sudo apt install iptables ip6tables -y
  
   - openwrt
   
    opkg update ; opkg install iptables ip6tables

### Note!
- Iptables `NAT` works properly on version 1.8.10
- Run permanently after Boot `nano /etc/rc.local` after that `chmod +x /etc/rc.local`.
- Applicable only for openwrt router, linux, rooted phones.
- Need to replace `br-lan` into `eth0` if you're not using openwrt and `br0` for mobile hotspot.
- Take not that the `wlan0` is your `ISP` and the destination is `br-lan/eth0/br0`.

# Iptables | Ip6tables for IPv4 and IPv6

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
iptables -A FORWARD -i wlan0 -o br-lan -j ACCEPT

# Allow forwarding of packets br-lan to wlan0
iptables -A FORWARD -i br-lan -o wlan0 -j ACCEPT

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
ip6tables -A FORWARD -i wlan0 -o br-lan -j ACCEPT

# Allow forwarding of packets from br-lan to wlan0
ip6tables -A FORWARD -i br-lan -o wlan0 -j ACCEPT

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

    
