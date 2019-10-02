Scanner server setup
====================

Author: Imre Jonk
 
1. Install Ubuntu 14.04
2. Update packages and install unattended-upgrades and iptables-persistent:

```
$ sudo apt-get update && sudo apt-get install unattended-upgrades iptables-persistent
```

3. Configure firewall:

```
$ sudo cat << EOF > /etc/iptables/rules.v4
*filter
:INPUT DROP
:FORWARD DROP
:OUTPUT ACCEPT

--append INPUT --protocol icmp --jump ACCEPT
--append INPUT --in-interface lo --jump ACCEPT
--append INPUT --match state --state RELATED,ESTABLISHED --jump ACCEPT

--append INPUT --protocol tcp --dport 80 --jump ACCEPT
--append INPUT --protocol tcp --dport 443 --jump ACCEPT

--append INPUT --jump REJECT
--append FORWARD --jump REJECT

COMMIT
EOF

$ sudo cat << EOF > /etc/iptables/rules.v6
*filter
:INPUT DROP
:FORWARD DROP
:OUTPUT ACCEPT

--append INPUT --protocol icmpv6 --jump ACCEPT
--append INPUT --in-interface lo --jump ACCEPT
--append INPUT --match state --state RELATED,ESTABLISHED --jump ACCEPT

--append INPUT --protocol tcp --dport 80 --jump ACCEPT
--append INPUT --protocol tcp --dport 443 --jump ACCEPT

--append INPUT --jump REJECT
--append FORWARD --jump REJECT

COMMIT
EOF
$ sudo iptables-apply /etc/iptables/rules.v4
$ sudo ip6tables-apply /etc/iptables/rules.v6
```

4. [Install Chef compliance scanner](https://learn.chef.io/tutorials/compliance-assess/ubuntu/bring-your-own-system/install-chef-compliance/)
5. [Add a node](https://learn.chef.io/tutorials/compliance-assess/ubuntu/bring-your-own-system/get-a-node-to-scan/)
6. [Scan for compliance](https://learn.chef.io/tutorials/compliance-assess/ubuntu/bring-your-own-system/scan-your-node-for-compliance/)
