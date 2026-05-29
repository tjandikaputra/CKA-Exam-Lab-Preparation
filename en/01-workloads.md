# Domain 03: Workloads & Scheduling (15%)
# CKA Practice Questions

---

## Question 1
Create a Deployment named `frontend-deploy` with 3 replicas using the `tjandikaputra/soal-cka` image. Set the label `tier=frontend` on the Deployment and its Pod template.

### Verification Command
```bash
kubectl get deploy frontend-deploy -o jsonpath='{.spec.replicas}'
```

---

## Question 2
Perform a *Rolling Update* on `frontend-deploy` by changing its image to `tjandikaputra/soal-cka:v2`. Ensure the update process uses the *RollingUpdate* strategy.

### Verification Command
```bash
kubectl get deploy frontend-deploy -o jsonpath='{.spec.template.spec.containers[0].image}'
```

---

## Question 3
Assume version `v2` has a critical bug. Perform a *Rollback* (Undo) on the `frontend-deploy` Deployment so it reverts back to the initial image version.

### Verification Command
```bash
kubectl rollout history deploy frontend-deploy
```

---

## Question 4
Create a ConfigMap named `app-config` containing the key `THEME` with the value `dark`. Then, edit the `frontend-deploy` deployment and inject the ConfigMap as an *Environment Variable*.

### Verification Command
```bash
kubectl get deploy frontend-deploy -o jsonpath='{.spec.template.spec.containers[0].envFrom[0].configMapRef.name}'
```

---

## Question 5
Create a Secret named `db-secret` of type *Opaque* containing the credentials `DB_USER=admin` and `DB_PASS=12345`. Mount this Secret as a volume in the `frontend-deploy` Deployment at the path `/etc/secrets`.

### Verification Command
```bash
kubectl get deploy frontend-deploy -o jsonpath='{.spec.template.spec.volumes[?(@.secret.secretName=="db-secret")].name}'
```

---

## Question 6
Create a HorizontalPodAutoscaler (HPA) named `frontend-hpa` for the `frontend-deploy` Deployment. Set the minimum pods to 2, maximum pods to 5, target CPU 80%.

### Verification Command
```bash
kubectl get hpa frontend-hpa -o jsonpath='{.spec.maxReplicas}'
```

---

## Question 7
Apply *Resource Limits*. Create a Pod named `limited-pod` using the `tjandikaputra/soal-cka` image. Request CPU `200m` & Memory `128Mi`, Limit CPU `500m` & Memory `256Mi`.

### Verification Command
```bash
kubectl get pod limited-pod -o jsonpath='{.spec.containers[0].resources.limits.memory}'
```

---

## Question 8
Apply *Node Affinity*. Use `kubectl get nodes` to find the name of your node, then label it with `disktype=ssd`. Create a Deployment `db-deploy` (image: `tjandikaputra/soal-cka`) configured to *only* be scheduled on nodes labeled `disktype=ssd` using `requiredDuringScheduling...`.

### Verification Command
```bash
kubectl get deploy db-deploy -o jsonpath='{.spec.template.spec.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].key}'
```

---

## Question 9
Apply a taint to your node (choose from `kubectl get nodes`) with the key `env`, value `prod`, and effect `NoSchedule`. Create a Pod `prod-pod` (image: `tjandikaputra/soal-cka`) and add a *Toleration* so this pod can be scheduled on the tainted node.

> **IMPORTANT**: Since you are using a single-node cluster, after the verification command succeeds, **IMMEDIATELY REMOVE** the taint (`kubectl taint nodes <node-name> env=prod:NoSchedule-`) so your node can accept Pods for subsequent questions!

### Verification Command
```bash
kubectl get pod prod-pod -o jsonpath='{.spec.tolerations[?(@.key=="env")].value}'
```

---

## Question 10
Create a *Static Pod* named `static-web`. You must create its YAML manifest file and place it in the Kubelet static pod directory on the *Control Plane node* (usually `/etc/kubernetes/manifests`), using the `tjandikaputra/soal-cka` image.

### Verification Command
```bash
kubectl get pods | grep static-web
```
