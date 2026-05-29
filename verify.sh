#!/bin/bash

# CKA 2026 Practice - Auto Grader Script
# Run this script to verify your answers and get your score.

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCORE=0
TOTAL=50

echo -e "${YELLOW}Starting CKA Verification Script...${NC}"
echo "========================================="

check_not_empty() {
  local Q_NUM=$1
  local ACTUAL=$2
  if [ -n "$ACTUAL" ]; then
    echo -e "${GREEN}[PASS] Question $Q_NUM${NC}"
    SCORE=$((SCORE+1))
  else
    echo -e "${RED}[FAIL] Question $Q_NUM${NC}"
  fi
}

check_exact() {
  local Q_NUM=$1
  local EXPECTED=$2
  local ACTUAL=$3
  if [ "$ACTUAL" == "$EXPECTED" ]; then
    echo -e "${GREEN}[PASS] Question $Q_NUM${NC}"
    SCORE=$((SCORE+1))
  else
    echo -e "${RED}[FAIL] Question $Q_NUM${NC} (Got: $ACTUAL, Expected: $EXPECTED)"
  fi
}

check_contains() {
  local Q_NUM=$1
  local EXPECTED=$2
  local ACTUAL=$3
  if [[ "$ACTUAL" == *"$EXPECTED"* ]]; then
    echo -e "${GREEN}[PASS] Question $Q_NUM${NC}"
    SCORE=$((SCORE+1))
  else
    echo -e "${RED}[FAIL] Question $Q_NUM${NC}"
  fi
}

echo -e "\n${YELLOW}--- Domain 01: Workloads & Scheduling ---${NC}"
check_exact "1.1" "3" "$(kubectl get deploy frontend-deploy -o jsonpath='{.spec.replicas}' 2>/dev/null)"
check_exact "1.2" "tjandikaputra/soal-cka:v2" "$(kubectl get deploy frontend-deploy -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)"
check_exact "1.3" "tjandikaputra/soal-cka" "$(kubectl get deploy frontend-deploy -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)" # Rollback returns to original
check_exact "1.4" "app-config" "$(kubectl get deploy frontend-deploy -o jsonpath='{.spec.template.spec.containers[0].envFrom[0].configMapRef.name}' 2>/dev/null)"
check_exact "1.5" "db-secret" "$(kubectl get deploy frontend-deploy -o jsonpath='{.spec.template.spec.volumes[?(@.secret.secretName=="db-secret")].name}' 2>/dev/null)"
check_exact "1.6" "5" "$(kubectl get hpa frontend-hpa -o jsonpath='{.spec.maxReplicas}' 2>/dev/null)"
check_exact "1.7" "256Mi" "$(kubectl get pod limited-pod -o jsonpath='{.spec.containers[0].resources.limits.memory}' 2>/dev/null)"
check_exact "1.8" "disktype" "$(kubectl get deploy db-deploy -o jsonpath='{.spec.template.spec.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].key}' 2>/dev/null)"
check_exact "1.9" "prod" "$(kubectl get pod prod-pod -o jsonpath='{.spec.tolerations[?(@.key=="env")].value}' 2>/dev/null)"
check_not_empty "1.10" "$(kubectl get pods | grep static-web 2>/dev/null)"

echo -e "\n${YELLOW}--- Domain 02: Services & Networking ---${NC}"
check_exact "2.1" "network-app" "$(kubectl get pod network-pod -o jsonpath='{.metadata.labels.app}' 2>/dev/null)"
check_exact "2.2" "ClusterIP" "$(kubectl get svc network-svc -o jsonpath='{.spec.type}' 2>/dev/null)"
check_not_empty "2.3" "$(cat /opt/network-svc-ip.txt 2>/dev/null)"
check_exact "2.4" "31000" "$(kubectl get svc network-svc -o jsonpath='{.spec.ports[0].nodePort}' 2>/dev/null)"
check_exact "2.5" "api.exam.local" "$(kubectl get ingress network-ingress -o jsonpath='{.spec.rules[0].host}' 2>/dev/null)"
check_contains "2.6" "Ingress" "$(kubectl get netpol deny-all -o jsonpath='{.spec.policyTypes}' 2>/dev/null)"
check_exact "2.7" "frontend" "$(kubectl get netpol allow-frontend -o jsonpath='{.spec.ingress[0].from[0].podSelector.matchLabels.role}' 2>/dev/null)"
check_exact "2.8" "53" "$(kubectl get netpol allow-frontend -o jsonpath='{.spec.egress[0].ports[0].port}' 2>/dev/null)"
check_exact "2.9" "10.50.0.1" "$(kubectl get endpoints external-db-svc -o jsonpath='{.subsets[0].addresses[0].ip}' 2>/dev/null)"
check_exact "2.10" "api.legacy.company.com" "$(kubectl get svc legacy-api -o jsonpath='{.spec.externalName}' 2>/dev/null)"

