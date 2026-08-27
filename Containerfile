FROM ubuntu:26.04 AS source

ADD --checksum=sha256:867ba61fca41d614e6650fd92d6e7968d8c56a1d1dd2bbc3aa06b52508694ed6 https://github.com/darktable-org/darktable/releases/download/release-5.6.1/Darktable-5.6.1-x86_64.AppImage /tmp/source

RUN chmod 0755 /tmp/source && \
    cd /tmp && \
    ./source --appimage-extract >/dev/null && \
    mv /tmp/squashfs-root /out

FROM ghcr.io/containerpak/gtk3:main

COPY --from=source /out /opt/darktable
COPY icon.png /usr/share/icons/hicolor/128x128/apps/darktable.png

RUN mkdir -p /usr/share/applications && \
    printf '#!/bin/sh\nexec /opt/darktable/AppRun "$@"\n' > /usr/bin/darktable && \
    chmod 0755 /usr/bin/darktable && \
    printf '[Desktop Entry]\nName=darktable\nExec=darktable %F\nIcon=darktable\nType=Application\nCategories=Graphics;Photography;\n' > /usr/share/applications/org.darktable.Darktable.desktop && \
    cpak-clean-junk
