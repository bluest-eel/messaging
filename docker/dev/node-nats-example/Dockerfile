#############################################################################
###   Build-support Phase   #################################################
#############################################################################
FROM golang:1.12-stretch AS builder

WORKDIR /
COPY httpd.go /
COPY public /public
ENV CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on
RUN go build -o httpd httpd.go

#############################################################################
###   Build Phase   #########################################################
#############################################################################
FROM scratch

COPY --from=builder /httpd /
COPY --from=builder /public /public
EXPOSE 4488
ENTRYPOINT ["/httpd"]
