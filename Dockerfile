FROM alpine:3 AS build

ARG VERSION="2.89"
ARG CHECKSUM="8651373d000cae23776256e83dcaa6723dee72c06a39362700344e0c12c4e7e4"

ADD https://www.thekelleys.org.uk/dnsmasq/dnsmasq-$VERSION.tar.gz /tmp/dnsmasq.tar.gz

RUN [ "$(sha256sum /tmp/dnsmasq.tar.gz | awk '{print $1}')" = "$CHECKSUM" ] && \
    apk add gcc linux-headers make musl-dev && \
    tar -C /tmp -xf /tmp/dnsmasq.tar.gz && \
    cd /tmp/dnsmasq-$VERSION && \
      make LDFLAGS="-static"

RUN mkdir -p /rootfs/bin && \
      cp /tmp/dnsmasq-$VERSION/src/dnsmasq /rootfs/bin/ && \
      chmod -R 0755 /rootfs/bin  && \
    mkdir -p /rootfs/etc && \
      echo "nogroup:*:10000:nobody" > /rootfs/etc/group && \
      echo "nobody:*:10000:10000:::" > /rootfs/etc/passwd
COPY dnsmasq.conf /rootfs/etc/
RUN chmod 0644 /rootfs/etc/dnsmasq.conf

ARG BRANCH=master
ARG COMMIT=9e99a55b317f5da66f5110891b154084b337a031

RUN apk add gcc linux-headers make musl-dev perl git xz-dev && \
    cd /tmp && \
    git clone --single-branch --branch ${BRANCH} https://github.com/ipxe/ipxe.git ipxe && \
    cd ipxe && git reset --hard ${COMMIT}
COPY chain.ipxe /tmp/ipxe/src/
COPY ipxe_general.h /tmp/ipxe/src/config/local/general.h
RUN cd /tmp/ipxe/src && \
    make bin-x86_64-efi/ipxe.efi bin-i386-efi/ipxe.efi bin/undionly.kpxe EMBED=chain.ipxe && \
    mkdir -p /rootfs/tftpboot && \
    cp bin-x86_64-efi/ipxe.efi bin/undionly.kpxe /rootfs/tftpboot/ && \
    cp bin-i386-efi/ipxe.efi /rootfs/tftpboot/ipxe32.efi && \
    chmod -R 0755 /rootfs/tftpboot

FROM scratch

LABEL org.opencontainers.image.source=https://github.com/nvalembois/pxeserver
LABEL org.opencontainers.image.description="PXE Server by DNSMasq"

COPY --from=build /rootfs /

USER 10000:10000
ENTRYPOINT ["/bin/dnsmasq"]
CMD ["--keep-in-foreground"]
