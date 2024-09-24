# Bypass Any Anti-Tethering WiFi Hotspot
### [--ttl-inc/--ttl-set](https://www.linuxtopia.org/Linux_Firewall_iptables/x4799.html) overview

#### --ttl-inc 1 it doesn't touch TTL as routed. This also "hides" router from traceroute as it doesn't touch TTL.

#### --ttl-set 64 it touch TTL as routed. This also "Unhide" router from traceroute.

![img](https://github.com/user-attachments/assets/ed1ef5f9-f5eb-43f0-bed9-b75da4380417)

- Example:
WiFi Hotspot with Anti-Tethering enables (TTL= 1) will change into (TTL= 65)
from this
[ 64 bytes from 10.0.0.1: icmp_seq=1 `ttl=1` time=1.72 ms]
to this
[64 bytes from 10.0.0.1: icmp_seq=1 `ttl=65` time=1.72 ms]


- ## Dependencies for OpenWRT

      opkg update ; opkg install iptables iptables-mod-ipopt iptables-zz-legacy -y

# For OpenWRT/SBC's

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

# Bypass TTL/HL detections for other devices that connect to this device.
## Routers (as the client) require their own TTL/HL increment script.

# IPv4
iptables -t mangle -A PREROUTING -i radi0 -j TTL --ttl-inc 64
iptables -t mangle -I POSTROUTING -o br-lan -j TTL --ttl-inc 64

# IPv6
ip6tables -t mangle -A PREROUTING ! -p icmpv6 -i wlan0 -j HL --hl-inc 64
ip6tables -t mangle -I POSTROUTING ! -p icmpv6 -o br-lan -j HL --hl-inc 64

# Set TTL for outgoing packets on wlan0
iptables -t mangle -A POSTROUTING -o (ex. wlan0) -j TTL --ttl-inc 64

# Increment TTL for incoming packets on wlan0
iptables -t mangle -A PREROUTING -i (ex. wlan0) -j TTL --ttl-inc 64

# Set TTL for outgoing packets from 10.0.0.1
iptables -t mangle -A POSTROUTING -s (ex. 10.0.0.1) -j TTL --ttl-inc 64

# Set TTL for incoming packets destined to 10.0.0.1
iptables -t mangle -A PREROUTING -d (ex. 10.0.0.1) -j TTL --ttl-inc 64

}

stop() {

logger -t firewall-custom "Stopping custom firewall rules"

# Remove TTL setting for outgoing packets on wlan0
iptables -t mangle -D POSTROUTING -o (ex. wlan0) -j TTL --ttl-inc 64

# Remove TTL increment for incoming packets on wlan0
iptables -t mangle -D PREROUTING -i (ex. wlan0) -j TTL --ttl-inc 64

logger -t ttl-custom "Removing TTL setting for 10.0.0.1"

# Remove TTL setting for outgoing packets from 10.0.0.1
iptables -t mangle -D POSTROUTING -s ( ex. 10.0.0.1) -j TTL --ttl-inc 64

# Remove TTL setting for incoming packets destined to 10.0.0.1
iptables -t mangle -D PREROUTING -d (ex. 10.0.0.1) -j TTL --ttl-inc 64
}
```

# For Linux PC's/Servers

- Note: Please change your `Linux PC's/Servers current Interfaces` in the script below for `Incoming/Outgoing Packets and IP addresses` so that iptables can route all traffic on the set iptables rules.
- To check the current network interfaces type `ip address ` 

- ## Dependencies

      sudo apt update
      sudo apt install iptables

- Creating and filling the following file:

- Must execute after boot. 

      sudo nano /etc/anti-tethering.sh
  
      sudo chmod +x /etc/anti-tethering.sh

- ## To Run:

      sudo sh /etc/anti-tethering.sh

- Insert this script into /etc/anti-tethering.sh

```
#!/bin/sh

# Also bypass TTL/HL detections for other devices that connect to this device.
## Routers (as the client) require their own TTL/HL increment script.
## Tethering interfaces -> rndis0: USB, wlan1: Wi-Fi, bt-pan: Bluetooth.
## -A: last rule in chain, -I: head /first rule in chain (by default).

# IPv4
iptables -t mangle -A PREROUTING -i wlan0 -j TTL --ttl-inc 64
iptables -t mangle -I POSTROUTING -o wlan0 -j TTL --ttl-inc 64

#IPv6
ip6tables -t mangle -A PREROUTING ! -p icmpv6 -i wlan0 -j HL --hl-inc 64
ip6tables -t mangle -I POSTROUTING ! -p icmpv6 -o wlan0 -j HL --hl-inc 64

# Set TTL for outgoing packets on wlan0
iptables -t mangle -A POSTROUTING -o wlan0 -j TTL --ttl-inc 64

# Increment TTL for incoming packets on wlan0
iptables -t mangle -A PREROUTING -i wlan0 -j TTL --ttl-inc 64

# Set TTL for outgoing packets from 10.0.0.1
iptables -t mangle -A POSTROUTING -s 10.0.0.1 -j TTL --ttl-inc 64

# Set TTL for incoming packets destined to 10.0.0.1
iptables -t mangle -A PREROUTING -d 10.0.0.1 -j TTL --ttl-inc 64

# Remove TTL setting for outgoing packets on wlan0
iptables -t mangle -D POSTROUTING -o wlan0 -j TTL --ttl-inc 64

# Remove TTL increment for incoming packets on wlan0
iptables -t mangle -D PREROUTING -i wlan0 -j TTL --ttl-inc 64

# Remove TTL setting for outgoing packets from 10.0.0.1
iptables -t mangle -D POSTROUTING -s 10.0.0.1 -j TTL --ttl-inc 64

# Remove TTL setting for incoming packets destined to 10.0.0.1
iptables -t mangle -D PREROUTING -d 10.0.0.1 -j TTL --ttl-inc 64

```
# Autorun on Boot

    sudo nano /etc/rc.local 

add the script above then execute

    sudo chmod +x /etc/rc.local
    
    reboot
