FROM golang:1.25-alpine AS builder

# Install build dependencies
RUN apk add --no-cache git make

WORKDIR /app

# Copy go mod and sum files first for better caching
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the source code
COPY . .

# Build the application
RUN make build


FROM alpine:latest  

# Install runtime dependencies
RUN apk --no-cache add ca-certificates curl

# Create a non-root user
RUN addgroup -S rendora && adduser -S rendora -G rendora

WORKDIR /rendora

# Copy the binary from the builder stage
COPY --from=builder /app/cmd/rendora/rendora /usr/bin/rendora

# Use the non-root user
USER rendora

ENTRYPOINT ["rendora"]
