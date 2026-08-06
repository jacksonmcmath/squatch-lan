# Squatch LAN

Welcome to my homelab!

## Terraform

- `cerberus_cluster` - Deploys a Talos k8s cluster backed by PVE VMs, Cilium, and Argo CD.

## Ansible

### Playbooks

- `k3s_cluster` - Deploys a k3s cluster on the hosts specified in the `k3s_cluster` inventory.
  Uses roles from Rancher's [`k3s-ansible`](https://github.com/k3s-io/k3s-ansible) along with a custom load balancer role to install HAProxy and Keepalived.

- `pve_post_install` - Applies common configurations for fresh PVE installations.
  Configures apt repositories and sources, disables the subscription nag, enables high-availability services, etc.
  Inspired from [PVE Helper Scripts](https://community-scripts.github.io/ProxmoxVE/scripts?id=post-pve-install).

## Argo CD

My applications are split into 3 groups, `core`, `dev`, and `prod`; each with a corresponding project and application set.
Everything is bootstrapped with a root application following the [app-of-apps pattern](https://argo-cd.readthedocs.io/en/stable/operator-manual/cluster-bootstrapping/).

### Core Applications

These applications are part of the essential infrastructure of the cluster. 

- **Argo CD** - GitOps
- **cert-manager** - TLS FTW
- **Cilium & Hubble** - CNI built on eBPF and its observability platform
- **External Secrets & 1Password Connect** - integrate k8s secrets with my 1Password vault
- **Synology CSI** - iSCSI storage on my Synology NAS
- **Traefik** - L7 proxy and ingress

### Dev & Prod Applications

These applications are the various workloads running on the cluster.

## IP Address Scheme

| Subnet | VLAN | Name |
| --- | ---: | --- |
| `10.128.0.0/19` | 110 | Border Services - Internal |
| `10.128.32.0/19` | 115 | Border Services - External |
| `10.128.64.0/19` | 100 | Border Services - Inbound |
| `10.128.96.0/19` | 105 | Border Services - Outbound |
| `10.129.0.0/19` | 1 | Management |
| `10.129.32.0/19` | 2 | Management (Non Routed) |
| `10.129.64.0/19` | 5 | Management Applications |
| `10.129.128.0/19` | 20 | Private Applications |
| `10.129.192.0/19` | 25 | Public Applications |
| `10.130.0.0/19` | 200 | Trusted Devices |
| `10.130.32.0/19` | 210 | Work Devices |
| `10.130.64.0/19` | 220 | Restricted Devices |
| `10.130.96.0/19` | 230 | Guest |
| `10.130.128.0/18` | 250 | IoT |

## TODO

- Rapsberry Pi Integrations
  - NUT server, extra DNS node, WOL?, gotify
- OCI Integrations
  - reverse proxy, tailscale, uptime, gotify, PVE quorum device?
  - ansible roles
  - backups?
- terraform
  - talos image on cephFS
  - node labels, annotations, taints

## ACSII Art

```
   _____                   __       __       __    ___    _   __
  / ___/____ ___  ______ _/ /______/ /_     / /   /   |  / | / /
  \__ \/ __ `/ / / / __ `/ __/ ___/ __ \   / /   / /| | /  |/ / 
 ___/ / /_/ / /_/ / /_/ / /_/ /__/ / / /  / /___/ ___ |/ /|  /  
/____/\__, /\__,_/\__,_/\__/\___/_/ /_/  /_____/_/  |_/_/ |_/   
        /_/                                                     
-
 ___                 _      _      _      _   _  _ 
/ __| __ _ _  _ __ _| |_ __| |_   | |    /_\ | \| |
\__ \/ _` | || / _` |  _/ _| ' \  | |__ / _ \| .` |
|___/\__, |\_,_\__,_|\__\__|_||_| |____/_/ \_\_|\_|
        |_|                                        
-
   ____               __      __     __   ___   _  __
  / __/__ ___ _____ _/ /_____/ /    / /  / _ | / |/ /
 _\ \/ _ `/ // / _ `/ __/ __/ _ \  / /__/ __ |/    / 
/___/\_, /\_,_/\_,_/\__/\__/_//_/ /____/_/ |_/_/|_/  
      /_/                                            
-
 ____                    _       _       _        _    _   _ 
/ ___|  __ _ _   _  __ _| |_ ___| |__   | |      / \  | \ | |
\___ \ / _` | | | |/ _` | __/ __| '_ \  | |     / _ \ |  \| |
 ___) | (_| | |_| | (_| | || (__| | | | | |___ / ___ \| |\  |
|____/ \__, |\__,_|\__,_|\__\___|_| |_| |_____/_/   \_\_| \_|
          |_|                                                
```

```
                           __       __         __         
   _________ ___  ______ _/ /______/ /_   ____/ /__ _   __
  / ___/ __ `/ / / / __ `/ __/ ___/ __ \ / __  / _ \ | / /
 (__  ) /_/ / /_/ / /_/ / /_/ /__/ / / // /_/ /  __/ |/ / 
/____/\__, /\__,_/\__,_/\__/\___/_/ /_(_)__,_/\___/|___/  
        /_/                                               
-
                    _      _         _         
 ___ __ _ _  _ __ _| |_ __| |_    __| |_____ __
(_-</ _` | || / _` |  _/ _| ' \ _/ _` / -_) V /
/__/\__, |\_,_\__,_|\__\__|_||_(_)__,_\___|\_/ 
       |_|                                     
-
                      __      __       __        
  ___ ___ ___ _____ _/ /_____/ /   ___/ /__ _  __
 (_-</ _ `/ // / _ `/ __/ __/ _ \_/ _  / -_) |/ /
/___/\_, /\_,_/\_,_/\__/\__/_//_(_)_,_/\__/|___/ 
      /_/                                        
-
                       _       _          _            
 ___  __ _ _   _  __ _| |_ ___| |__    __| | _____   __
/ __|/ _` | | | |/ _` | __/ __| '_ \  / _` |/ _ \ \ / /
\__ \ (_| | |_| | (_| | || (__| | | || (_| |  __/\ V / 
|___/\__, |\__,_|\__,_|\__\___|_| |_(_)__,_|\___| \_/  
        |_|                                            
```

```

                   X&&&:        
                 &&&&&&&        
              :&&&&&&&&&:       
           &&&&&&&&&&&&&        
          &&&&&&&&&&&&&&        
       &&&&&&&&&&&&&&&&&:       
      &&&&&&&&&&&&&&&&&&$       
     X&&&&&X&&&&&&&&&&&&&       
     &&&&&.&&&&&&&&&&&&&&&      
    &&&&&:$&&&&&&&&&.&&&&&&&&   
    &&&&&:&&&&&&&&&:  X&&&&&&&  
&&&&&&&   &&&&&&&&&       &&&&&&
 &&&&     &&&&&&&&&&&.      & &&
          .&&&&&&&&&&&&      && 
          &&&&&&&&&&&&&&        
         ;&&&&&& &&&&&&&        
      ;&&&&&&&&+   +&&&&&       
  &&&&&&&&&&&&&     &&&&&       
 &&&&&&&&&&:        &&&&&       
 &&&&               &&&&&       
 &&&                X&&&;       
  &&                &&&&&&&     
                    &&&&&&&&&&  

```
