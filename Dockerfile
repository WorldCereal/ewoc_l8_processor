# =========================================================================
#
#   Copyright 2021 (c) CS Group France. All rights reserved.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
# =========================================================================
#
# Authors: Mickaël SAVINAUD (CS Group France)
#
# =========================================================================
FROM ubuntu:20.04
LABEL maintainer="CS GROUP France"
LABEL description="This docker allow to run ewoc_l8 processing chain."

WORKDIR /tmp

ENV LANG=en_US.utf8

RUN apt-get update -y \
&& DEBIAN_FRONTEND=noninteractive apt-get install -y --fix-missing --no-install-recommends \
    python3 \
    python3-dev \
    python3-pip \
    virtualenv \
    apt-utils \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --no-cache-dir --upgrade pip \
      && python3 -m pip install --no-cache-dir virtualenv

#------------------------------------------------------------------------
## Install python packages
ARG EWOC_L8_VERSION=0.8.2
LABEL EWOC_L8="${EWOC_L8_VERSION}"
ARG EWOC_DAG_VERSION=0.9.0
LABEL EWOC_DAG="${EWOC_DAG_VERSION}"

# Copy private python packages
COPY ewoc_dag-${EWOC_DAG_VERSION}.tar.gz /tmp

SHELL ["/bin/bash", "-c"]

ENV EWOC_L8_VENV=/opt/ewoc_l8_venv
RUN python3 -m virtualenv ${EWOC_L8_VENV} \
      && source ${EWOC_L8_VENV}/bin/activate \
      && pip install --no-cache-dir /tmp/ewoc_l8-${EWOC_L8_VERSION}.tar.gz --find-links /tmp \
      && pip install --no-cache-dir psycopg2-binary \
      && pip install --no-cache-dir rfc5424-logging-handler

ARG EWOC_L8_DOCKER_VERSION='dev'
ENV EWOC_L8_DOCKER_VERSION=${EWOC_L8_DOCKER_VERSION}
LABEL version=${EWOC_L8_DOCKER_VERSION}

ADD entrypoint.sh /opt
RUN chmod +x /opt/entrypoint.sh
ENTRYPOINT [ "/opt/entrypoint.sh" ]
#CMD [ "-h" ]
