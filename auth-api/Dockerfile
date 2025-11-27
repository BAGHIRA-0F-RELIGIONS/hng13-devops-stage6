FROM golang:1.21-alpine AS builder
WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 go build -o auth-api .

FROM gcr.io/distroless/base
COPY --from=builder /src/auth-api /auth-api

# Matches README default usage
EXPOSE 8081

CMD ["/auth-api"]