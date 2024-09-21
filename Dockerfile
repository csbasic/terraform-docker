FROM alpine:3.20

RUN apk add --no-cache \
   curl \
   bash \
   git \
   wget \
   unzip \
   make \
   build-base \
   py3-pip \
   openssh-client

CMD ["bash"]