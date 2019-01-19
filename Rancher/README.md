# Rancher

1) [download rancher](https://github.com/rancher/os)
2) First machine
   1) VMware host
      * VM Settings
         * Hostname:  "rancher01"    
         * Guest OS:  Linux; Other 64bit
         * CPU: 2 (manager) or 8 (node)
         * RAM: 4G (manager) or 64G (node
   2) RancherOS
      1) `sudo passwd rancher`
      2) `ifconfig eth0` Note the IP address
   3) Local workstation
      1) `ssh-keygen -t rsa -f ~/.ssh/rancher_rsa`
      2) `ssh-copy-id -i ~/.ssh/rancher_rsa rancher@<address>`
      3) update `~/.ssh/config` to make life easier:
          ```
          Host rancher*
            IdentityFile ~/.ssh/rancher_rsa
            User rancher
          ```
      4) asdf   
      
      
