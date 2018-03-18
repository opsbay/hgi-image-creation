SCRIPT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${SCRIPT_DIRECTORY}/../common.sh"

ensureSet S3_ACCESS_KEY S3_SECRET_KEY S3_HOST

export MINIO_ENDPOINT="${S3_HOST}"
export MINIO_ACCESS_KEY_ID="${S3_ACCESS_KEY}"
export MINIO_SECRET_ACCESS_KEY="${S3_SECRET_KEY}"

MC_BIN="$(which mc || true)"

if [[ -z "${MC_BIN}" ]]; then
    >&2 echo "skipping mc config since mc is not in PATH"
else
    mc config host add deploy "https://${MINIO_ENDPOINT}" "${MINIO_ACCESS_KEY_ID}" "${MINIO_SECRET_ACCESS_KEY}"
fi
