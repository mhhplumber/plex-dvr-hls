FROM ghcr.io/jrottenberg/ffmpeg/4.4.1-alpine313:latest as build-stage
FROM golang:1.21.1-alpine

COPY --from=build-stage /usr/local/bin /usr/local/bin
COPY --from=build-stage /usr/local/share /usr/local/share
COPY --from=build-stage /usr/local/include /usr/local/include
COPY --from=build-stage /usr/local/lib /usr/local/lib

WORKDIR /app
COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

CMD ["go", "run", "cmd/main.go"]
