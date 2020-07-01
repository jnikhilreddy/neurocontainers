
FROM centos:7

USER root

ARG DEBIAN_FRONTEND="noninteractive"

ENV LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    ND_ENTRYPOINT="/neurodocker/startup.sh"
RUN export ND_ENTRYPOINT="/neurodocker/startup.sh" \
    && yum install -y -q \
           bzip2 \
           ca-certificates \
           curl \
           epel-release \
           localedef \
           unzip \
    && yum clean packages \
    && rm -rf /var/cache/yum/* \
    && localedef -i en_US -f UTF-8 en_US.UTF-8 \
    && chmod 777 /opt && chmod a+s /opt \
    && mkdir -p /neurodocker \
    && if [ ! -f "$ND_ENTRYPOINT" ]; then \
         echo '#!/usr/bin/env bash' >> "$ND_ENTRYPOINT" \
    &&   echo 'set -e' >> "$ND_ENTRYPOINT" \
    &&   echo 'export USER="${USER:=`whoami`}"' >> "$ND_ENTRYPOINT" \
    &&   echo 'if [ -n "$1" ]; then "$@"; else /usr/bin/env bash; fi' >> "$ND_ENTRYPOINT"; \
    fi \
    && chmod -R 777 /neurodocker && chmod a+s /neurodocker

ENTRYPOINT ["/neurodocker/startup.sh"]

RUN printf '#!/bin/bash\nls -la' > /usr/bin/ll

RUN chmod +x /usr/bin/ll

RUN mkdir /afm01 /90days /30days /QRISdata /RDS /data /short /proc_temp /TMPDIR /nvme /local /gpfs1 /working /winmounts /state /autofs /cluster /local_mount /scratch /clusterdata /nvmescratch

ENV PATH="/opt/afni-latest:$PATH" \
    AFNI_PLUGINPATH="/opt/afni-latest"
RUN yum install -y -q \
           R \
           R-devel \
           ed \
           gsl \
           libGLU \
           libXp \
           libXpm \
           libgomp \
           libpng12 \
           mesa-dri-drivers \
           netpbm-progs \
           openmotif \
           python3 \
           tcsh \
           xorg-x11-fonts-misc \
           xorg-x11-server-Xvfb \
    && yum clean packages \
    && rm -rf /var/cache/yum/*gsl2_path="$(find / -name 'libgsl.so.19' || printf '')" \
    && if [ -n "$gsl2_path" ]; then \
         ln -sfv "$gsl2_path" "$(dirname $gsl2_path)/libgsl.so.0"; \
    fi \
    && ldconfig \
    && echo "Downloading AFNI ..." \
    && mkdir -p /opt/afni-latest \
    && curl -fsSL --retry 5 https://afni.nimh.nih.gov/pub/dist/tgz/linux_openmp_64.tgz \
    | tar -xz -C /opt/afni-latest --strip-components 1 \
    && PATH=$PATH:/opt/afni-latest rPkgsInstall -pkgs ALL

ENV CONDA_DIR="/opt/miniconda-latest" \
    PATH="/opt/miniconda-latest/bin:$PATH"
RUN export PATH="/opt/miniconda-latest/bin:$PATH" \
    && echo "Downloading Miniconda installer ..." \
    && conda_installer="/tmp/miniconda.sh" \
    && curl -fsSL --retry 5 -o "$conda_installer" https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash "$conda_installer" -b -p /opt/miniconda-latest \
    && rm -f "$conda_installer" \
    && conda update -yq -nbase conda \
    && conda config --system --prepend channels conda-forge \
    && conda config --system --set auto_update_conda false \
    && conda config --system --set show_channel_urls true \
    && sync && conda clean -y --all && sync \
    && conda create -y -q --name neuro \
    && conda install -y -q --name neuro \
           "python=3.6" \
    && sync && conda clean -y --all && sync

ENV DEPLOY_PATH="/opt/afni-20.1.18/"

RUN test "$(getent passwd neuro)" || useradd --no-user-group --create-home --shell /bin/bash neuro
USER neuro

RUN echo '{ \
    \n  "pkg_manager": "yum", \
    \n  "instructions": [ \
    \n    [ \
    \n      "base", \
    \n      "centos:7" \
    \n    ], \
    \n    [ \
    \n      "run", \
    \n      "printf '"'"'#!/bin/bash\\\nls -la'"'"' > /usr/bin/ll" \
    \n    ], \
    \n    [ \
    \n      "run", \
    \n      "chmod +x /usr/bin/ll" \
    \n    ], \
    \n    [ \
    \n      "run", \
    \n      "mkdir /afm01 /90days /30days /QRISdata /RDS /data /short /proc_temp /TMPDIR /nvme /local /gpfs1 /working /winmounts /state /autofs /cluster /local_mount /scratch /clusterdata /nvmescratch" \
    \n    ], \
    \n    [ \
    \n      "afni", \
    \n      { \
    \n        "version": "latest", \
    \n        "method": "binaries", \
    \n        "install_r_pkgs": "true", \
    \n        "install_python3": "true" \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "miniconda", \
    \n      { \
    \n        "create_env": "neuro", \
    \n        "conda_install": [ \
    \n          "python=3.6" \
    \n        ] \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "env", \
    \n      { \
    \n        "DEPLOY_PATH": "/opt/afni-20.1.18/" \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "user", \
    \n      "neuro" \
    \n    ] \
    \n  ] \
    \n}' > /neurodocker/neurodocker_specs.json
