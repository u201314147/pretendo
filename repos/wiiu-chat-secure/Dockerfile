# syntax=docker/dockerfile:1

ARG app_dir="/home/go/app"


# * Building the application
FROM golang:1.22-alpine3.20 AS build
ENV GOFLAGS="-mod=mod"
ARG app_dir

WORKDIR ${app_dir}

RUN go install github.com/go-delve/delve/cmd/dlv@v1.22.0

RUN apk add git
RUN git clone --depth 1 --branch v1.0.22 https://github.com/PretendoNetwork/nex-protocols-common-go
# Terrible hack to work around the issue where the ticket timestamp is 0
RUN sed -i 's/ticket\.Timestamp()\.Standard()/time\.Now()\.UTC()/g' nex-protocols-common-go/secure-connection/connect.go

RUN --mount=type=cache,target=/go/pkg/mod/ \
	--mount=type=bind,source=go.sum,target=go.sum \
	--mount=type=bind,source=go.mod,target=go.mod \
	go mod download -x

COPY . .
RUN --mount=type=cache,target=/go/pkg/mod/ \
	CGO_ENABLED=0 go build -gcflags "all=-N -l" -v -o ${app_dir}/build/server


# * Running the final application
FROM alpine:3.20 AS final
ARG app_dir
WORKDIR ${app_dir}

RUN addgroup go && adduser -D -G go go

RUN mkdir -p ${app_dir}/log && chown go:go ${app_dir}/log

USER go

COPY --from=build /go/bin/dlv ${app_dir}/dlv
COPY --from=build ${app_dir}/build/server ${app_dir}/server

CMD ["./dlv", "exec", "./server", "--listen=:2345", "--headless", "--api-version=2", "--log", "--accept-multiclient", "--continue"]
