FROM ubuntu:22.04

RUN echo "Updating Ubuntu"
RUN apt-get update && apt-get upgrade -y

RUN echo "Installing dependencies..."
RUN apt install -y \
            ccache \
            clang \
            clang-format \
            clang-tidy \
            cppcheck \
            curl \
            doxygen \
            gcc \
            git \
            graphviz \
            make \
            ninja-build \
            python3 \
            python3-pip \
            tar \
            unzip \
            vim \
            wget \
            build-essential \
            libssl-dev \
            cmake \
            catch2 \
            googletest

RUN pip3 install conan

# GoogleTest installation and configuration
RUN cd /usr/src/googletest && \
        cmake . && \
        make && \
        make install

# Install vcpkg
RUN git clone https://github.com/microsoft/vcpkg && \
        cd vcpkg && \
        ./bootstrap-vcpkg.sh --disableMetrics --useSystemBinaries