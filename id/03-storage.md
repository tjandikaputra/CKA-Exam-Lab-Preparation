# Domain 01: Storage (10%)
# CKA Practice Questions

---

## Soal 1
Buat sebuah Pod bernama `cka-storage-pod` menggunakan image `tjandikaputra/soal-cka`.
Tambahkan sebuah volume berjenis `emptyDir` ke dalam pod tersebut dan mount volume itu pada path `/var/cache/app`.

### Perintah Verifikasi Mandiri
```bash
kubectl get pod cka-storage-pod -o jsonpath='{.spec.containers[0].volumeMounts[?(@.mountPath=="/var/cache/app")].name}'
```

---

## Soal 2
Buat sebuah PersistentVolume bernama `local-pv-1` dengan kapasitas `2Gi`. Konfigurasikan volume ini menggunakan tipe `hostPath` yang mengarah ke `/mnt/data/storage`. Pastikan Access Mode yang diset adalah `ReadWriteOnce`.

### Perintah Verifikasi Mandiri
```bash
kubectl get pv local-pv-1 -o jsonpath='{.spec.capacity.storage}'
```

---

## Soal 3
Berdasarkan PV `local-pv-1` yang dibuat pada Soal 2, buatlah sebuah PersistentVolumeClaim bernama `local-pvc-1` yang meminta (request) storage sebesar `1Gi`. Pastikan PVC tersebut berhasil terikat (Bound) dengan PV `local-pv-1`.

### Perintah Verifikasi Mandiri
```bash
kubectl get pvc local-pvc-1 -o jsonpath='{.status.phase}'
```

---

## Soal 4
Buat sebuah Deployment bernama `storage-deploy` dengan 1 replika menggunakan image `tjandikaputra/soal-cka`. Mount PVC `local-pvc-1` yang telah Anda buat ke dalam container pada path `/usr/share/nginx/html`.

### Perintah Verifikasi Mandiri
```bash
kubectl get deploy storage-deploy -o jsonpath='{.spec.template.spec.volumes[?(@.persistentVolumeClaim.claimName=="local-pvc-1")].name}'
```

---

## Soal 5
Buat PersistentVolume baru bernama `legacy-pv` (hostPath: `/mnt/legacy`, 1Gi, ReadWriteOnce) dengan Reclaim Policy awal `Delete`. Ubah `Reclaim Policy` dari PV tersebut dari `Delete` menjadi `Retain` agar data tidak hilang ketika PVC dihapus.

### Perintah Verifikasi Mandiri
```bash
kubectl get pv legacy-pv -o jsonpath='{.spec.persistentVolumeReclaimPolicy}'
```

---

## Soal 6
Buat sebuah ConfigMap bernama `web-content` dengan key `index.html` dan value `<h1>Hello</h1>`. Kemudian, buat Pod bernama `content-pod` (image: `tjandikaputra/soal-cka`) dan mount ConfigMap tersebut sebagai volume di path `/usr/share/nginx/html`.

### Perintah Verifikasi Mandiri
```bash
kubectl get pod content-pod -o jsonpath='{.spec.volumes[?(@.configMap.name=="web-content")].name}'
```

---

## Soal 7
Buat Pod bernama `temp-pod` (image: `tjandikaputra/soal-cka`). Tambahkan volume bertipe `emptyDir` dengan batasan ukuran (`sizeLimit`) sebesar `100Mi`. Mount volume tersebut pada path `/tmp/data`.

### Perintah Verifikasi Mandiri
```bash
kubectl get pod temp-pod -o jsonpath='{.spec.volumes[0].emptyDir.sizeLimit}'
```

---

## Soal 8
Buat Pod bernama `multi-storage-pod` menggunakan image `tjandikaputra/soal-cka`. Pod ini harus memiliki dua volume:
1. Sebuah `emptyDir` yang di-mount di `/temp`
2. PVC `local-pvc-1` yang di-mount di `/data`

### Perintah Verifikasi Mandiri
```bash
kubectl get pod multi-storage-pod -o jsonpath='{range .spec.containers[0].volumeMounts[*]}{.mountPath}{" "}{end}'
```

---

## Soal 9
Buat sebuah Pod bernama `log-generator` (image: `tjandikaputra/soal-cka`). Pod ini akan menulis log ke `/var/log/app.log`. Anda harus me-mount sebuah volume bertipe `hostPath` dari node ke `/var/log` agar log persisten di disk host pada path `/opt/app-logs`.

### Perintah Verifikasi Mandiri
```bash
kubectl get pod log-generator -o jsonpath='{.spec.volumes[?(@.hostPath.path=="/opt/app-logs")].name}'
```

---

## Soal 10
Sebuah PVC bernama `critical-data-pvc` dan PV `critical-pv` (Retain) sudah ada. Jika PVC terhapus tak sengaja, PV akan berstatus `Released`. Buat PV dan PVC tersebut, lalu hapus PVC. Kemudian pulihkan PV tersebut dengan menghapus `claimRef` di dalamnya agar statusnya kembali `Available`.

### Perintah Verifikasi Mandiri
```bash
kubectl get pv critical-pv -o jsonpath='{.status.phase}'
```
