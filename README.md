# Squatch LAN

Welcome to my homelab!

## Terraform

- `cerberus_cluster` - Deploys a Talos k8s cluster backed by PVE VMs, Cilium, and Argo-CD

## Ansible

### Playbooks

- `k3s_cluster` - Deploys a k3s cluster on the hosts specified in the `k3s_cluster` inventory.
  Uses roles from Rancher's [`k3s-ansible`](https://github.com/k3s-io/k3s-ansible) along with a custom load balancer role to install HAProxy and Keepalived

- `pve_post_install` - Applies common configurations for fresh PVE installs.
  Configures apt repositories and sources, disables the subscription nag, enables high-availability services, etc. Inspired from [PVE Helper Scripts](https://community-scripts.github.io/ProxmoxVE/scripts?id=post-pve-install)

## Applications & Services

### Asset Management

<details>
<summary>Cannery</summary>
</details>

<details>
<summary>LubeLogger</summary>
</details>

<details>
<summary>Part-DB</summary>
</details>

<details>
<summary>Shelf</summary>
</details>

### Gaming

<details>
<summary>Pterodactyl</summary>

![Static Badge](https://img.shields.io/badge/-VM-gray?logo=proxmox)

</details>

### IAM

<details>
<summary>Authentik</summary>
</details>

### IoT

<details>
<summary>Node RED</summary>
</details>

### Media

<details>
<summary>Immich</summary>

![Static Badge](https://img.shields.io/badge/-k8s-gray?logo=kubernetes)

</details>

<details>
<summary>Plex Media Server</summary>
</details>

<details>
<summary>qBittorrent</summary>
</details>

<details>
<summary>SABnzbd</summary>
</details>

#### *arr

<details>
<summary>Prowlarr</summary>
</details>

<details>
<summary>Radarr</summary>
</details>

<details>
<summary>Sonarr</summary>
</details>

<details>
<summary>Lidarr</summary>
</details>

<details>
<summary>Readarr</summary>
</details>

<details>
<summary>Configarr</summary>
</details>

<details>
<summary>Flaresolverr</summary>
</details>

<details>
<summary>Bazarr</summary>
</details>

<details>
<summary>Overseerr</summary>
</details>

<details>
<summary>Tautulli</summary>
</details>

<details>
<summary>Homarr</summary>
</details>

### Monitoring

<details>
<summary>Grafana</summary>
</details>

<details>
<summary>Loki</summary>
</details>

<details>
<summary>Mimir</summary>
</details>

<details>
<summary>Prometheus</summary>
</details>

<details>
<summary>Pyroscope</summary>
</details>

<details>
<summary>Tempo</summary>
</details>

### Networking

<details>
<summary>AdGuard Home</summary>
</details>

<details>
<summary>Cloudflare Tunnel</summary>
</details>

<details>
<summary>ddclient</summary>
</details>

<details>
<summary>Netbox</summary>
</details>

<details>
<summary>Tailscale</summary>
</details>

<details>
<summary>Traefik</summary>
</details>

<details>
<summary>Wireguard</summary>
</details>

### Miscellaneous

<details>
<summary>Cloudlog</summary>
</details>

<details>
<summary>ConvertX</summary>
</details>

<details>
<summary>CUPS</summary>
</details>

<details>
<summary>iSponsorBlockTV</summary>
</details>

<details>
<summary>Paperless-ngx</summary>
</details>

### Infrastructure

<details>
<summary>Argo CD</summary>
</details>

<details>
<summary>cert-manager</summary>
</details>

<details>
<summary>Cilium</summary>
</details>
