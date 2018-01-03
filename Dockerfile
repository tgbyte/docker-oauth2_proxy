FROM golang:1.9
RUN set -x\
    && go get github.com/bitly/oauth2_proxy \
    && cd /go/src/github.com/bitly/oauth2_proxy \
    && CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o oauth2_proxy .

FROM alpine
RUN set -x \
    && apk --no-cache add ca-certificates
COPY --from=0 /go/src/github.com/bitly/oauth2_proxy/oauth2_proxy /
EXPOSE 4180
ENTRYPOINT [ "./oauth2_proxy" ]
CMD [ "--upstream=http://0.0.0.0:8080/", "--http-address=0.0.0.0:4180" ]
