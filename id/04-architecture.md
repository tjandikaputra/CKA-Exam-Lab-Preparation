# Domain 04: Cluster Architecture, Installation & Config (25%)
# CKA Practice Questions

---

## Soal 1
Buat sebuah ServiceAccount bernama `app-sa` di namespace `default`. Buat juga Role bernama `pod-reader` yang hanya memiliki izin (`verbs`) untuk `get`, `list`, dan `watch` pada resource `pods`.

### Perintah Verifikasi Mandiri
```bash
kubectl get role pod-reader -o jsonpath='{.rules[0].resources[0]}'
```

---

## Soal 2
Buat sebuah RoleBinding bernama `read-pods-binding` yang mengikat (bind) ServiceAccount `app-sa` dengan Role `pod-reader`.

### Perintah Verifikasi Mandiri
```bash
kubectl get rolebinding read-pods-binding -o jsonpath='{.roleRef.name}'
```

---

## Soal 3
Buat sebuah Pod bernama `secure-pod` menggunakan image `tjandikaputra/soal-cka` dan pastikan Pod ini berjalan dengan menggunakan `serviceAccountName: app-sa`.

### Perintah Verifikasi Mandiri
```bash
kubectl get pod secure-pod -o jsonpath='{.spec.serviceAccountName}'
```

---

## Soal 4
Lakukan backup ETCD. Gunakan perintah `etcdctl snapshot save` untuk membuat cadangan database ETCD dari Control Plane. Simpan file snapshot di direktori `/opt/backup/etcd-snapshot.db`.

### Perintah Verifikasi Mandiri
```bash
ETCDCTL_API=3 etcdctl snapshot status /opt/backup/etcd-snapshot.db
```

---

## Soal 5
Lakukan proses *drain* pada salah satu node di cluster Anda secara aman untuk proses maintenance. Pastikan pod-pod DaemonSet diabaikan (`--ignore-daemonsets`).

> **CATATAN**: Jika Anda menggunakan cluster 1 Node, men-*drain* node tersebut akan mematikan semua Pod non-sistem Anda (menjadi Pending). Ini normal, silakan langsung lanjut ke Soal 6 setelah verifikasi ini selesai.

### Perintah Verifikasi Mandiri
```bash
kubectl get nodes -o jsonpath='{.items[*].spec.unschedulable}'
```

---

## Soal 6
Proses maintenance pada node tersebut telah selesai. Lakukan *uncordon* pada node tersebut agar bisa menerima Pod baru lagi.

### Perintah Verifikasi Mandiri
```bash
kubectl get nodes -o jsonpath='{.items[*].spec.unschedulable}'
```

---

## Soal 7
Buat sebuah `ClusterRole` bernama `deployment-manager` yang memiliki izin (`verbs`) untuk `create`, `get`, `list`, `update`, `delete` pada resource `deployments`. Kemudian buat `ClusterRoleBinding` bernama `deploy-manager-binding` untuk mengikat role tersebut ke user `john`.

### Perintah Verifikasi Mandiri
```bash
kubectl get clusterrole deployment-manager -o jsonpath='{.rules[0].resources[0]}'
```

---

## Soal 8
User bernama "developer" memberikan file CSR. Buat resource `CertificateSigningRequest` di Kubernetes bernama `dev-csr` dengan menyertakan string Base64 dari file tersebut. Kemudian setujui (approve) sertifikat tersebut.

### Perintah Verifikasi Mandiri
```bash
kubectl get csr dev-csr -o jsonpath='{.status.conditions[0].type}'
```

---

## Soal 9
Terdapat manifest Deployment `tjandikaputra/soal-cka` di `kustomize/base/`. Buat overlay Kustomize di `kustomize/overlays/prod/` yang mengubah namespace menjadi `prod-ns`. Aplikasikan kustomize tersebut.

### Perintah Verifikasi Mandiri
```bash
kubectl get deploy -n prod-ns -o jsonpath='{.items[0].metadata.name}'
```

---

## Soal 10
Tambahkan repository helm Bitnami, kemudian install rilis baru bernama `my-nginx` menggunakan chart `bitnami/nginx` di namespace `web-ns`.

### Perintah Verifikasi Mandiri
```bash
helm ls -n web-ns
```
