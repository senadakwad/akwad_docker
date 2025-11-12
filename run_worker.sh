#!/usr/bin/env bash
# --------------------------------------------------------
# Strict Frappe Worker Runner (no defaults)
# --------------------------------------------------------
# Usage:
#   ./run_worker.sh <SITE_NAME> <QUEUE_NAME> <BENCH_NAME>
# Example:
#   ./run_worker.sh test.localhost2 long sullam-bench
# --------------------------------------------------------

set -euo pipefail

SITE_NAME="${1:-}"
QUEUE_NAME="${2:-}"
BENCH_NAME="${3:-}"

if [[ -z "$SITE_NAME" || -z "$QUEUE_NAME" || -z "$BENCH_NAME" ]]; then
  echo "Usage: $0 <SITE_NAME> <QUEUE_NAME> <BENCH_NAME>"
  echo "Error: All three arguments are required."
  exit 1
fi

BASE_DIR="/home/akwad/benches/${BENCH_NAME}"
SITES_DIR="${BASE_DIR}/sites"
LOG_DIR="${BASE_DIR}/logs"
PYTHON_BIN="${BASE_DIR}/env/bin/python"

mkdir -p "${LOG_DIR}"

LOG_OUT="${LOG_DIR}/worker-${QUEUE_NAME}.log"
LOG_ERR="${LOG_DIR}/worker-${QUEUE_NAME}-error.log"

if [[ ! -x "$PYTHON_BIN" ]]; then
  echo "❌ Python environment not found at: ${PYTHON_BIN}" | tee -a "${LOG_ERR}"
  exit 1
fi

if [[ ! -d "${SITES_DIR}/${SITE_NAME}" ]]; then
  echo "❌ Site directory not found: ${SITES_DIR}/${SITE_NAME}" | tee -a "${LOG_ERR}"
  exit 1
fi

echo "--------------------------------------------------------" | tee -a "${LOG_OUT}"
echo " Starting Frappe Worker" | tee -a "${LOG_OUT}"
echo " Site : ${SITE_NAME}" | tee -a "${LOG_OUT}"
echo " Queue: ${QUEUE_NAME}" | tee -a "${LOG_OUT}"
echo " Bench: ${BENCH_NAME}" | tee -a "${LOG_OUT}"
echo " Logs : ${LOG_OUT}" | tee -a "${LOG_OUT}"
echo "--------------------------------------------------------" | tee -a "${LOG_OUT}"

cd "${SITES_DIR}"
export LD_LIBRARY_PATH=/usr/lib64

# All stdout to LOG_OUT, stderr to LOG_ERR
{
cat <<PY | "${PYTHON_BIN}" -
import signal, sys, frappe
from frappe.utils.background_jobs import start_worker
SITE = "${SITE_NAME}"
def _term(*_): sys.exit(0)
signal.signal(signal.SIGTERM, _term)
signal.signal(signal.SIGINT, _term)
with frappe.init_site(SITE):
    start_worker(queue="${QUEUE_NAME}", quiet=False)
PY
} >>"${LOG_OUT}" 2>>"${LOG_ERR}"
