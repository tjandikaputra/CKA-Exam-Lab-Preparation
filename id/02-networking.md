# Domain 05: Services & Networking (20%)
# CKA Practice Questions

---

## Soal 1
Buat sebuah Pod bernama `network-pod` menggunakan image `tjandikaputra/soal-cka`. Pastikan pod berjalan dan memiliki label `app=network-app`.

### Perintah Verifikasi Mandiri
```bash
kubectl get pod network-pod -o jsonpath='{.metadata.labels.app}'
```

---

## Soal 2
Ekspos `network-pod` tersebut di dalam cluster dengan membuat Service bertipe `ClusterIP` bernama `network-svc` yang menargetkan port `8080`.

### Perintah Verifikasi Mandiri
```bash
kubectl get svc network-svc -o jsonpath='{.spec.type}'
```

---

## Soal 3
Jalankan pod `busybox` interaktif dan gunakan `nslookup network-svc` untuk memvalidasi DNS. Tulis IP internal (ClusterIP) dari `network-svc` tersebut ke file `/opt/network-svc-ip.txt`.

### Perintah Verifikasi Mandiri
```bash
cat /opt/network-svc-ip.txt
```

---

## Soal 4
Ubah Service `network-svc` yang sebelumnya bertipe `ClusterIP` menjadi bertipe `NodePort`. Konfigurasikan secara spesifik agar Service ini menggunakan NodePort `31000`.

### Perintah Verifikasi Mandiri
```bash
kubectl get svc network-svc -o jsonpath='{.spec.ports[0].nodePort}'
```

---

## Soal 5
Buat sebuah resource `Ingress` bernama `network-ingress` untuk Service `network-svc`. Atur Ingress agar me-routing traffic dari host `api.exam.local` pada path `/` ke Service `network-svc` port `8080`.

### Perintah Verifikasi Mandiri
```bash
kubectl get ingress network-ingress -o jsonpath='{.spec.rules[0].host}'
```

---

## Soal 6
Buat sebuah Deployment bernama `backend-deploy` (image: `tjandikaputra/soal-cka`). Buat NetworkPolicy bernama `deny-all` yang memblokir SEMUA traffic Ingress dan Egress untuk Pod yang ada di namespace `default`.

### Perintah Verifikasi Mandiri
```bash
kubectl get netpol deny-all -o jsonpath='{.spec.policyTypes}'
```

---

## Soal 7
Buat NetworkPolicy baru bernama `allow-frontend` yang mengizinkan traffic Ingress ke Pod `backend-deploy` HANYA dari Pod yang memiliki label `role=frontend`.

### Perintah Verifikasi Mandiri
```bash
kubectl get netpol allow-frontend -o jsonpath='{.spec.ingress[0].from[0].podSelector.matchLabels.role}'
```

---

## Soal 8
Modifikasi NetworkPolicy `allow-frontend` untuk juga mengizinkan Egress ke port `53` (UDP/TCP) agar `backend-deploy` dapat melakukan resolve DNS ke CoreDNS.

### Perintah Verifikasi Mandiri
```bash
kubectl get netpol allow-frontend -o jsonpath='{.spec.egress[0].ports[0].port}'
```

---

## Soal 9
Terdapat Service tanpa *selector* bernama `external-db-svc`. Buat resource `Endpoints` bernama sama secara manual, konfigurasikan agar mengarah ke IP `10.50.0.1` di port `3306`.

### Perintah Verifikasi Mandiri
```bash
kubectl get endpoints external-db-svc -o jsonpath='{.subsets[0].addresses[0].ip}'
```

---

## Soal 10
Gunakan tipe service `ExternalName`. Buat Service bernama `legacy-api` yang me-resolve DNS secara internal ke *fully qualified domain name* eksternal `api.legacy.company.com`.

### Perintah Verifikasi Mandiri
```bash
kubectl get svc legacy-api -o jsonpath='{.spec.externalName}'
```
