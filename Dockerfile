FROM debian:buster-slim

RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates gnupg2 && rm -rf /var/lib/apt/lists/*

COPY ./pdns.list /etc/apt/sources.list.d/pdns.list
COPY ./dnsdist /etc/apt/preferences.d/dnsdist

RUN	curl https://repo.powerdns.com/CBC8B383-pub.asc | apt-key add - && \
	curl https://repo.powerdns.com/FD380FBB-pub.asc | apt-key add - && \
	apt-get update && apt-get install -y --no-install-recommends openssl dnsdist && rm -rf /var/lib/apt/lists/*

COPY ./dnsdist.conf /etc/dnsdist/dnsdist.conf
COPY ./dnsdist.conf /etc/dnsdist_org/dnsdist.conf
COPY ./docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

# DNS over HTTP:
EXPOSE 5053

VOLUME /etc/dnsdist/
