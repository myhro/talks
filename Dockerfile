FROM golang:1.17-alpine AS builder

RUN go install golang.org/x/tools/cmd/present@v0.1.6
# Downloading the binary isn't enough on Go >= 1.16, the source is needed as well
# https://github.com/golang/go/issues/43459#issuecomment-800654748
RUN go get -d golang.org/x/tools/cmd/present@v0.1.6

FROM alpine:latest

COPY --from=builder /go/bin/present /usr/local/bin/
COPY --from=builder /go/pkg /usr/local/go/pkg
WORKDIR /app
COPY . /app
CMD present -base /usr/local/go/pkg/mod/golang.org/x/tools@v0.1.6/cmd/present -http 0.0.0.0:3999 -use_playground
