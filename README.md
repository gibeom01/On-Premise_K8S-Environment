## 실제 IDC의 물리적 서버에 Kubernetes 환경 구축 방법

### * 참조 *
#### k8s-at-home.com (온프레미스 K8s 가이드) vmware.com rke2.io (RKE2 공식 문서) cert-manager.io

### * 참고사항 *
#### 고객사 서버가 폐쇄망(인터넷 불가)인가요? → 반드시 고객사 서버 내부에 운영+관리 모두 구성
#### 인터넷이 가능하고 관리가 우선인가요? → 운영은 고객사 서버에, 관리는 본사 Rancher에서 원격으로 연결

### * 구축 도구 *
#### 클러스터 기반 및 고가용성 (Foundation & HA) 도구: HAProxy, Keepalived, Kubespray, HAProxy Ingress 도메인, MetalLB, SSL_Cert-manager 활용한 HTTPS
#### 클러스터 가시성 및 모니터링 (Observability) 도구: kube-prometheus-stack, Loki + Promtail 구성 (PLG Stack), ipmi-exporter (물리 서버 모니터링), Grafana Tempo
#### 백업 및 재해 복구 (Backup & Disaster Recovery) 도구: ETCD Backup, MinIO, Velero
#### 분산 스토리지 및 프라이빗 레지스트리 도구: Longhorn -> Prometheus 연결, Harbor
#### 지속적 배포 및 자동화 (GitOps) 도구: ArgoCD
