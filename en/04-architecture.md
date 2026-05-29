# Domain 04: Cluster Architecture, Installation & Config (25%)
# CKA Practice Questions

---

## Question 1
Create a ServiceAccount named `app-sa` in the `default` namespace. Also, create a Role named `pod-reader` that only has permissions (`verbs`) to `get`, `list`, and `watch` on `pods` resources.

### Verification Command
```bash
kubectl get role pod-reader -o jsonpath='{.rules[0].resources[0]}'
```

---

## Question 2
Create a RoleBinding named `read-pods-binding` that binds the `app-sa` ServiceAccount to the `pod-reader` Role.

### Verification Command
```bash
kubectl get rolebinding read-pods-binding -o jsonpath='{.roleRef.name}'
```

---

## Question 3
Create a Pod named `secure-pod` using the `tjandikaputra/soal-cka` image and ensure this Pod runs using `serviceAccountName: app-sa`.

### Verification Command
```bash
kubectl get pod secure-pod -o jsonpath='{.spec.serviceAccountName}'
```

---

## Question 4
Perform an ETCD backup. Use the `etcdctl snapshot save` command to create a backup of the ETCD database from the Control Plane. Save the snapshot file in the directory `/opt/backup/etcd-snapshot.db`.

### Verification Command
```bash
ETCDCTL_API=3 etcdctl snapshot status /opt/backup/etcd-snapshot.db
```

---

## Question 5
Perform a safe *drain* process on one of the nodes in your cluster for maintenance purposes. Ensure pods managed by DaemonSets are ignored (`--ignore-daemonsets`).

> **NOTE**: If you are using a 1-Node cluster, draining the node will evict all your non-system Pods (leaving them Pending). This is normal. Please proceed directly to Question 6 to fix this.

### Verification Command
```bash
kubectl get nodes -o jsonpath='{.items[*].spec.unschedulable}'
```

---

## Question 6
The maintenance process on that node is complete. Perform an *uncordon* on the node so it can receive new Pods again.

### Verification Command
```bash
kubectl get nodes -o jsonpath='{.items[*].spec.unschedulable}'
```

---

## Question 7
Create a `ClusterRole` named `deployment-manager` that has permissions (`verbs`) to `create`, `get`, `list`, `update`, `delete` on `deployments` resources. Then create a `ClusterRoleBinding` named `deploy-manager-binding` to bind this role to the user `john`.

### Verification Command
```bash
kubectl get clusterrole deployment-manager -o jsonpath='{.rules[0].resources[0]}'
```

---

## Question 8
A user named "developer" provides a CSR file. Create a `CertificateSigningRequest` resource in Kubernetes named `dev-csr` including the Base64 string of that file. Then approve the certificate.

### Verification Command
```bash
kubectl get csr dev-csr -o jsonpath='{.status.conditions[0].type}'
```

---

## Question 9
There is a Deployment manifest for `tjandikaputra/soal-cka` in `kustomize/base/`. Create a Kustomize overlay in `kustomize/overlays/prod/` that changes the namespace to `prod-ns`. Apply the kustomize.

### Verification Command
```bash
kubectl get deploy -n prod-ns -o jsonpath='{.items[0].metadata.name}'
```

---

## Question 10
Add the Bitnami helm repository, then install a new release named `my-nginx` using the `bitnami/nginx` chart in the `web-ns` namespace.

### Verification Command
```bash
helm ls -n web-ns
```
