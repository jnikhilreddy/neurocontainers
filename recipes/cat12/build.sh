#!/usr/bin/env bash
set -e

# this template file builds cat12, new versions here: http://141.35.69.218/cat12/?C=M;O=D
export toolName='cat12'
export toolVersion='12.9'
# https://github.com/ChristianGaser/cat12/releases
# with 12.9 we use the new versioning scheme instead of the old (r****)
# Don't forget to update version change in README.md!!!!!

# inspired by: https://github.com/m-wierzba/cat-container/blob/master/Singularity
# discussed here: https://github.com/ReproNim/neurodocker/issues/407

if [ "$1" != "" ]; then
    echo "Entering Debug mode"
    export debug=$1
fi

source ../main_setup.sh

export MATLAB_VERSION=2023b
export CAT_REVISION=$toolVersion

neurodocker generate ${neurodocker_buildMode} \
   --base-image ubuntu:16.04 \
   --pkg-manager apt \
   --run="printf '#!/bin/bash\nls -la' > /usr/bin/ll" \
   --run="chmod +x /usr/bin/ll" \
   --run="mkdir -p ${mountPointList}" \
   --matlabmcr version=${MATLAB_VERSION} install_path=/opt/mcr  \
   --miniconda \
         version=latest \
         conda_install='python=3.9 traits nipype numpy scipy h5py scikit-image' \
         pip_install='osfclient' \
   --cat12 version=${toolVersion}_R${MATLAB_VERSION} install_path=/opt/cat12 \
   --env DEPLOY_BINS=run_spm12.sh:spm12 \
   --copy README.md /README.md \
  > ${toolName}_${toolVersion}.${neurodocker_buildExt}


if [ "$1" != "" ]; then
   ./../main_build.sh
fi


# TESTS:
