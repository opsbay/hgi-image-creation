WHICH_BIN=$("which which || true)"
if [[ -z "${WHICH_BIN}" ]]; then
    echo "which required but not found in path"
    exit 1
fi
if [[ ! -x "${WHICH_BIN}" ]]; then
    echo "which is on path (${WHICH_BIN}) but cannot be executed"
    exit 1
fi

BASH_BIN=$("which bash || true)"
if [[ -z "${BASH_BIN}" ]]; then
    echo "bash required but not found in path"
    exit 1
fi
if [[ ! -x "${BASH_BIN}" ]]; then
    echo "bash is on path (${BASH_BIN}) but cannot be executed"
    exit 1
fi

GIT_BIN="$(which git || true)"

if [[ -z "${GIT_BIN}" ]]; then
    echo "git required but not found in path"
    exit 1
fi
if [[ ! -x "${GIT_BIN}" ]]; then
    echo "git is on path (${GIT_BIN}) but cannot be executed"
    exit 1
fi
