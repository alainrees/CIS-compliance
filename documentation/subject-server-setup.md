Subject server setup
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

--append INPUT --source <IPv4-ADDRESS-OF-SCANNER> --protocol tcp --dport 22 --jump ACCEPT

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

--append INPUT --source <IPv6-ADDRESS-OF-SCANNER> --protocol tcp --dport 22 --jump ACCEPT

--append INPUT --jump REJECT
--append FORWARD --jump REJECT

COMMIT
EOF
$ sudo iptables-apply /etc/iptables/rules.v4
$ sudo ip6tables-apply /etc/iptables/rules.v6
```

4. Install and configure openssh server:
```
$ sudo apt-get install openssh-server
$ sudo cat << EOF > /etc/ssh/sshd_config
# Package generated configuration file
# See the sshd_config(5) manpage for details
 
# What ports, IPs and protocols we listen for
Port 22
# Use these options to restrict which interfaces/protocols sshd will bind to
#ListenAddress ::
ListenAddress 0.0.0.0
Protocol 2
# HostKeys for protocol version 2
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_dsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key
#Privilege Separation is turned on for security
UsePrivilegeSeparation yes
 
# Lifetime and size of ephemeral version 1 server key
KeyRegenerationInterval 3600
ServerKeyBits 1024
 
# Logging
SyslogFacility AUTH
LogLevel INFO
 
# Authentication:
LoginGraceTime 120
PermitRootLogin no
StrictModes yes
 
RSAAuthentication yes
PubkeyAuthentication yes
#AuthorizedKeysFile     %h/.ssh/authorized_keys
 
# Don't read the user's ~/.rhosts and ~/.shosts files
IgnoreRhosts yes
# For this to work you will also need host keys in /etc/ssh_known_hosts
RhostsRSAAuthentication no
# similar for protocol version 2
HostbasedAuthentication no
# Uncomment if you don't trust ~/.ssh/known_hosts for RhostsRSAAuthentication
#IgnoreUserKnownHosts yes
 
# To enable empty passwords, change to yes (NOT RECOMMENDED)
PermitEmptyPasswords no
 
# Change to yes to enable challenge-response passwords (beware issues with
# some PAM modules and threads)
ChallengeResponseAuthentication no
 
# Change to no to disable tunnelled clear text passwords
PasswordAuthentication no
 
# Kerberos options
#KerberosAuthentication no
#KerberosGetAFSToken no
#KerberosOrLocalPasswd yes
#KerberosTicketCleanup yes
 
# GSSAPI options
#GSSAPIAuthentication no
#GSSAPICleanupCredentials yes
 
X11Forwarding no
X11UseLocalhost yes
X11DisplayOffset 10
PrintMotd no
PrintLastLog yes
TCPKeepAlive yes
#UseLogin no
 
#MaxStartups 10:30:60
Banner /etc/issue.net
 
# Allow client to pass locale environment variables
AcceptEnv LANG LC_*
 
Subsystem sftp /usr/lib/openssh/sftp-server
 
# Set this to 'yes' to enable PAM authentication, account processing,
# and session processing. If this is enabled, PAM authentication will
# be allowed through the ChallengeResponseAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via ChallengeResponseAuthentication may bypass
# the setting of "PermitRootLogin without-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and ChallengeResponseAuthentication to 'no'.
UsePAM yes
EOF
```

5. Create chef user and add public key:
```
$ sudo useradd -d chef -s /bin/bash
$ sudo mkdir -m 700 /home/chef/.ssh/
$ sudo touch /home/chef/authorized_keys
$ sudo chmod 600 /home/chef/authorized_keys
$ sudo cat << EOF >> /home/chef/authorized_keys
<CHEF-SSH-PUBLIC-KEY>
EOF
```

6. Allow user "chef" to become root with sudo:
```
$ sudo cat << EOF >> /etc/sudoers
chef ALL=(ALL) NOPASSWD:ALL
```
