FROM golang:1.17.8-alpine
EXPOSE 8080
RUN apk add --update git; \
    mkdir -p ${GOPATH}/test-rest-api-go; \
    go get -u github.com/gorilla/mux
WORKDIR ${GOPATH}/test-rest-api-go/
COPY test-rest-api.go ${GOPATH}/test-rest-api-go/
RUN cd ${GOPATH}/test-rest-api-go/ && \
    go env -w GO111MODULE=auto && \
    go get -u github.com/gorilla/mux && \
    go build -o test-rest-api-go .
#
FROM golang:1.17.8-alpine
LABEL vendor=Vanapagan\ Software \
      com.example.is-production="Yes" \
      com.example.version="1.17.8" \
      com.example.release-date="2022-03-08"
RUN apk --no-cache add ca-certificates
WORKDIR /app
COPY --from=0 /go/test-rest-api-go/test-rest-api-go .
CMD [ "/app/test-rest-api-go" ]
