FROM base_image AS base

ARG PORT
ARG DOWNLOAD_TARGET
ARG NZYME_DEB_SHA256
ARG NZYME_USER_ID
ARG DEPENDENCIES

ARG NZYME_DEB_FILE=/tmp/nzyme_node_install.deb
ENV DEBIAN_FRONTEND=noninteractive 

RUN useradd -u ${NZYME_USER_ID} -m nzyme
RUN apt update && \ 
    apt install -y \ 
        curl \ 
        ${DEPENDENCIES}

RUN curl -fSL --retry 3 "${DOWNLOAD_TARGET}" -o "${NZYME_DEB_FILE}" && \
    echo "${NZYME_DEB_SHA256}  ${NZYME_DEB_FILE}" | sha256sum --check - && \
    dpkg -i ${NZYME_DEB_FILE} && \
    rm ${NZYME_DEB_FILE} && \
    apt purge -y curl && \
    apt clean && \
    # TODO: See if we still need this
    chmod u=rw /etc/default/nzyme 

WORKDIR /etc/nzyme
RUN find / -name '*nzyme*' -exec chown -R nzyme:nzyme {} +

COPY --chown=nzyme:nzyme common_nzyme_details.sh /etc/nzyme/
RUN chmod +x /etc/nzyme/common_nzyme_details.sh

USER nzyme
EXPOSE ${PORT}

FROM base AS nzyme-node

COPY --chown=nzyme:nzyme run_nzyme_node.sh /etc/nzyme
RUN chmod +x /etc/nzyme/run_nzyme_node.sh
CMD ["bash", "/etc/nzyme/run_nzyme_node.sh"]

FROM base AS nzyme-node-migration

COPY --chown=nzyme:nzyme run_nzyme_node_migration.sh /etc/nzyme
RUN chmod +x /etc/nzyme/run_nzyme_node_migration.sh
CMD ["bash", "/etc/nzyme/run_nzyme_node_migration.sh"]
