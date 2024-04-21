FROM ubuntu:22.04
RUN apt-get update \
    && apt-get -y install autoconf automake autotools-dev curl python3 python3-pip libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev ninja-build git cmake libglib2.0-dev \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/riscv/riscv-gnu-toolchain \
    && cd riscv-gnu-toolchain && ./configure --prefix=/opt/riscv --enable-multilib \
    && make -j$(nproc) \
    && make install \
    && cd ../ && rm -rf riscv-gnu-toolchain

ENV PATH=$PATH:/opt/riscv/bin