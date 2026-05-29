# Domain 02: Troubleshooting (30%)
# CKA Practice Questions

---

## Soal 1
### Persiapan (Setup)
Terapkan manifest berikut untuk membuat Pod yang bermasalah:
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

### Tugas
Pod `broken-pod` berstatus `ImagePullBackOff`. Edit Pod tersebut secara langsung (tanpa menghapus file yaml aslinya) dan perbaiki typo pada image menjadi `tjandikaputra/soal-cka`.

### Perintah Verifikasi Mandiri
```bash
kubectl get pod broken-pod -o jsonpath='{.status.phase}'
```

---

## Soal 2
### Persiapan (Setup)
Terapkan manifest Deployment ini:
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

### Tugas
Pod dari Deployment `cpu-heavy` selalu berstatus `Pending`. Temukan penyebabnya dan turunkan CPU Request pada Deployment menjadi `100m` agar Pod dapat di-schedule.

### Perintah Verifikasi Mandiri
```bash
kubectl get deploy cpu-heavy -o jsonpath='{.spec.template.spec.containers[0].resources.requests.cpu}'
```

---

## Soal 3
### Persiapan (Setup)
Terapkan manifest Service dan Deployment ini:
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

### Tugas
Perintah `kubectl get endpoints app-service` kosong. Perbaiki *selector* di Service tersebut agar sesuai dengan label yang digunakan oleh Deployment, sehingga Service memiliki endpoint.

### Perintah Verifikasi Mandiri
```bash
kubectl get endpoints app-service -o jsonpath='{.subsets[0].addresses[0].ip}'
```

---

## Soal 4
### Persiapan (Setup)
Terapkan manifest Pod ini:
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

### Tugas
Aplikasi di dalam Pod diatur menggunakan Liveness Probe. Perbaiki Liveness Probe tersebut

### Perintah Verifikasi Mandiri
```bash
kubectl get pod api-server-pod -o jsonpath='{.spec.containers[0].livenessProbe.httpGet.port}'
```

---

## Soal 5
### Tugas
Cari Pod di namespace `kube-system` yang paling banyak mengkonsumsi CPU saat ini menggunakan perintah observabilitas metrik. Tuliskan nama Pod tersebut ke dalam file `/opt/highest_cpu_pod.txt`. *(Soal ini tidak butuh Setup)*.

### Perintah Verifikasi Mandiri
```bash
cat /opt/highest_cpu_pod.txt
```

---

## Soal 6
### Persiapan (Setup)
Terapkan manifest Pod multi-container ini:
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

### Tugas
Pod `web-logger` memiliki satu container yang terus mengalami `CrashLoopBackOff`. Lihat log spesifik dari container yang rusak tersebut (container `logger`). Simpan output log-nya ke `/opt/web-logger-error.log`.

### Perintah Verifikasi Mandiri
```bash
cat /opt/web-logger-error.log
```

---

## Soal 7
### Persiapan (Setup)
Terapkan NetworkPolicy ini:
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

### Tugas
NetworkPolicy di atas memblokir semua traffic Ingress di namespace default. Buat NetworkPolicy baru bernama `allow-internal` yang mengizinkan *Ingress* traffic HANYA dari pod-pod di namespace yang sama.

### Perintah Verifikasi Mandiri
```bash
kubectl get netpol allow-internal -o jsonpath='{.spec.ingress[0].from[0].podSelector.matchLabels}'
```

---

## Soal 8
### Tugas
Service `kube-dns` di namespace `kube-system` tidak memiliki endpoint. Cek log pod `coredns`. Jika ada error konfigurasi di ConfigMap `coredns`, perbaiki dengan menghapus baris yang typo/rusak (seperti plugin yang tidak valid), lalu restart pod `coredns`. *(Soal ini asumsikan simulasi config coredns rusak. Jika di RKE2 Anda normal, abaikan atau sesuaikan dengan kondisi riil)*.

### Perintah Verifikasi Mandiri
```bash
kubectl get endpoints kube-dns -n kube-system -o jsonpath='{.subsets[0].addresses[0].ip}'
```

---

## Soal 9
### Tugas
Temukan *Event* yang berjenis peringatan (`Warning`) atau error di namespace `default` menggunakan `kubectl get events`. Simpan output (nama object atau pesannya) ke dalam file `/opt/cluster_events.txt`.

### Perintah Verifikasi Mandiri
```bash
cat /opt/cluster_events.txt
```

---

## Soal 10
### Persiapan (Setup)
Terapkan manifest Deployment ini:
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

### Tugas
Deployment `oom-deploy` memiliki memory limit sangat kecil (10Mi). Pod mungkin akan berstatus `OOMKilled` saat berjalan atau menerima traffic. Naikkan Memory Limit pada container di deployment tersebut menjadi `128Mi`.

### Perintah Verifikasi Mandiri
```bash
kubectl get deploy oom-deploy -o jsonpath='{.spec.template.spec.containers[0].resources.limits.memory}'
```
