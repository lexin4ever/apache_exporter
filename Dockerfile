ARG ARCH="amd64"
ARG OS="linux"

FROM golang:1.24-alpine AS builder

ENV CGO_ENABLED=0 \
    GOOS=${OS} \
    GOARCH=${ARCH}

WORKDIR /build
COPY ./ ./
RUN go build .

FROM quay.io/prometheus/busybox-${OS}-${ARCH}:latest
LABEL maintainer="https://github.com/Lusitaniae, https://github.com/roidelapluie"

COPY --from=builder /build/apache_exporter /bin/apache_exporter

EXPOSE      9117
USER        nobody
ENTRYPOINT  [ "/bin/apache_exporter" ]