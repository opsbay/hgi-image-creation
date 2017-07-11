if [[ -z "${S3_ACCESS_KEY+x}" ]]; then
    >&2 echo "S3_ACCESS_KEY must be set!"
    exit 1
fi
if [[ -z "${S3_SECRET_KEY+x}" ]]; then
    >&2 echo "S3_SECRET_KEY must be set!"
    exit 1
fi
if [[ -z "${S3_HOST+x}" ]]; then
    >&2 echo "S3_HOST must be set!"
    exit 1
fi

MC_BIN="$(which mc || true)"

if [[ -z "${MC_BIN}" ]]; then
    >&2 echo "skipping mc config since mc is not in PATH"
else
    mc config host add deploy "https://${S3_HOST}" "${S3_ACCESS_KEY}" "${S3_SECRET_KEY}"
fi