echo -e "\n${YELLOW}--- Domain 03: Storage ---${NC}"
check_not_empty "3.1" "$(kubectl get pod cka-storage-pod -o jsonpath='{.spec.containers[0].volumeMounts[?(@.mountPath=="/var/cache/app")].name}' 2>/dev/null)"
check_exact "3.2" "2Gi" "$(kubectl get pv local-pv-1 -o jsonpath='{.spec.capacity.storage}' 2>/dev/null)"
check_exact "3.3" "Bound" "$(kubectl get pvc local-pvc-1 -o jsonpath='{.status.phase}' 2>/dev/null)"
check_exact "3.4" "local-pvc-1" "$(kubectl get deploy storage-deploy -o jsonpath='{.spec.template.spec.volumes[?(@.persistentVolumeClaim.claimName=="local-pvc-1")].persistentVolumeClaim.claimName}' 2>/dev/null)"
check_exact "3.5" "Retain" "$(kubectl get pv legacy-pv -o jsonpath='{.spec.persistentVolumeReclaimPolicy}' 2>/dev/null)"
check_exact "3.6" "web-content" "$(kubectl get pod content-pod -o jsonpath='{.spec.volumes[?(@.configMap.name=="web-content")].name}' 2>/dev/null)"
check_exact "3.7" "100Mi" "$(kubectl get pod temp-pod -o jsonpath='{.spec.volumes[0].emptyDir.sizeLimit}' 2>/dev/null)"
check_contains "3.8" "/data" "$(kubectl get pod multi-storage-pod -o jsonpath='{range .spec.containers[0].volumeMounts[*]}{.mountPath}{" "}{end}' 2>/dev/null)"
check_not_empty "3.9" "$(kubectl get pod log-generator -o jsonpath='{.spec.volumes[?(@.hostPath.path=="/opt/app-logs")].name}' 2>/dev/null)"
check_exact "3.10" "Available" "$(kubectl get pv critical-pv -o jsonpath='{.status.phase}' 2>/dev/null)"

echo -e "\n${YELLOW}--- Domain 04: Architecture ---${NC}"
check_exact "4.1" "pods" "$(kubectl get role pod-reader -o jsonpath='{.rules[0].resources[0]}' 2>/dev/null)"
check_exact "4.2" "pod-reader" "$(kubectl get rolebinding read-pods-binding -o jsonpath='{.roleRef.name}' 2>/dev/null)"
check_exact "4.3" "app-sa" "$(kubectl get pod secure-pod -o jsonpath='{.spec.serviceAccountName}' 2>/dev/null)"
check_not_empty "4.4" "$(ls /opt/backup/etcd-snapshot.db 2>/dev/null)"
check_contains "4.5" "true" "$(kubectl get nodes -o jsonpath='{.items[*].spec.unschedulable}' 2>/dev/null)"
check_exact "4.6" "" "$(kubectl get nodes -o jsonpath='{.items[?(@.spec.unschedulable==true)].metadata.name}' 2>/dev/null)"
check_exact "4.7" "deployments" "$(kubectl get clusterrole deployment-manager -o jsonpath='{.rules[0].resources[0]}' 2>/dev/null)"
check_exact "4.8" "Approved" "$(kubectl get csr dev-csr -o jsonpath='{.status.conditions[0].type}' 2>/dev/null)"
check_exact "4.9" "tjandikaputra/soal-cka" "$(kubectl get deploy -n prod-ns -o jsonpath='{.items[0].spec.template.spec.containers[0].image}' 2>/dev/null)"
check_not_empty "4.10" "$(helm ls -n web-ns -q 2>/dev/null | grep my-nginx)"

echo -e "\n${YELLOW}--- Domain 05: Troubleshooting ---${NC}"
check_exact "5.1" "tjandikaputra/soal-cka" "$(kubectl get pod broken-pod -o jsonpath='{.spec.containers[0].image}' 2>/dev/null)"
check_exact "5.2" "100m" "$(kubectl get deploy cpu-heavy -o jsonpath='{.spec.template.spec.containers[0].resources.requests.cpu}' 2>/dev/null)"
check_exact "5.3" "backend" "$(kubectl get svc app-service -o jsonpath='{.spec.selector.app}' 2>/dev/null)"
check_exact "5.4" "8082" "$(kubectl get pod api-server-pod -o jsonpath='{.spec.containers[0].livenessProbe.httpGet.port}' 2>/dev/null)"
check_not_empty "5.5" "$(cat /opt/highest_cpu_pod.txt 2>/dev/null)"
check_not_empty "5.6" "$(cat /opt/web-logger-error.log 2>/dev/null)"
check_not_empty "5.7" "$(kubectl get netpol allow-internal -o jsonpath='{.spec.ingress[0].from[0].podSelector.matchLabels}' 2>/dev/null)"
check_not_empty "5.8" "$(kubectl get endpoints kube-dns -n kube-system -o jsonpath='{.subsets[0].addresses[0].ip}' 2>/dev/null)"
check_not_empty "5.9" "$(cat /opt/cluster_events.txt 2>/dev/null)"
check_exact "5.10" "128Mi" "$(kubectl get deploy oom-deploy -o jsonpath='{.spec.template.spec.containers[0].resources.limits.memory}' 2>/dev/null)"

echo "========================================="
PERCENTAGE=$(( SCORE * 100 / TOTAL ))
if [ $PERCENTAGE -ge 66 ]; then
  echo -e "FINAL SCORE: ${GREEN}$SCORE / $TOTAL ($PERCENTAGE%)${NC}"
  echo -e "${GREEN}Congratulations! You passed the mock exam!${NC}"
else
  echo -e "FINAL SCORE: ${RED}$SCORE / $TOTAL ($PERCENTAGE%)${NC}"
  echo -e "${RED}You need 66% to pass. Keep practicing!${NC}"
fi
