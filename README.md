# Home lab quick network router/dns/dhcp

This is a simple implementation of a gateway, dns and dhcp server implementation using Docker and automated deployment using Ansible and Docker Compose.

This is meant to work on any Debian server with two network interfaces (One for the internal network and the otner for the internet connection). To use this on any other linux distro you may need to change the docker instalation process and adapt the systemd services in the ```services/```  folder if you're using another init program.

> Important!:  If you have more than 2 interfaces this might kaput the other ones, please check the ```./net-config/interfaces.template``` file.

## Installation process
### Installing docker
First you need to add your server to the `ansible/inventory.yaml` file.

```yaml
networkServers:
  hosts:
    myServerNameOrIp:
```

Afther this, you need to install ansible(using your package manager) on your dev machine. Then install docker in the server macine, you can do this manually or by running the following script:

```sh
ansible-playbook ./ansible/playbooks/docker-setup/install-docker-debian.yaml -i ./ansible/inventory.yaml
```

### Changing the subnet configuration
You could go with the default subnet or setup your own by modifiying the  ```ansible/vars/home-env-vars.yaml``` file:

```yaml
network_prefix: 192.168.15 #This is the variable for the target dhcp subnet
netMask: 255.255.255.255 #This is the network mask

#These to are the subnet for the docker Bridge network to give the dns/gateway containers access to the internet, you can change this to anything you want if this conflicts with your external network:

externalGateway: 192.168.52.1
externalSubnet: 192.168.52.0/24 # 

internalDockerGateway: '{{network_prefix}}.5' # This is the gateway for the docker macvtap network attached to the internal network interface.

#If you wish to change the dhcp range for your network you can do so by modifying the following variables:
ipRangeStart: '{{network_prefix}}.20'
ipRangeEnd: '{{network_prefix}}.250'

```
### Adding Dns Zones
You can add your dns zones by editing the ```./ansible/vars/dns-zones.yaml``` and adding the zones you want for your dns, the final configuration files for bind are generated based on the following template files:

* ```dns-server/templates/config/named.conf.local.template```
* ```dns-server/templates/config/zones/db.zone.template```

It is possible to have finer control by adding variables to the zones in the ```dns-zones.yaml``` file and then adding those to either of those files in whatever configuration you might want dinamically modified.

The contents of the ```named.conf.local.template``` file are parsed for each dns zone and then concatenated into a single file named ```named.conf.local``` that is referenced in the ```named.conf``` file to load the zones.

The format for adding dns zones is as follows:

```yaml
dns_zones:
  - zone_name: home.arpa
    names: |
      myHost.home.arpa.      IN      A      {{network_prefix}}.5
      myHost2.home.arpa.     IN      A      {{network_prefix}}.6
      myHost3.home.arpa.     IN      A      {{network_prefix}}.7
  - zone_name: home.local
    names: |
      myHost.home.local.      IN      A      {{network_prefix}}.15
```
Just need to specify the ```zone_name``` and then the names asociated to that zone in the dafault bind record format. This is just append at the end of each parsed ```db.zone.template``` file. 