# Kubernetes Dashboard UI

## Install
We'll install the kube dahsboard using their supported Helm chart with a copy of our their `values.yaml` file.

Install the Helm chart repo & update it:
```
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm repo update
```
Install the `kubernetes-dashboard` Helm chart:
```
helm install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard -n kubernetes-dashboard -f kube-dashboard/values.yaml
```

If all has gone well, you should end up with the following resources live in your cluster:
```
$ kubectl get all -n kubernetes-dashboard
NAME                                        READY   STATUS    RESTARTS   AGE
pod/kubernetes-dashboard-54cc494b4d-dwpq7   2/2     Running   0          21h

NAME                           TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
service/kubernetes-dashboard   ClusterIP   10.43.105.48   <none>        9090/TCP   2d21h

NAME                                   READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/kubernetes-dashboard   1/1     1            1           2d21h

NAME                                              DESIRED   CURRENT   READY   AGE
replicaset.apps/kubernetes-dashboard-54cc494b4d   1         1         1       21h
```

## Authentication
We'll create an SA called `kube-viewer`, in the `app1` namespace, as a login for the dashboard and assign it read-only permissions to cluster resources:
```
./scripts/create-kubedash-sa.sh app1 kubedash-viewer
```

This script will end with displaying the `Bearer` token needed to log into the dashboard.

## Accessing the dashboard
The Helm chart installs the dashboard as a type `ClusterIP` service at port `9090`. So you'll need to create an `IngressRoute` with your own k8s dashboard hostname FQDN and name of your own TLS cert secret name:
```
./scripts/ingress-kubernetes-dashboard.sh <k8s-dashboard-fqdn> <your-domain>-production
```

If all has gone well, you should be able to hit the above with `https://<k8s-dashboard-fqdn>:<external-port>` and see the login page. You'll need to copy the `Bearer` token from the previous step and paste it into the `Enter token*` box to login.
