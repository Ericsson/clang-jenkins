FROM jenkins/jenkins:lts
# if we want to install via apt
USER root
# add clang5 to apt repo
#RUN echo "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-5.0 main" > /etc/apt/sources.list.d/llvm.list
#RUN wget -O - http://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
# install clang build essentials
RUN apt-get update && apt-get install -y git build-essential vim python cloc gcovr python-virtualenv python-pip python-dev autotools-dev automake ninja-build libboost-all-dev perl autoconf m4 libtool pkg-config libev-dev libevent-dev libssl-dev bsdmainutils python3 libncurses5-dev doxygen subversion python2.7-dev libedit-dev zlib1g-dev libpcre3-dev clang-4.0 net-tools curl gcc-multilib thrift-compiler bison

# cmake
RUN wget https://cmake.org/files/v3.18/cmake-3.18.0-Linux-x86_64.sh
RUN mkdir /opt/cmake
RUN sh cmake-3.18.0-Linux-x86_64.sh --skip-license --prefix=/opt/cmake
RUN ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake

# SWIG for LLDB
# download swig 
RUN wget -O swig.tar.gz https://downloads.sourceforge.net/project/swig/swig/swig-3.0.8/swig-3.0.8.tar.gz
# extract and configure
RUN tar xf swig.tar.gz
RUN cd swig-3.0.8 && ./configure --prefix=/usr && make -j16 && make install
# check version reported
RUN ln -s /usr/bin/swig /usr/bin/swig3.0
RUN swig -version
RUN /usr/bin/swig3.0 -swiglib

#install default jenkins plugins
RUN /usr/local/bin/install-plugins.sh git github
# drop back to the regular jenkins user - good practice
ARG UID
ARG GID
RUN sed -i "s/jenkins:x:[0-9]\+:[0-9]\+/jenkins:x:$UID:$GID/g" /etc/passwd

# CodeChecker requires Python >= 3.6
RUN curl -s https://www.python.org/ftp/python/3.6.8/Python-3.6.8.tgz  | tar xvz && \
  cd Python-3.6.8 && \
  ./configure --prefix=/usr/local --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib" && \
  make install -j8 && \
  cd .. && \
  rm -r Python-3.6.8

USER jenkins
