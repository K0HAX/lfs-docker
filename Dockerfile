FROM debian:bookworm
RUN apt-get update && apt-get -y install \
    binutils \
    bison \
    gawk \
    build-essential \
    python3 \
    texinfo \
    sudo

RUN mkdir -pv /lfs/scripts
RUN mkdir -pv /lfs/tmp /lfs/sources
RUN chmod -v a+wt /lfs/sources
COPY src/* /lfs/sources/
COPY scripts/* /lfs/scripts/
RUN chmod a+x /lfs/scripts/*.sh
WORKDIR /lfs/tmp
RUN mv /bin/sh /bin/sh.bak && cp /usr/bin/bash /bin/sh
RUN mkdir /mnt/lfs

# Version Check passes!

CMD ["/lfs/scripts/build.sh"]
