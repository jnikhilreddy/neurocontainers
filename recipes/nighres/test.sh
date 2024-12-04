python -c 'import nighres'

# cd /opt/nighres

# make smoke_tests

# test if glibc is newer than 2.35
# has to be newer than 2.35 due to https://security.snyk.io/vuln/SNYK-UBUNTU2204-GLIBC-6674187

# Function to compare version numbers
version_gt() {
    test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1"
}

# Get the current glibc version
GLIBC_VERSION=$(ldd --version | awk '/ldd/ {print $NF}')

# Minimum required version
MIN_VERSION="2.35"

# Check if the current version is less than the minimum required version
if ! version_gt "$GLIBC_VERSION" "$MIN_VERSION"; then
    echo "Error: glibc version $GLIBC_VERSION is older than the required version $MIN_VERSION" >&2
    exit 1
fi

echo "glibc version $GLIBC_VERSION is acceptable (>= $MIN_VERSION)"
exit 0