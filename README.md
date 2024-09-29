<h1 align="center"> <summary>
      
   [Bypass Anti-Tethering (Time To Live and Hop Limit) for Wifi Repeater](https://github.com/xiv3r/anti-tethering-bypasser)
   
AP 10.0.0.1 ttl=1 -> Linux Bridge/Extender -> 10.0.0.1 ttl=64
</summary> </h1>

## Dependencies 

sudo apt update ; sudo apt install iptables -y

## Run permanently after Boot nano /etc/rc.local
```
# Flush table
iptables -F

# Flush mangle table rules
iptables -t mangle -F

# Input TTL=1 and Output TTL=64
iptables -t mangle -A PREROUTING -j TTL --ttl-set 64
iptables -t mangle -I POSTROUTING -o wlan0 -j TTL --ttl-set 64

# Redirect all traffic from wlan0 to eth0
iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth0 -o wlan0 -j ACCEPT

exit 0
```
