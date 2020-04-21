FROM debian:buster-slim

# RUN echo 'deb http://deb.debian.org/debian buster-backports main' > /etc/apt/sources.list.d/backports.list

RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates gnupg2 && rm -rf /var/lib/apt/lists/*

COPY ./pdns.list /etc/apt/sources.list.d/pdns.list
COPY ./dnsdist /etc/apt/preferences.d/dnsdist

RUN	curl https://repo.powerdns.com/CBC8B383-pub.asc | apt-key add - && \
	curl https://repo.powerdns.com/FD380FBB-pub.asc | apt-key add - && \
	apt-get update && apt-get install -y --no-install-recommends openssl dnsdist && rm -rf /var/lib/apt/lists/*

COPY ./dnsdist.conf /etc/dnsdist/dnsdist.conf

RUN mkdir -p /etc/dnsdist/conf.d; mkdir -p /etc/dnsdist/cert; chown -R _dnsdist:_dnsdist /etc/dnsdist/

# we put dnsdist behind revproxy, so no need any more for certificates

CMD ["dnsdist", "--verbose", "--supervised"]


# EXPOSE 53/udp
# EXPOSE 53
# DNS over HTTP:
EXPOSE 5053

VOLUME /etc/dnsdist/
