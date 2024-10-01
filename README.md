 <h1 align="center"> <summary>
      
### [Bypass Anti-Tethering(TTL /HL)](https://github.com/xiv3r/anti-tethering-bypasser)
   
10.0.0.1 ttl=1 => WiFi Repeater/Extender => 10.0.0.1 ttl=64
</summary> </h1>

## Dependencies 

    sudo apt update ; sudo apt install iptables ip6tables -y

* Note: Iptables `NAT` works properly on version 1.8.10
• Run permanently after Boot `nano /etc/rc.local`

# Iptables | Ip6tables for IPv4 and IPv6

```
# Flush all rules in the filter table
iptables -F

# Flush all rules in the nat table
iptables -t nat -F

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

# Enable NAT for outgoing traffic on eth0
iptables -t nat -A POSTROUTING -o br-lan -j MASQUERADE

# Ensure FORWARD chain policy is set to ACCEPT
iptables -P FORWARD ACCEPT

##___________________________________________________

# Flush all rules in the filter table
ip6tables -F

# Flush all rules in the nat table
ip6tables -t nat -F

# Flush all rules in the mangle table
ip6tables -t mangle -F

# Setting TTL for incoming traffic on wlan0
ip6tables -t mangle -A PREROUTING -i wlan0 -j TTL --ttl-set 64

# Setting TTL for outgoing traffic on wlan0
ip6tables -t mangle -A POSTROUTING -o wlan0 -j TTL --ttl-set 64

# Allow forwarding of packets from wlan0 to br-lan
ip6tables -A FORWARD -i wlan0 -o br-lan -j ACCEPT

# Allow forwarding of packets from br-lan to wlan0
ip6tables -A FORWARD -i br-lan -o wlan0 -j ACCEPT

# Enable NAT for outgoing traffic on eth0
ip6tables -t nat -A POSTROUTING -o br-lan -j MASQUERADE

# Ensure FORWARD chain policy is set to ACCEPT
ip6tables -P FORWARD ACCEPT

exit 0
```

## How to check?
• IPv4 iptables
    
    iptables -vnL --line-numbers -v

• IPv6 ip6tables
   
    ip6tables -vnL ---line-numbers -v
    

## How to clear Iptables existing rules?
• IPv4 iptables
    
    iptables -F
    iptables -t nat -F
    iptables -t mangle -F
    
• IPv6 ip6tables
   
    ip6tables -F
    ip6tables -t nat -F
    ip6tables -t mangle -F

    
