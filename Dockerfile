# ECE 466/566 container for easy use on Windows, Linux, MacOS

FROM ubuntu:20.10

LABEL maintainer="jtuck@ncsu.edu"

RUN apt-get update \
  && apt-get clean \
  && apt-get install -y ssh \
      build-essential \
      gcc \
      g++ \
      gdb \
      cmake \
      rsync \
      tar \
      python \
      pip \
      zlib1g-dev \
      bison \
      libbison-dev \
      flex \
   && apt-get clean

RUN  apt-get clean \
  && apt-get install -y clang-11 clang-tools-11 clang-11-doc libclang-common-11-dev \
  libclang-11-dev libclang1-11 clang-format-11 python3-clang-11 clangd-11  libc++-11-dev \
  libfuzzer-11-dev lldb-11 lld-11 libc++abi-11-dev \
   && apt-get clean

RUN apt-get install -y time \
    && apt-get clean

RUN pip install lit

ADD . /ece566
ADD . /build
WORKDIR /ece566

RUN ( \
    echo 'LogLevel DEBUG2'; \
    echo 'PermitRootLogin yes'; \
    echo 'PasswordAuthentication yes'; \
    echo 'Subsystem sftp /usr/lib/openssh/sftp-server'; \
  ) > /etc/ssh/sshd_config_test_clion \
  && mkdir /run/sshd

RUN useradd -m user \
  && yes password | passwd user

CMD ["/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config_test_clion"]