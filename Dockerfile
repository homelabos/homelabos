FROM ubuntu:18.04 as base



RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
# grab gosu for easy step-down from root
		gosu \
	; \
	rm -rf /var/lib/apt/lists/*; \
# verify that the "gosu" binary works
	gosu nobody true


RUN set -eux; \
	\
	apt-get update; \
	apt-get install --yes --no-install-recommends \
  ansible \
  git \
  curl \
  make

ENV LANG=C.UTF-8 LANGUAGE=C.UTF-8 LC_ALL=C.UTF-8

COPY . .
RUN make
