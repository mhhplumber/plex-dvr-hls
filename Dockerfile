FROM golang:1.21.1-alpine

RUN apk update && apk add --no-cache ffmpeg openssl1.1-compat-dev

WORKDIR /app
COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

ENTRYPOINT ["./entrypoint.sh"]
VOLUME [/config]
