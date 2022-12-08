# cert-manager

## Installation
Install the latest CRDs:
```
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.10.1/cert-manager.crds.yaml
```

Create the namespace:
```
kubectl create ns cert-manager
```

Install via its Helm chart pointing to our `values.yaml` file:
```
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --values=k8s/cert-manager/values.yaml \
  --version v1.10.1
```

## CloudFlare setup
Login to your CloudFlare account
`My Profile` -> `API Tokens`
Use the `Edit zone DNS` template
Name it: `zone-dns-edit-read-all-zones` (You can name it whatever you want)
2 permissions:
1. `Zone` - `DNS` - `Edit`
1. `Zone` - `Zone` - `Read`
Zone Resources:
* `Include` - `All zones`
Copy the token from CloudFlare's UI (Don't move from the page until you've done that. You'll NEVER see it again!)

Create a `Secret` manifest file: `k8s/cert-manager/issuers/secret-cloudflare-api-token.yaml` and paste the token in it:
```
apiVersion: v1
kind: Secret
metadata:
  name: cloudflare-api-token
  namespace: cert-manager
type: Opaque
stringData:
  api-token: <your-cloudflare-api-token>
```

Perform the steps in the section below `Storage of K8s secrets in this repo`. This will install the CloudFlare API token as a `Secret` in the `cert-manager` namespace.

## Create `ClusterIssuer` and `Certificate`

Apply the `ClusterIssuer`:
```
kubectl apply -f k8s/cert-manager/issuers/issuer-letsencrypt-staging.yaml
```

Apply the `Certificate` so the `ClusterIssuer` can reach out to Let's Encrypt and issue a certificate:
```
kubectl apply -f k8s/cert-manager/certs/certificate-akhbari-us-staging.yaml
```

Check on the `Certificate` `Order` with:
```
kubectl get order -n nginx
```

You'll see something like this with `STATE` = `pending`
```
NAME                                     STATE     AGE
akhbari-us-staging-tbxlg-1064549491      pending   30s
```
Continue to issue the `get order` command until `STATE` = `valid`

Repeat the process for `certificate-akhbari-us-production.yaml`

## Storage of K8s secrets in this repo
Make sure your Ansible Vault password is in a file at `~/vault-pass`. You can create this file with:
```
./scripts/create-guid.sh > ~/vault-pass
```

To encrypt any `Secret` files use:
```
ansible-vault encrypt --vault-pass-file ~/vault-pass k8s/cert-manager/issuers/secret-cloudflare-api-token.yaml
```

To view the encrypted file:
```
ansible-vault view --vault-pass-file ~/vault-pass k8s/cert-manager/issuers/secret-cloudflare-api-token.yaml
```

To apply the `Secret` to your cluster Simply pipe the output of the `view` command to `kubectl apply`:
```
ansible-vault view --vault-pass-file ~/vault-pass k8s/cert-manager/issuers/secret-cloudflare-api-token.yaml | kubectl apply -f -
```
