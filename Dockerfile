FROM golang:1.15-alpine AS builder

RUN apk update
RUN apk add git
RUN go get -u golang.org/x/tools/cmd/present

FROM alpine:latest

RUN apk update
RUN apk add git
COPY --from=builder /go/bin/present /usr/local/bin/
COPY --from=builder /go/src /usr/local/go/src
WORKDIR /app
COPY . /app
CMD present -http 0.0.0.0:3999 -use_playground
