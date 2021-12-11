FROM golang:1.17-alpine AS builder

RUN apk add git make
WORKDIR /app
COPY . /app
RUN make deps

FROM alpine:latest

COPY --from=builder /go/bin/present /usr/local/bin/
COPY --from=builder /go/pkg /usr/local/go/pkg
WORKDIR /app
COPY . /app
CMD present -base /usr/local/go/pkg/mod/golang.org/x/tools@v0.1.8/cmd/present -http 0.0.0.0:3999 -use_playground
