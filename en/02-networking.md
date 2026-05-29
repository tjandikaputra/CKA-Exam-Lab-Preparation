# Domain 05: Services & Networking (20%)
# CKA Practice Questions

---

## Question 1
Create a Pod named `network-pod` using the `tjandikaputra/soal-cka` image. Ensure the pod is running and has the label `app=network-app`.

### Verification Command
```bash
kubectl get pod network-pod -o jsonpath='{.metadata.labels.app}'
```

---

## Question 2
Expose the `network-pod` within the cluster by creating a Service of type `ClusterIP` named `network-svc` targeting port `8080`.

### Verification Command
```bash
kubectl get svc network-svc -o jsonpath='{.spec.type}'
```

---

## Question 3
Run an interactive `busybox` pod and use `nslookup network-svc` to validate DNS. Write the internal IP (ClusterIP) of the `network-svc` to the file `/opt/network-svc-ip.txt`.

### Verification Command
```bash
cat /opt/network-svc-ip.txt
```

---

## Question 4
Change the `network-svc` Service which was previously of type `ClusterIP` to type `NodePort`. Specifically configure this Service to use NodePort `31000`.

### Verification Command
```bash
kubectl get svc network-svc -o jsonpath='{.spec.ports[0].nodePort}'
```

---

## Question 5
Create an `Ingress` resource named `network-ingress` for the `network-svc` Service. Configure the Ingress to route traffic from the host `api.exam.local` on the path `/` to the `network-svc` Service on port `8080`.

### Verification Command
```bash
kubectl get ingress network-ingress -o jsonpath='{.spec.rules[0].host}'
```

---

## Question 6
Create a Deployment named `backend-deploy` (image: `tjandikaputra/soal-cka`). Create a NetworkPolicy named `deny-all` that blocks ALL Ingress and Egress traffic for Pods in the `default` namespace.

### Verification Command
```bash
kubectl get netpol deny-all -o jsonpath='{.spec.policyTypes}'
```

---

## Question 7
Create a new NetworkPolicy named `allow-frontend` that allows Ingress traffic to `backend-deploy` Pods ONLY from Pods that have the label `role=frontend`.

### Verification Command
```bash
kubectl get netpol allow-frontend -o jsonpath='{.spec.ingress[0].from[0].podSelector.matchLabels.role}'
```

---

## Question 8
Modify the `allow-frontend` NetworkPolicy to also allow Egress to port `53` (UDP/TCP) so `backend-deploy` can perform DNS resolution to CoreDNS.

### Verification Command
```bash
kubectl get netpol allow-frontend -o jsonpath='{.spec.egress[0].ports[0].port}'
```

---

## Question 9
There is a Service without a *selector* named `external-db-svc`. Manually create an `Endpoints` resource with the exact same name, configure it to point to IP `10.50.0.1` on port `3306`.

### Verification Command
```bash
kubectl get endpoints external-db-svc -o jsonpath='{.subsets[0].addresses[0].ip}'
```

---

## Question 10
Use the `ExternalName` service type. Create a Service named `legacy-api` that internally resolves DNS to the external *fully qualified domain name* `api.legacy.company.com`.

### Verification Command
```bash
kubectl get svc legacy-api -o jsonpath='{.spec.externalName}'
```
