FROM base_image

ARG PORT
ARG DOWNLOAD_TARGET
ARG NZYME_USER_ID
ARG DEPENDENCIES

ARG NZYME_DEB_FILE=/tmp/nzyme_node_install.deb
ENV DEBIAN_FRONTEND=noninteractive 

RUN useradd -u ${NZYME_USER_ID} -m nzyme
RUN apt update && \ 
    apt install -y \ 
        curl \ 
        ${DEPENDENCIES}

RUN curl -L ${DOWNLOAD_TARGET} > ${NZYME_DEB_FILE} && \
    dpkg -i ${NZYME_DEB_FILE} && \
    rm ${NZYME_DEB_FILE} && \
    apt purge -y curl && \
    apt clean && \
    # TODO: See if we still need this
    chmod u=rw /etc/default/nzyme 

WORKDIR /etc/nzyme  
COPY start.sh /etc/nzyme/
RUN chmod +x start.sh && \
    find / -name '*nzyme*' -exec chown -R nzyme:nzyme {} +

USER nzyme
EXPOSE ${PORT}

CMD ["sh", "/etc/nzyme/start.sh"]
