
FROM ubuntu:18.04
LABEL Name=ardour-build Version=0.0.1

ENV XARCH=x86_64
ENV ROOT=/ardour
ENV MAKEFLAGS=-j4

RUN sed -i "s:# deb-src:deb-src:" /etc/apt/sources.list; \
  apt-get -y update && apt-get install -y \
    wget \
    git \
    libboost-all-dev gcc g++ pkg-config libasound2-dev libgtk2.0-dev \
libsndfile1-dev libarchive-dev liblo-dev libtag1-dev \
vamp-plugin-sdk librubberband-dev libfftw3-dev libaubio-dev libxml2-dev \
lv2-dev libserd-dev libsord-dev libsratom-dev liblilv-dev libgtkmm-2.4-dev \
libglibmm-2.4-dev libusb-1.0-0-dev libpangomm-1.4-dev libsamplerate0-dev \
libcunit1-dev libcppunit-dev libudev-dev libserd-0-0 libcwiid-dev \
libxwiimote-dev libwebsocketpp-dev libwebsockets-dev \
libsratom-0-0 liblrdf0 liblrdf0-dev libraptor2-dev libcurl4-gnutls-dev

VOLUME [ "/build" ]

RUN git clone git://git.ardour.org/ardour/ardour.git /ardour

WORKDIR /ardour

RUN git checkout tags/6.5 \
  && ./waf configure \
  && ./waf build test

RUN apt-get install -y chrpath apt-utils curl zip; ./waf; \
  cd tools/linux_packaging/; \
  ./build --public --strip some; \
  ./package --public --singlearch

RUN cp Ardour-6.5.0-dbg-x86_64.tar /build/


# CMD /usr/games/fortune -a | cowsay
