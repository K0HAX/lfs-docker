# syntax=docker/dockerfile:1.7-labs
FROM debian:bookworm AS stage1
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
COPY --parents scripts/stage1/./* /lfs/scripts/
RUN chmod a+x /lfs/scripts/*.sh
WORKDIR /lfs/tmp
RUN mv /bin/sh /bin/sh.bak && cp /usr/bin/bash /bin/sh
RUN mkdir /mnt/lfs && chmod a+wt /lfs/sources
COPY ./src/* /lfs/sources/
RUN chown root:root /lfs/sources/* && chown root:root /lfs/sources/*

ENV LFS="/mnt/lfs"

RUN /lfs/scripts/build.sh

USER lfs
ENV LC_ALL="POSIX"
ENV LFS_TGT="x86_64-lfs-linux-gnu"
ENV PATH="/mnt/lfs/tools/bin:/usr/bin"
ENV CONFIG_SITE="/mnt/lfs/usr/share/config.site"
ENV MAKEFLAGS="-j4"

WORKDIR /mnt/lfs/sources
RUN /lfs/scripts/build-sudo.sh
RUN /lfs/scripts/packages/binutils-pass1.sh
RUN /lfs/scripts/packages/gcc-pass1.sh
RUN /lfs/scripts/packages/linux.sh
RUN /lfs/scripts/packages/glibc-pass1.sh
RUN /lfs/scripts/packages/libstdcpp-stage1.sh
RUN /lfs/scripts/packages/m4.sh
RUN /lfs/scripts/packages/ncurses.sh
RUN /lfs/scripts/packages/bash.sh
RUN /lfs/scripts/packages/coreutils.sh
RUN /lfs/scripts/packages/diffutils.sh
RUN /lfs/scripts/packages/file.sh
RUN /lfs/scripts/packages/findutils.sh
RUN /lfs/scripts/packages/gawk.sh
RUN /lfs/scripts/packages/grep.sh
RUN /lfs/scripts/packages/gzip.sh
RUN /lfs/scripts/packages/make.sh
RUN /lfs/scripts/packages/patch.sh
RUN /lfs/scripts/packages/sed.sh
RUN /lfs/scripts/packages/tar.sh
RUN /lfs/scripts/packages/xz.sh
RUN /lfs/scripts/packages/binutils-pass2.sh
RUN /lfs/scripts/packages/gcc-pass2.sh

USER root

RUN chown --from lfs -R root:root $LFS/{usr,lib,var,etc,bin,sbin,tools} && \
    chown --from lfs -R root:root $LFS/lib64 && \
    mkdir -pv $LFS/{dev,proc,sys,run}

FROM scratch AS stage2
COPY --from=stage1 --parents /mnt/lfs/./* /
RUN rm -rf /sources/*
COPY --from=stage1 --parents /lfs/sources/./* /sources/
RUN mkdir -pv /lfs/scripts
COPY --parents ./scripts/stage2/./* /lfs/scripts
ENV HOME="/root"
ENV PS1="(lfs chroot) \u:\w\$ "
ENV PATH="/usr/bin:/usr/sbin"
ENV MAKEFLAGS="-j4"
ENV TESTSUITEFLAGS="-j4"
#ENV LC_ALL="POSIX"

RUN mkdir -pv /{boot,home,mnt,opt,srv} && \
    mkdir -pv /etc/{opt,sysconfig} && \
    mkdir -pv /lib/firmware && \
    mkdir -pv /media/{floppy,cdrom} && \
    mkdir -pv /usr/{,local/}{include,src} && \
    mkdir -pv /usr/lib/locale && \
    mkdir -pv /usr/local/{bin,lib,sbin} && \
    mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man} && \
    mkdir -pv /usr/{,local/}share/{misc,terminfo,zoneinfo} && \
    mkdir -pv /usr/{,local/}share/man/man{1..8} && \
    mkdir -pv /var/{cache,local,log,mail,opt,spool} && \
    mkdir -pv /var/lib/{color,misc,locate} && \
    ln -sfv /run /var/run && \
    ln -sfv /run/lock /var/lock && \
    install -dv -m 0750 /root && \
    install -dv -m 1777 /tmp /var/tmp && \
    ln -sv /proc/self/mounts /etc/mtab

COPY ./passwd /etc/passwd
COPY ./group /etc/group

RUN localedef -i C -f UTF-8 C.UTF-8
RUN echo "tester:x:101:101::/home/tester:/bin/bash" >> /etc/passwd && \
    echo "tester:x:101:" >> /etc/group && \
    install -o tester -d /home/tester

RUN touch /var/log/{btmp,lastlog,faillog,wtmp} && \
    chgrp -v utmp /var/log/lastlog && \
    chmod -v 664  /var/log/lastlog && \
    chmod -v 600  /var/log/btmp

RUN /lfs/scripts/packages/gettext.sh
RUN /lfs/scripts/packages/bison.sh
RUN /lfs/scripts/packages/perl.sh
RUN /lfs/scripts/packages/python.sh
RUN /lfs/scripts/packages/texinfo.sh
RUN /lfs/scripts/packages/util-linux.sh

# Absolute minimum system finished. Clean up!
RUN /lfs/scripts/clean-stage3.sh && rm -rf /lfs/scripts/*

# Begin full install
#COPY --parents ./scripts/stage3/./* /lfs/scripts

RUN mkdir -pv /lfs/scripts/packages
COPY ./scripts/stage3/packages/man-pages.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/man-pages.sh

COPY ./scripts/stage3/packages/iana-etc.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/iana-etc.sh

COPY ./scripts/stage3/packages/glibc.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/glibc.sh

COPY ./scripts/stage3/packages/zlib.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/zlib.sh

COPY ./scripts/stage3/packages/bzip2.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/bzip2.sh

COPY ./scripts/stage3/packages/xz.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/xz.sh

COPY ./scripts/stage3/packages/lz4.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/lz4.sh

COPY ./scripts/stage3/packages/zstd.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/zstd.sh

COPY ./scripts/stage3/packages/file.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/file.sh

COPY ./scripts/stage3/packages/readline.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/readline.sh

COPY ./scripts/stage3/packages/m4.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/m4.sh

COPY ./scripts/stage3/packages/bc.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/bc.sh

COPY ./scripts/stage3/packages/flex.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/flex.sh

COPY ./scripts/stage3/packages/tcl.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/tcl.sh

COPY ./scripts/stage3/packages/expect.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/expect.sh

COPY ./scripts/stage3/packages/dejagnu.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/dejagnu.sh

COPY ./scripts/stage3/packages/pkgconf.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/pkgconf.sh

COPY ./scripts/stage3/packages/binutils.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/binutils.sh

COPY ./scripts/stage3/packages/gmp.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/gmp.sh

COPY ./scripts/stage3/packages/mpfr.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/mpfr.sh

COPY ./scripts/stage3/packages/mpc.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/mpc.sh

COPY ./scripts/stage3/packages/attr.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/attr.sh

COPY ./scripts/stage3/packages/acl.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/acl.sh

COPY ./scripts/stage3/packages/libcap.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/libcap.sh

COPY ./scripts/stage3/packages/libxcrypt.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/libxcrypt.sh

COPY ./scripts/stage3/packages/shadow.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/shadow.sh

COPY ./scripts/stage3/packages/gcc.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/gcc.sh

COPY ./scripts/stage3/packages/ncurses.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/ncurses.sh

COPY ./scripts/stage3/packages/sed.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/sed.sh

COPY ./scripts/stage3/packages/psmisc.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/psmisc.sh

COPY ./scripts/stage3/packages/gettext.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/gettext.sh

COPY ./scripts/stage3/packages/bison.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/bison.sh

COPY ./scripts/stage3/packages/grep.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/grep.sh

COPY ./scripts/stage3/packages/bash.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/bash.sh

COPY ./scripts/stage3/packages/libtool.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/libtool.sh

COPY ./scripts/stage3/packages/gdbm.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/gdbm.sh

COPY ./scripts/stage3/packages/gperf.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/gperf.sh

COPY ./scripts/stage3/packages/expat.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/expat.sh

COPY ./scripts/stage3/packages/inetutils.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/inetutils.sh

COPY ./scripts/stage3/packages/less.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/less.sh

COPY ./scripts/stage3/packages/perl.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/perl.sh

COPY ./scripts/stage3/packages/xml_parser.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/xml_parser.sh

COPY ./scripts/stage3/packages/intltool.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/intltool.sh

COPY ./scripts/stage3/packages/autoconf.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/autoconf.sh

COPY ./scripts/stage3/packages/automake.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/automake.sh

COPY ./scripts/stage3/packages/openssl.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/openssl.sh

COPY ./scripts/stage3/packages/kmod.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/kmod.sh

COPY ./scripts/stage3/packages/libelf.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/libelf.sh

COPY ./scripts/stage3/packages/libffi.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/libffi.sh

COPY ./scripts/stage3/packages/python.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/python.sh

COPY ./scripts/stage3/packages/flit-core.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/flit-core.sh

COPY ./scripts/stage3/packages/wheel.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/wheel.sh

COPY ./scripts/stage3/packages/setuptools.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/setuptools.sh

COPY ./scripts/stage3/packages/ninja.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/ninja.sh

COPY ./scripts/stage3/packages/meson.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/meson.sh

COPY ./scripts/stage3/packages/coreutils.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/coreutils.sh

COPY ./scripts/stage3/packages/check.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/check.sh

COPY ./scripts/stage3/packages/diffutils.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/diffutils.sh

COPY ./scripts/stage3/packages/gawk.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/gawk.sh

COPY ./scripts/stage3/packages/findutils.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/findutils.sh

COPY ./scripts/stage3/packages/groff.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/groff.sh

COPY ./scripts/stage3/packages/gzip.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/gzip.sh

COPY ./scripts/stage3/packages/iproute2.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/iproute2.sh

COPY ./scripts/stage3/packages/kbd.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/kbd.sh

COPY ./scripts/stage3/packages/libpipeline.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/libpipeline.sh

COPY ./scripts/stage3/packages/make.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/make.sh

COPY ./scripts/stage3/packages/patch.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/patch.sh

COPY ./scripts/stage3/packages/tar.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/tar.sh

COPY ./scripts/stage3/packages/texinfo.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/texinfo.sh

COPY ./scripts/stage3/packages/vim.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/vim.sh

COPY ./scripts/stage3/packages/markupsafe.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/markupsafe.sh

COPY ./scripts/stage3/packages/jinja2.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/jinja2.sh

COPY ./scripts/stage3/packages/mandb.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/mandb.sh

COPY ./scripts/stage3/packages/procps-ng.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/procps-ng.sh

COPY ./scripts/stage3/packages/util-linux.sh /lfs/scripts/packages/
RUN /lfs/scripts/packages/util-linux.sh

RUN mandb

RUN rm -rf /tmp/{*,.*} && \
    find /usr/lib /usr/libexec -name \*.la -delete && \
    find /usr -depth -name $(uname -m)-lfs-linux-gnu\* | xargs rm -rf && \
    userdel -r tester

RUN mkdir -pv /run/lock
RUN rm -vrf /lfs /sources /built.txt /etc/mtab /tmp/*

FROM scratch AS stage3
ENV HOME="/root"
ENV PS1='[\u@\h \W]\$ '
ENV PATH="/usr/bin:/usr/sbin"
COPY --from=stage2 --parents /./* /
WORKDIR /root

CMD ["/bin/bash", "--login"]
