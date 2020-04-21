FROM alpine

RUN apk --update upgrade && apk add dnsdist openssl

COPY ./dnsdist.conf /etc/dnsdist.conf

RUN mkdir -p /etc/dnsdist/conf.d; mkdir -p /etc/dnsdist/cert; chown -R dnsdist:dnsdist /etc/dnsdist/

RUN if [ ! -f /etc/dnsdist/cert/fullchain.cer ]; then \
	openssl req -nodes -x509 -newkey rsa:2048 \
		-keyout /etc/dnsdist/cert/ca.key -out /etc/dnsdist/cert/ca.crt \
		-subj "/C=NL/ST=NHD/L=Amsterdam/O=Company/OU=root/CN=`hostname -f`/emailAddress=dnsdist@`hostname -f`" && \
	openssl req -nodes -newkey rsa:2048 \
		-keyout /etc/dnsdist/cert/key.key -out /etc/dnsdist/cert/server.csr \
		-subj "/C=NL/ST=NHD/L=Amsterdam/O=Company/OU=root/CN=`hostname -f`/emailAddress=dnsdist@`hostname -f`" && \
	openssl x509 -req -in /etc/dnsdist/cert/server.csr -CA /etc/dnsdist/cert/ca.crt -CAkey /etc/dnsdist/cert/ca.key -CAcreateserial -out /etc/dnsdist/cert/fullchain.cer; fi


CMD ["dnsdist", "--verbose"]


EXPOSE 53/udp
EXPOSE 53

VOLUME /etc/dnsdist/
