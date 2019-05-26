FROM alpine:3.9

LABEL maintainer="ruidevieira@googlemail.com"

COPY alpine.sh .
RUN sh alpine.sh
CMD ["/bin/sh"]