FROM debian:testing-slim

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

RUN apt-get -yqq update \
&& DEBIAN_FRONTEND=noninteractive apt-get -yqq install \
     tzdata \
     locales \
&& echo "Europe/Barcelona" > /etc/timezone \
&& dpkg-reconfigure -f noninteractive tzdata \
&& sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
&& sed -i -e 's/# en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen \
&& echo 'LANG="en_US.UTF-8"'>/etc/default/locale \
&& dpkg-reconfigure --frontend=noninteractive locales \
&& update-locale LANG=en_US.UTF-8 \
\
&& apt-get -yqq install \
     automake \
     autotools-dev \
     g++ \
     make \
     build-essential \
     pkg-config \
     git \
     libfuse-dev \
     libcurl4-gnutls-dev \
     libxml2-dev \
     libssl-dev \
     libtool \
     mime-support \
\
&& mkdir -p /usr/src \
&& cd /usr/src \
&& git clone https://github.com/s3fs-fuse/s3fs-fuse.git \
&& cd /usr/src/s3fs-fuse \
&& ./autogen.sh \
&& ./configure --prefix=/usr --with-openssl \
&& make \
&& make install \
\
&& cd / \
&& rm -rf /usr/src \
&& apt-get -yqq purge \
     automake \
     autotools-dev \
     g++ \
     make \
     build-essential \
     pkg-config \
     git \
     libfuse-dev \
     libcurl4-gnutls-dev \
     libxml2-dev \
     libssl-dev \
     libtool \
\
&& apt-get clean all \
&& rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man* /tmp/* /var/tmp/*


