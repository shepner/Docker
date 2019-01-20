# Rancher

## install system
1) [download rancher](https://github.com/rancher/os)
2) First machine
   1) VMware host
      * VM Settings
         * Hostname:  "ros01"    
         * Guest OS:  Linux; Other Linux (64-bit)
         * CPU: 2 (manager) or 8 (node)
         * RAM: 4G (manager) or 64G (node
   2) RancherOS
      1) `sudo passwd rancher`
      2) `ifconfig eth0` Note the IP address
   3) Local workstation
      1) setup ssh keys
         ``` shell
         RANCHERIP=
         ssh-keygen -t rsa -f ~/.ssh/rancher_rsa`
         ssh-copy-id -i ~/.ssh/rancher_rsa rancher@$RANCHERIP
         ```
      2) OPTIONAL
         * update `~/.ssh/config` to make life easier:
            ```
            Host rancher*
              IdentityFile ~/.ssh/rancher_rsa
              User rancher
            ```
          * update DNS/DHCP as appropriate
      3) create/download/edit cloud-config.yml from the [template](https://raw.githubusercontent.com/shepner/Docker/master/Rancher/cloud-config-template.yml)
      4) Install RancherOS
         ``` shell
         RANCHERIP=
         RANCHERHOSTNAME=
         scp -i ~/.ssh/rancher_rsa cloud-config-$RANCHERHOSTNAME.yml rancher@$RANCHERIP:cloud-config.yml
         ssh -i ~/.ssh/rancher_rsa rancher@$RANCHERIP "sudo ros install -c cloud-config.yml -d /dev/sda"
         ```
      5) install [Rancher](https://rancher.com/products/rancher/)
         ``` shell
         RANCHERIP=
         ssh -i ~/.ssh/rancher_rsa rancher@$RANCHERIP "sudo docker run -d --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher:latest"
         ```
## install cluster

1) login to https://ros01 and follow instuctions to get started
2) [cluster installation](https://rancher.com/docs/rancher/v2.x/en/quick-start-guide/deployment/quickstart-manual-setup/)
   1) add custom cluster
      * Provide a name
      * leave the rest at default
      * in Node Options, select all the roles
   2) copy the `sudo docker run ...` command and run from ssh on the node
   
   

   
      
      
