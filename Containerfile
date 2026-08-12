FROM ghcr.io/containerpak/gtk:main

ADD --checksum=sha256:cbad7bf4be2607e1725db156d73c799d267a79fc29a572c3136a5deb9c9be948 https://github.com/darktable-org/darktable/releases/download/release-5.6.0/Darktable-5.6.0-x86_64.AppImage /tmp/source
COPY icon.png /usr/share/icons/hicolor/128x128/apps/darktable.png

RUN apt-get update && \
    apt-get install -y --no-install-recommends fuse3 libgl1 && \
    mkdir -p /opt/darktable && install -m 0755 /tmp/source /opt/darktable/darktable.AppImage && printf '#!/bin/sh\nexec /opt/darktable/darktable.AppImage --appimage-extract-and-run "$@"\n' > /usr/bin/darktable && chmod 0755 /usr/bin/darktable && printf '[Desktop Entry]\nName=darktable\nExec=darktable %F\nIcon=darktable\nType=Application\nCategories=Graphics;Photography;\n' > /usr/share/applications/org.darktable.Darktable.desktop && \
    cpak-clean-junk
