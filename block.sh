#!/bin/bash
# Path to your IP list file
IP_LIST="blocklist.txt"

# Flush any existing INPUT rules to start fresh
sudo iptables -F INPUT

# Allow inbound traffic on ports 80 (HTTP), 443 (HTTPS), and 22 (SSH)
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Block inbound traffic from IPs in the blocklist ONLY on ports 80 and 443
while IFS= read -r ip
do
    # Block inbound on port 80 (HTTP)
    sudo iptables -A INPUT -p tcp -s $ip --dport 80 -j DROP
    # Block inbound on port 443 (HTTPS)
    sudo iptables -A INPUT -p tcp -s $ip --dport 443 -j DROP
done < "$IP_LIST"

# Block all other inbound traffic
sudo iptables -A INPUT -j DROP

# Save the IPTables rules
sudo iptables-save | sudo tee /etc/iptables/rules.v4
