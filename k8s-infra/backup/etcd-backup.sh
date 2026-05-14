#!/bin/bash
export ETCDCTL_API=3
DATE=$(date +%Y%m%d_%H%M)
BACKUP_DIR="/data/etcd-backup"
BACKUP_FILE="${BACKUP_DIR}/etcd-${DATE}.db"
LOG_FILE="/var/log/pods/etcd-backup.log"" # Promtail 긁어가기 쉬운 경로

# 백업 디렉토리 보장
mkdir -p ${BACKUP_DIR}

# 명령어 변수 (환경변수 분리)
ETCD_CERT_PATH="/etc/ssl/etcd/ssl"
ETCDCTL_CMD="etcdctl --endpoints=https://127.0.0.1:2379 --cacert=$
{ETCD_CERT_PATH}/ca.pem --cert=${ETCD_CERT_PATH}/admin-node1.pem --key=$
{ETCD_CERT_PATH}/admin-node1-key.pem"

# 백업 실행
nice -n 19 ${ETCDCTL_CMD} snapshot save ${BACKUP_FILE} > /dev/null 2>&1

# 결과 검증 및 알람 발송
# WEBHOOK_URL 변수는 스크립트 외부(Secret 또는 .env)에서 주입받습니다.
if [ $? -eq 0 ]; then
  echo "{\"time\":\"$(date -Iseconds)\", \"level\":\"info\", \"msg\":\"etcd backup success\"}" >> ${LOG_FILE}
  if [ -n "$WEBHOOK_URL" ]; then
    curl -s -X POST -H 'Content-type: application/json' --data '{"text":"✅ [node1] etcd 백업 성공"}' ${WEBHOOK_URL}
  fi
else
  echo "{\"time\":\"$(date -Iseconds)\", \"level\":\"error\", \"msg\":\"etcd backup failed!\"}" >> ${LOG_FILE}
  if [ -n "$WEBHOOK_URL" ]; then
    curl -s -X POST -H 'Content-type: application/json' --data '{"text":"🚨 [node1] etcd 백업 실패!"}' ${WEBHOOK_URL}
  fi
fi

# 14일 경과 파일 삭제
find ${BACKUP_DIR} -name "etcd-*.db" -type f -mtime +14 -delete
