---
title: 'Run Pi-hole as Docker Swarm Stack'
date: 2022-01-28T08:54:43+01:00
draft: false
categories: ['Docker']
tags: ['pihole', 'swarm', 'stack']
# lastmod: 2022-01-28T08:54:43+01:00
# showDateUpdated: true

# custom overrides for pages
# showDate: false
# showAuthor: false
# showWordCount: false
# showReadingTime: false
# showEdit: false
# sharingLinks: [null]
---

{{< figure src="black-hole.jpg" width="600" height="800" caption="Photo by Kamesh Vedula on Unsplash." >}}

## Intro

Many of you already know [Pi-hole](https://pi-hole.net/) as a trusted DNS firewall solution in your home labs. But
what if your home lab should just provide containerized services? - I know, running Pi-hole as a container isn't
new. In fact, the developer community already provides [official images](https://hub.docker.com/r/pihole/pihole).

In this post I want to show you why you should run Pi-hole (or even every container) in a docker swarm configuration
as a defined stack.

So let's begin with some worts about the Docker Swarm Mode.

### What's Docker Swarm Mode ?

[Docker Swarm Mode](https://docs.docker.com/engine/swarm/) takes simply multiple Docker engines and creates a
cluster. On these docker nodes you can then run containers defined in a stack files. These stacks are written in the
same format as `docker-compose.yml` files. After deploying the stack the engine takes care about the deployment
on suitable nodes.

I think the best feature is that you can update your stacks and its container services. This makes updating your
containers much easier whenever there is a new image version available. Without this feature you needed to stop and
restart your containers with docker-compose.

{{< alert >}}
Don't expect to get a fully featured cluster management for container environments like
[Kubernetes](https://kubernetes.io/docs/concepts/overview/what-is-kubernetes/) with Docker Swarm
Mode. You still need to take care about key element by yourself. For example how to and how to sync volumes and
make them available on all nodes.
On the other hand, Kubernetes isn't always needed and comes not only with mor features - It also requires ab better
knowledge about the underlying techniques and faces you with much more challenges.
{{< /alert >}}

### Pi-hole Stack

I use [traefik](https://traefik.io/traefik/) on my docker swarm clusters as reverse proxy. Like every reverse proxy
traefik handles the request and routes it to to the target service. It terminates the https traffic and manages the
certificates. You could also use something else like [Nginx Proxy Manager](https://nginxproxymanager.com/).
Just keep in mind, that the listed service labels are required for traefik to perform its dynamic config.

```yaml
version: '3.8'

# More info at https://github.com/pi-hole/docker-pi-hole/ and https://docs.pi-hole.net/
services:
  pihole:
    image: pihole/pihole:2022.01.1
    ports:
      - target: 53
        published: 53
        protocol: tcp
        mode: host
      - target: 53
        published: 53
        protocol: udp
        mode: host
      - target: 67
        published: 67
        protocol: udp
        mode: host
    environment:
      TZ: 'Europe/Berlin'
      WEBPASSWORD: 'foobar2000'
    # Volumes store your data between container upgrades
    volumes:
      - /nfs-share/pihole/volumes/pihole-data:/etc/pihole/
      - /nfs-share/pihole/volumes/pihole-dnsmasq:/etc/dnsmasq.d/

    # Recommended but not required (DHCP needs NET_ADMIN)
    #   https://github.com/pi-hole/docker-pi-hole#note-on-capabilities
    #cap_add:
    #  - NET_ADMIN
    networks:
      - pihole
      - traefik-public
    deploy:
      replicas: 1
      labels:
        - 'traefik.enable=true'
        - 'traefik.docker.network=traefik-public'
        - 'traefik.http.routers.pihole.rule=Host(`pihole.mydomain.io`)'
        - 'traefik.http.routers.pihole.tls=true'
        - 'traefik.http.routers.pihole.tls.certresolver=myresolver'
        - 'traefik.http.services.pihole-srv.loadbalancer.server.port=80'

networks:
  pihole:
  traefik-public:
    external: true
```

The special part here is the port config. Normally you would use this syntax to publish ports:

```yaml
ports:
  - '53:53/tcp'
  - '53:53/udp'
  - '67:67/udp'
  - '8080:80/tcp'
```

But this publishes the ports on the ingress / overlay network and causes pihole to show only the service ip on the
connected clients list. So we have to use the long format with the `mode` set to `host`. This of cause does only work
if there is no other process already using the listed ports.

{{< figure src="settings.png" width="450" height="800" >}}

Additionally you have to set `Permit all origins` option under `Settings` -> `DNS tab` -> `Interface settings`.

That's it. Now you're running Pi-hole as a docker swarm service as DNS Server. You can now start defining your
Pi-hole groups and filter the clients.
