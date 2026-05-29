# CKA Exam Lab Preparation

![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)
![CKA](https://img.shields.io/badge/CKA-Practice-blue?style=for-the-badge)
![Language](https://img.shields.io/badge/Language-ID%20%7C%20EN-success?style=for-the-badge)

Welcome to the **CKA Exam Lab Preparation** repository! This project contains a curated list of 50 hands-on practice questions specifically designed to mirror the challenges, domains, and difficulty levels of the CKA 2026 exam. 

To provide the best learning experience, questions are completely separated by language into the `id/` (Indonesian) and `en/` (English) folders.

## 🎯 Exam Domains Covered

The questions are divided into 5 markdown files inside the language folders, strictly following the official CNCF CKA curriculum weights, ordered from easiest to hardest:

1. **[01-workloads.md] (15%)**: Deployments, Rolling Updates, Rollbacks, ConfigMaps, Secrets, HPA, Limits, and Node Affinity.
2. **[02-networking.md] (20%)**: Pod connectivity, Services (ClusterIP, NodePort, ExternalName), Ingress, CoreDNS, and NetworkPolicies.
3. **[03-storage.md] (10%)**: StorageClasses, PersistentVolumes, PersistentVolumeClaims, Access Modes, Reclaim Policies, EmptyDirs.
4. **[04-architecture.md] (25%)**: RBAC, Kubeadm upgrade/join, ETCD backup/restore, Helm, Kustomize, and CSR.
5. **[05-troubleshooting.md] (30%)**: Cluster & Node troubleshooting, Application logs, Probes, Network Policies, and OOMKilled scenarios.

## 🛠️ Lab Preparation & Environment Setup

To get the most out of this simulator, we strongly recommend running this on a fresh, single-node Virtual Machine. Follow these steps to prepare your lab:

### 1. Provision a Virtual Machine
Prepare a Linux VM (Ubuntu 22.04/24.04 recommended) with at least:
- **CPU**: 2 Cores
- **RAM**: 4 GB
- **Storage**: 20 GB Free Space

### 2. Install RKE2 (Single-Node Kubernetes)
We use RKE2 as it perfectly simulates a production-grade Kubernetes environment with minimal resource overhead.
1. Run the official RKE2 installation script:
   ```bash
   curl -sfL https://get.rke2.io | sh -
   ```
2. Enable and start the RKE2 server service:
   ```bash
   systemctl enable rke2-server.service
   systemctl start rke2-server.service
   ```
3. Set up your `kubeconfig` and `kubectl` alias:
   ```bash
   export KUBECONFIG=/etc/rancher/rke2/rke2.yaml
   sudo cp /var/lib/rancher/rke2/bin/kubectl /usr/local/bin/
   alias k=kubectl
   ```
*(For detailed RKE2 documentation, visit the [official RKE2 Quick Start Guide](https://docs.rke2.io/install/quickstart)).*

### 3. Clone This Repository
Once your Kubernetes cluster is `Ready`, clone this repository into your VM:
```bash
git clone <your-repo-url>
cd cka-exam-lab-preparation/soal-cka
chmod +x verify.sh
```

## 🚀 How to Use This Simulator

To create a realistic exam environment, almost all questions in this repository utilize a custom Docker image specifically built for testing workloads:

```bash
tjandikaputra/soal-cka
```

### Self-Verification
In every question markdown file, you will find a **"Verification Command"** (Perintah Verifikasi Mandiri). You can run this command in your terminal manually to check if you have configured the resource correctly.

### Automated Grading Simulator (Like Killer.sh)
We have included a professional automated grading script (`verify.sh`) that evaluates your cluster state and gives you a score out of 50, exactly like real exam simulators.

**How to run the auto-grader:**
1. Give execution permission to the script:
   ```bash
   chmod +x verify.sh
   ```
2. Run the script:
   ```bash
   ./verify.sh
   ```
3. The script will output `[PASS]` or `[FAIL]` for each of the 50 questions and provide a Final Score (Passing score is 66%).

> **⚠️ WARNING:** The `verify.sh` file contains the exact Kubernetes object properties that are expected for a correct answer. **Do not read the contents of `verify.sh`** if you want to simulate a real exam, as it will spoil the solutions for you! Use it strictly for automated grading at the end of your session.

## 🤝 Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 👥 Contributors

A huge thank you to everyone who has contributed to making this mock exam better!

<a href="https://github.com/tjandikaputra/cka-exam-lab-preparation/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=tjandikaputra/cka-exam-lab-preparation" alt="Contributors" />
</a>

## 📝 License

Distributed under the MIT License. See [`LICENSE`](./LICENSE) for more information.

---
*Disclaimer: This repository is an independent study guide and is not affiliated with, officially endorsed by, or sponsored by the Cloud Native Computing Foundation (CNCF) or the Linux Foundation.*
