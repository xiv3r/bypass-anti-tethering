# Bypass Any Anti-Tethering WiFi Hotspot
- Example:
WiFi Hotspot with Anti-Tethering enables (TTL = 1 ) will change into (TTL= 65)

from this
[ 64 bytes from 10.0.0.1: icmp_seq=1 `ttl=1` time=1.72 ms]
to this
[64 bytes from 10.0.0.1: icmp_seq=1 `ttl=64` time=1.72 ms]



- ## Dependencies for OpenWRT

      opkg update ; opkg install iptables iptables-mod-ipopt iptables-zz-legacy -y


# For OPENWRT

- Note: Please change your `Router/SBC's current Interfaces` in the script below for `Incoming/Outgoing Packets and IP addresses` so that iptables can route all traffic on the set iptables rules.
- To check the current network interfaces type `ip address ` 

- Creating and filling the following file:

      vim /etc/init.d/firewall-custom

- Insert this scripts into firewall-custom
```
#!/bin/sh /etc/rc.common

START=99

start() {

logger -t firewall-custom "Starting custom firewall rules"

# Set TTL for outgoing packets on wlan0
iptables -t mangle -A POSTROUTING -o (ex. wlan0) -j TTL --ttl-set 65

# Increment TTL for incoming packets on wlan0
iptables -t mangle -A PREROUTING -i (ex. wlan0) -j TTL --ttl-set 65

# Set TTL for outgoing packets from 10.0.0.1
iptables -t mangle -A POSTROUTING -s (ex. 10.0.0.1) -j TTL --ttl-set 65

# Set TTL for incoming packets destined to 10.0.0.1
iptables -t mangle -A PREROUTING -d (ex. 10.0.0.1) -j TTL --ttl-set 65

}

stop() {

logger -t firewall-custom "Stopping custom firewall rules"

# Remove TTL setting for outgoing packets on wlan0
iptables -t mangle -D POSTROUTING -o (ex. wlan0) -j TTL --ttl-set 65

# Remove TTL increment for incoming packets on wlan0
iptables -t mangle -D PREROUTING -i (ex. wlan0) -j TTL --ttl-set 65

logger -t ttl-custom "Removing TTL setting for 10.0.0.1"

# Remove TTL setting for outgoing packets from 10.0.0.1
iptables -t mangle -D POSTROUTING -s ( ex. 10.0.0.1) -j TTL --ttl-set 65

# Remove TTL setting for incoming packets destined to 10.0.0.1
iptables -t mangle -D PREROUTING -d (ex. 10.0.0.1) -j TTL --ttl-set 65
}
```

# For Linux PC's/Servers

- Note: Please change your `Linux PC's/Servers current Interfaces` in the script below for `Incoming/Outgoing Packets and IP addresses` so that iptables can route all traffic on the set iptables rules.
- To check the current network interfaces type `ip address ` 

- ## Dependencies

      sudo apt update
      sudo apt install iptables

- Creating and filling the following file:

      sudo nano /etc/anti-tethering.sh
  
      sudo chmod +x /etc/anti-tethering.sh

- Insert this script into etc/anti-tethering.sh
```
#!/bin/sh

# Set TTL for outgoing packets on wlan0
iptables -t mangle -A POSTROUTING -o wlan0 -j TTL --ttl-set 65

# Increment TTL for incoming packets on wlan0
iptables -t mangle -A PREROUTING -i wlan0 -j TTL --ttl-set 65

# Set TTL for outgoing packets from 10.0.0.1
iptables -t mangle -A POSTROUTING -s 10.0.0.1 -j TTL --ttl-set 65

# Set TTL for incoming packets destined to 10.0.0.1
iptables -t mangle -A PREROUTING -d 10.0.0.1 -j TTL --ttl-set 65

# Remove TTL setting for outgoing packets on wlan0
iptables -t mangle -D POSTROUTING -o wlan0 -j TTL --ttl-set 65

# Remove TTL increment for incoming packets on wlan0
iptables -t mangle -D PREROUTING -i wlan0 -j TTL --ttl-set 65

# Remove TTL setting for outgoing packets from 10.0.0.1
iptables -t mangle -D POSTROUTING -s 10.0.0.1 -j TTL --ttl-set 65

# Remove TTL setting for incoming packets destined to 10.0.0.1
iptables -t mangle -D PREROUTING -d 10.0.0.1 -j TTL --ttl-set 65

```
# Autorun on Boot

    sudo crontab -e
    
- insert 

      @reboot sh /etc/anti-tethering.sh
