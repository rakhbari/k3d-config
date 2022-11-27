# k3d-config
k3d config specs and scripts

## k3d Install
I decided to go the full config file method for the install so the `k3d-install.sh` script does nothing other than use the `k3d` CLI to point to the `cluster-config.yaml` file and get the installation started.
1. Make sure you have `kubectl` installed (https://kubernetes.io/docs/tasks/tools/#kubectl)
1. Go to [k3d.io](https://k3d.io/#installation) and install `k3d` CLI
1. Review the `cluster-config.yaml` file carefully to make sure it has the options you want.
1. Change its `metadata.name` to a name for your own cluster
1. Once you're all good with the above, run `k3d-install.sh`

If you get any sort of errors in the output you'll be on your own to investigate & resolve them (Google is your friend!). Otherwise you should be able to do: `kubectl cluster-info` and you sould see something to this effect:
```
Kubernetes control plane is running at https://0.0.0.0:6443
CoreDNS is running at https://0.0.0.0:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
Metrics-server is running at https://0.0.0.0:6443/api/v1/namespaces/kube-system/services/https:metrics-server:https/proxy
```

You should also be able to at this point issue a `kubectl get ns` and see the initial set of k8s namespaces:
```
NAME              STATUS   AGE
default           Active   107m
kube-system       Active   107m
kube-public       Active   107m
kube-node-lease   Active   107m
```

__NOTE__: Ignore the `metallb-*.*` files. They're just there for my own reference. I'm using the default load balancer that comes stock with k3s [klipper-lb](https://github.com/k3s-io/klipper-lb).

## `nginx` Test Deployments/Services/IngressRoutes
I've included an `nginx-install.sh` plus a set of k8s spec under the `k8s/nginx` subdir just to be able to test out the Traefik ingress controller that comes installed with k3d/k3s.

Before you run the install script, check the `ingress.yaml` file under `k8s/nginx` and change the `Host()` to match your own's bare metal box where you're installing k3d:
```
    - match: Host(`mainserv03.lan`) && PathPrefix(`/${APP_NAME}`)
```

Run `nginx-install.sh <nginx-id>` to create a few NginX `Deployment`s, associated `Service`s and `IngressRoute`s as such:
```
$ ./nginx-install.sh nginx-1
```
You'll end up with the following CR objects:
```
NAME              TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
service/nginx-1   ClusterIP   10.43.229.101   <none>        80/TCP    107m

NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx-1   1/1     1            1           107m

NAME                  AGE
nginx-1-stripprefix   113m

NAME
ingressroute.traefik.containo.us/nginx-1
```
If everything goes well, you should be able to hit your bare metal hostname (or IP address) with `<hostname-or-ip>:9080/nginx-1` and see a dead simple `index.html` page that simply identifies the `<nginx-id>` you enered earlier. Nothing fancy, just an easy test page to show that you can create multiple services & ingress-routes that are externally accessible from anywhere in your network.

## Traefik Dashboard
To enable the Traefik dashboard you simply need to do:
1. Define a `traefik.lan` host in your `hosts` file to point to the same IP address as the k3d bare metal host
1. Apply the `k8s/traefik/ingress-dashboard.yaml`

If that worked (no errors) you should be able to hit: http://traefik.lan:9080/dashboard/ to see the Traefik dashboard

## Portainer Dashboard
To enable the Portainer dashboard you simply need to do:
1. Define a `portainer.lan` host in your `hosts` file to point to the same IP address as the k3d bare metal host
1. Apply the `k8s/portainer-cip.yaml` (`cip` is just an indicator that this YAML spec bundle contains a `ClusterIP` service)

If that worked (no errors) you should be able to hit: http://portainer.lan:9080/ to see the Portainer dashboard. You'll be asked to creae an `admin` account and enter a password.

## Acknowledgements
Aside from major kudos to the folks at Rancher for developing and releasing to OSS their awesome K3D, I also wanted to acknowledge a couple of folks whose YouTube channels and online articles really helped point me in the right direction to get things set up no my measely 1-server machine at home.
* [Techno Tim](https://www.youtube.com/@TechnoTim): You're awesome! Your K3S + Ansible video is clear, to-the-poin, and all-in-all really well-done. Thank you!
* [Niel (from portainer.io)](https://www.youtube.com/watch?v=5HaU6338lAk): Your video on set up of portainer on K3D really helped clear up a couple of things that were a bit unclear to me. Thank you for hitting on those points.