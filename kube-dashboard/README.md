# Kubernetes Dashboard UI

## Install
We'll install the kube dahsboard using their supported Helm chart with a copy of our their `values.yaml` file.
```
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm repo update
helm install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard -n kubernetes-dashboard -f kube-dashboard/values.yaml
```

## Authentication
We'll create an SA called `kube-viewer`, in the `app1` namespace, as a login for the dashboard and assign it read-only permissions to cluster resources:
```
./scripts/create-kubedash-sa.sh app1 kubedash-viewer
```

This script will end with displaying the `Bearer` token needed to log into the dashboard.

## Accessing the dashboard
Create an `IngressRoute` with your own k8s dashboard hostname FQDN and name of your own TLS cert secret name:
```
./scripts/ingress-kubernetes-dashboard.sh <k8s-dashboard-fqdn> <your-domain>-production
```

If all has gone well, you should be able to hit the above with `https://<k8s-dashboard-fqdn>:<external-port>` and see the login page. You'll need to copy the `Bearer` token from the previous step and paste it into the `Enter token*` box to login.
