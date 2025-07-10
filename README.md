# Squatch LAN

Welcome to my homelab!

## Terraform

- `cerberus_cluster` - Deploys a Talos k8s cluster backed by PVE VMs, Cilium, and Argo CD.

## Ansible

### Playbooks

- `k3s_cluster` - Deploys a k3s cluster on the hosts specified in the `k3s_cluster` inventory.
  Uses roles from Rancher's [`k3s-ansible`](https://github.com/k3s-io/k3s-ansible) along with a custom load balancer role to install HAProxy and Keepalived.

- `pve_post_install` - Applies common configurations for fresh PVE installs.
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
