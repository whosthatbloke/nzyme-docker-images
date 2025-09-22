FROM base_image

ARG DOWNLOAD_TARGET
ARG DEPENDENCIES
ARG NZYME_DEB_FILE=/tmp/nzyme_tap_install.deb

# Do this otherwise 'apt install' hangs
ENV DEBIAN_FRONTEND=noninteractive 

# Create nzyme user and later change all relvant files to be owned by nzyme 
RUN useradd -m nzyme
WORKDIR /tmp
RUN apt update && \ 
    apt install -y \
        curl libcap2-bin \ 
        ${DEPENDENCIES}

RUN curl -L ${DOWNLOAD_TARGET} > ${NZYME_DEB_FILE} && \ 
    dpkg -i ${NZYME_DEB_FILE} && \
    rm ${NZYME_DEB_FILE} && \
    apt purge -y curl && \ 
    apt clean

WORKDIR /etc/nzyme
COPY start.sh /etc/nzyme/
RUN chmod +x start.sh && \
    find / -name '*nzyme*' -exec chown -R nzyme:nzyme {} + && \
    setcap cap_net_raw,cap_net_admin=eip /usr/bin/nzyme-tap 
 
USER nzyme
CMD ["sh", "/etc/nzyme/start.sh"]
