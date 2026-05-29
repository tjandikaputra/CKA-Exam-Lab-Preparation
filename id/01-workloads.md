# Domain 03: Workloads & Scheduling (15%)
# CKA Practice Questions

---

## Soal 1
Buat sebuah Deployment bernama `frontend-deploy` dengan 3 replika menggunakan image `tjandikaputra/soal-cka`. Set label `tier=frontend` pada Deployment dan Pod template-nya.

### Perintah Verifikasi Mandiri
```bash
kubectl get deploy frontend-deploy -o jsonpath='{.spec.replicas}'
```

---

## Soal 2
Lakukan *Rolling Update* pada `frontend-deploy` dengan mengubah image-nya menjadi `tjandikaputra/soal-cka:v2`. Pastikan proses update menggunakan strategi *RollingUpdate*.

### Perintah Verifikasi Mandiri
```bash
kubectl get deploy frontend-deploy -o jsonpath='{.spec.template.spec.containers[0].image}'
```

---

## Soal 3
Asumsikan versi `v2` memiliki bug kritis. Lakukan *Rollback* (Undo) pada Deployment `frontend-deploy` agar kembali menggunakan image versi awal.

### Perintah Verifikasi Mandiri
```bash
kubectl rollout history deploy frontend-deploy
```

---

## Soal 4
Buat ConfigMap bernama `app-config` berisi key `THEME` dengan value `dark`. Kemudian, edit deployment `frontend-deploy` dan injeksikan ConfigMap tersebut sebagai *Environment Variable*.

### Perintah Verifikasi Mandiri
```bash
kubectl get deploy frontend-deploy -o jsonpath='{.spec.template.spec.containers[0].envFrom[0].configMapRef.name}'
```

---

## Soal 5
Buat Secret bernama `db-secret` berjenis *Opaque* berisi kredensial `DB_USER=admin` dan `DB_PASS=12345`. Mount Secret ini sebagai volume di Deployment `frontend-deploy` pada path `/etc/secrets`.

### Perintah Verifikasi Mandiri
```bash
kubectl get deploy frontend-deploy -o jsonpath='{.spec.template.spec.volumes[?(@.secret.secretName=="db-secret")].name}'
```

---

## Soal 6
Buat HorizontalPodAutoscaler (HPA) bernama `frontend-hpa` untuk Deployment `frontend-deploy`. Set minimum pod 2, maksimum pod 5, target CPU 80%.

### Perintah Verifikasi Mandiri
```bash
kubectl get hpa frontend-hpa -o jsonpath='{.spec.maxReplicas}'
```

---

## Soal 7
Terapkan *Resource Limits*. Buat Pod bernama `limited-pod` menggunakan image `tjandikaputra/soal-cka`. Request CPU `200m` & Memory `128Mi`, Limit CPU `500m` & Memory `256Mi`.

### Perintah Verifikasi Mandiri
```bash
kubectl get pod limited-pod -o jsonpath='{.spec.containers[0].resources.limits.memory}'
```

---

## Soal 8
Terapkan *Node Affinity*. Gunakan `kubectl get nodes` untuk mencari nama node di cluster Anda, lalu labeli node tersebut dengan `disktype=ssd`. Buat Deployment `db-deploy` (image: `tjandikaputra/soal-cka`) yang diatur untuk *hanya boleh* di-schedule di node berlabel `disktype=ssd` menggunakan `requiredDuringScheduling...`.

### Perintah Verifikasi Mandiri
```bash
kubectl get deploy db-deploy -o jsonpath='{.spec.template.spec.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].key}'
```

---

## Soal 9
Terapkan taint pada node Anda (pilih dari `kubectl get nodes`) dengan key `env`, value `prod`, dan effect `NoSchedule`. Buat Pod `prod-pod` (image: `tjandikaputra/soal-cka`) dan tambahkan *Toleration* agar pod ini bisa di-schedule di node yang memiliki taint tersebut.

> **PENTING**: Karena Anda menggunakan 1 node, setelah perintah verifikasi berhasil, **SEGERA HAPUS** taint tersebut (`kubectl taint nodes <nama-node> env=prod:NoSchedule-`) agar node Anda bisa menerima Pod untuk soal-soal berikutnya!

### Perintah Verifikasi Mandiri
```bash
kubectl get pod prod-pod -o jsonpath='{.spec.tolerations[?(@.key=="env")].value}'
```

---

## Soal 10
Buat *Static Pod* bernama `static-web`. Anda harus membuat file manifest YAML-nya dan meletakkannya di direktori static pod Kubelet pada *Control Plane node* (biasanya `/etc/kubernetes/manifests`), menggunakan image `tjandikaputra/soal-cka`.

### Perintah Verifikasi Mandiri
```bash
kubectl get pods | grep static-web
```
