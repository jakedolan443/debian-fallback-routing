# debian-fallback-routing
This is my personal implementation for fallback default gateway routing across multiple physical interfaces.

Debian provides a wiki on [bonding](https://wiki.debian.org/Bonding) interfaces, which creates an auto failover interface. I dislike this system, because it attempts to give the same MAC address to two interfaces, and overall is quite buggy, especially if you try to bond an wired & wireless interface together. This also creates a new interface `bond0`, which complicated my firewall setup.

The system I implemented uses an ICMP ping every 30 seconds to the default gateway to determine if the current network interface can still access it - if it can't, the program switches the interface. This cycle repeats with multiple interfaces, and the primary network interface is reset on reboot.

This was made for an inner division of my LAN, where I have a faster, but unreliable, WiFi connection (~150Mbit/s) and a reliable, but slow, ethernet connection (100Mbit/s). This meant I could make use of the faster WiFI interface, and when it went down (as it frequently did), I could switch over to the ethernet interface without any trouble.
