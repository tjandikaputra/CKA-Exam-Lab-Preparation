# Domain 02: Troubleshooting (30%)
# CKA Practice Questions

---

## Question 1
### Setup
Apply this manifest to create a broken Pod:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: broken-pod
spec:
  containers:
  - name: app
    image: tjandikaputra/soal-ckaa
```

### Task
The Pod `broken-pod` is in `ImagePullBackOff`. Edit the Pod directly and fix the image typo to `tjandikaputra/soal-cka`.

### Verification Command
```bash
kubectl get pod broken-pod -o jsonpath='{.status.phase}'
```

---

## Question 2
### Setup
Apply this Deployment manifest:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cpu-heavy
spec:
  replicas: 1
  selector:
    matchLabels:
      app: cpu-heavy
  template:
    metadata:
      labels:
        app: cpu-heavy
    spec:
      containers:
      - name: app
        image: tjandikaputra/soal-cka
        resources:
          requests:
            cpu: "40000m"
```

### Task
Pods from the `cpu-heavy` Deployment are always `Pending`. Decrease the CPU Request on the Deployment to `100m` so the Pod can be scheduled.

### Verification Command
```bash
kubectl get deploy cpu-heavy -o jsonpath='{.spec.template.spec.containers[0].resources.requests.cpu}'
```

---

## Question 3
### Setup
Apply this Service and Deployment manifest:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-deploy
spec:
  replicas: 1
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: app
        image: tjandikaputra/soal-cka
---
apiVersion: v1
kind: Service
metadata:
  name: app-service
spec:
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 8080
```

### Task
The command `kubectl get endpoints app-service` is empty. Fix the Service selector to match the label used by the Deployment.

### Verification Command
```bash
kubectl get endpoints app-service -o jsonpath='{.subsets[0].addresses[0].ip}'
```

---

## Question 4
### Setup
Apply this Pod manifest:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: api-server-pod
spec:
  containers:
  - name: app
    image: tjandikaputra/soal-cka
    env:
    - name: APP_PORT
      value: "8082"
    livenessProbe:
      httpGet:
        path: /health
        port: 8080
      initialDelaySeconds: 3
      periodSeconds: 3
```

### Task
The container application is set to listen on port 8082 via `APP_PORT`. The pod keeps restarting. Fix the Liveness Probe.

### Verification Command
```bash
kubectl get pod api-server-pod -o jsonpath='{.spec.containers[0].livenessProbe.httpGet.port}'
```

---

## Question 5
### Task
Find the Pod in the `kube-system` namespace that currently consumes the most CPU using metrics observability tools. Write the name of that Pod into the file `/opt/highest_cpu_pod.txt`. *(No Setup required)*.

### Verification Command
```bash
cat /opt/highest_cpu_pod.txt
```

---

## Question 6
### Setup
Apply this multi-container Pod manifest:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: web-logger
spec:
  containers:
  - name: web
    image: nginx:alpine
  - name: logger
    image: busybox
    command: ["sh", "-c", "echo 'CRITICAL: Disk full error'; exit 1"]
```

### Task
The `web-logger` Pod has a container that keeps experiencing `CrashLoopBackOff`. View the specific log from the broken container (`logger`). Save the log output to `/opt/web-logger-error.log`.

### Verification Command
```bash
cat /opt/web-logger-error.log
```

---

## Question 7
### Setup
Apply this NetworkPolicy:
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
  namespace: default
spec:
  podSelector: {}
  policyTypes:
  - Ingress
```

### Task
The NetworkPolicy above blocks all Ingress traffic in the default namespace. Create a new NetworkPolicy named `allow-internal` that allows *Ingress* traffic ONLY from pods in the same namespace.

### Verification Command
```bash
kubectl get netpol allow-internal -o jsonpath='{.spec.ingress[0].from[0].podSelector.matchLabels}'
```

---

## Question 8
### Task
Service `kube-dns` in the `kube-system` namespace has no endpoints. Check the `coredns` pod log. If there is a config error in the `coredns` ConfigMap, fix it by removing the typo/corrupt line, then restart the `coredns` pods. *(Assume simulated breakage. If RKE2 is fine, skip or adapt)*.

### Verification Command
```bash
kubectl get endpoints kube-dns -n kube-system -o jsonpath='{.subsets[0].addresses[0].ip}'
```

---

## Question 9
### Task
Find `Warning` or `Error` events in the `default` namespace using `kubectl get events`. Save the output (e.g., the object name or message) into the file `/opt/cluster_events.txt`. *(No Setup required)*.

### Verification Command
```bash
cat /opt/cluster_events.txt
```

---

## Question 10
### Setup
Apply this Deployment manifest:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: oom-deploy
spec:
  replicas: 1
  selector:
    matchLabels:
      app: oom
  template:
    metadata:
      labels:
        app: oom
    spec:
      containers:
      - name: app
        image: tjandikaputra/soal-cka
        resources:
          limits:
            memory: "10Mi"
```

### Task
The `oom-deploy` Deployment has a very small memory limit (10Mi). The pod gets `OOMKilled`. Increase the Memory Limit on the container in the deployment to `128Mi`.

### Verification Command
```bash
kubectl get deploy oom-deploy -o jsonpath='{.spec.template.spec.containers[0].resources.limits.memory}'
```
