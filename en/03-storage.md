# Domain 01: Storage (10%)
# CKA Practice Questions

---

## Question 1
Create a Pod named `cka-storage-pod` using the `tjandikaputra/soal-cka` image.
Add an `emptyDir` volume to the pod and mount it at the path `/var/cache/app`.

### Verification Command
```bash
kubectl get pod cka-storage-pod -o jsonpath='{.spec.containers[0].volumeMounts[?(@.mountPath=="/var/cache/app")].name}'
```

---

## Question 2
Create a PersistentVolume named `local-pv-1` with a capacity of `2Gi`. Configure this volume using the `hostPath` type pointing to `/mnt/data/storage`. Ensure the Access Mode is set to `ReadWriteOnce`.

### Verification Command
```bash
kubectl get pv local-pv-1 -o jsonpath='{.spec.capacity.storage}'
```

---

## Question 3
Based on the PV `local-pv-1` created in Question 2, create a PersistentVolumeClaim named `local-pvc-1` that requests `1Gi` of storage. Ensure that the PVC successfully binds to the `local-pv-1` PV.

### Verification Command
```bash
kubectl get pvc local-pvc-1 -o jsonpath='{.status.phase}'
```

---

## Question 4
Create a Deployment named `storage-deploy` with 1 replica using the `tjandikaputra/soal-cka` image. Mount the `local-pvc-1` PVC you created into the container at the path `/usr/share/nginx/html`.

### Verification Command
```bash
kubectl get deploy storage-deploy -o jsonpath='{.spec.template.spec.volumes[?(@.persistentVolumeClaim.claimName=="local-pvc-1")].name}'
```

---

## Question 5
Create a new PersistentVolume named `legacy-pv` (hostPath: `/mnt/legacy`, 1Gi, ReadWriteOnce) with an initial Reclaim Policy of `Delete`. Change the `Reclaim Policy` of this PV from `Delete` to `Retain` so that data is not lost when the PVC is deleted.

### Verification Command
```bash
kubectl get pv legacy-pv -o jsonpath='{.spec.persistentVolumeReclaimPolicy}'
```

---

## Question 6
Create a ConfigMap named `web-content` with the key `index.html` and the value `<h1>Hello</h1>`. Then, create a Pod named `content-pod` (image: `tjandikaputra/soal-cka`) and mount this ConfigMap as a volume at the path `/usr/share/nginx/html`.

### Verification Command
```bash
kubectl get pod content-pod -o jsonpath='{.spec.volumes[?(@.configMap.name=="web-content")].name}'
```

---

## Question 7
Create a Pod named `temp-pod` (image: `tjandikaputra/soal-cka`). Add an `emptyDir` volume with a `sizeLimit` of `100Mi`. Mount this volume at the path `/tmp/data`.

### Verification Command
```bash
kubectl get pod temp-pod -o jsonpath='{.spec.volumes[0].emptyDir.sizeLimit}'
```

---

## Question 8
Create a Pod named `multi-storage-pod` using the `tjandikaputra/soal-cka` image. This Pod must have two volumes:
1. An `emptyDir` mounted at `/temp`
2. The `local-pvc-1` PVC mounted at `/data`

### Verification Command
```bash
kubectl get pod multi-storage-pod -o jsonpath='{range .spec.containers[0].volumeMounts[*]}{.mountPath}{" "}{end}'
```

---

## Question 9
Create a Pod named `log-generator` (image: `tjandikaputra/soal-cka`). This Pod will write logs to `/var/log/app.log`. You must mount a `hostPath` volume from the node to `/var/log` so that the logs are persistent on the host disk at the path `/opt/app-logs`.

### Verification Command
```bash
kubectl get pod log-generator -o jsonpath='{.spec.volumes[?(@.hostPath.path=="/opt/app-logs")].name}'
```

---

## Question 10
A PVC named `critical-data-pvc` and PV `critical-pv` (Retain) exist. If the PVC is deleted, the PV becomes `Released`. Create them, delete the PVC, then recover the PV by removing its `claimRef` so its status returns to `Available`.

### Verification Command
```bash
kubectl get pv critical-pv -o jsonpath='{.status.phase}'
```
