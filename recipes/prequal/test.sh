#!/bin/bash
set -e

# Test that binaries are accessible
mrinfo --version
c3d -version
antsRegistration --version

# Test dtiQA script is present
if [ -f /CODE/run_dtiQA.sh ]; then
  echo "run_dtiQA.sh script found"
else
  echo "ERROR: run_dtiQA.sh script not found"
  exit 1
fi

# Verify critical directories exist
for dir in /APPS /CODE /INPUTS /OUTPUTS /SUPPLEMENTAL; do
  if [ -d "$dir" ]; then
    echo "$dir directory exists"
  else
    echo "ERROR: $dir directory not found"
    exit 1
  fi
done

echo "All tests passed!"
exit 0