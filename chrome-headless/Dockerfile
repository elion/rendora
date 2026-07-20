# Stage 1: Download and unpack the official binary
FROM alpine AS fetcher

# Define the Chrome for Testing version to pull
ARG CHROME_VERSION="150.0.7871.114"

RUN apk add --no-cache curl unzip
RUN curl -O "https://storage.googleapis.com/chrome-for-testing-public/${CHROME_VERSION}/linux64/chrome-headless-shell-linux64.zip"
RUN unzip chrome-headless-shell-linux64.zip

# Compile a tiny pinger
RUN apk add --no-cache go
RUN echo 'package main; import ("net/http"; "os"); func main() { _, err := http.Get("http://localhost:9222/json/version"); if err != nil { os.Exit(1) } }' > health.go
RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o /healthcheck health.go

# Stage 2: Build the clean production image
FROM debian:bookworm-slim
# Install only the absolute required runtime system libraries
RUN apt-get update && apt-get install -y --no-install-recommends \
    libglib2.0-0 libnss3 libnspr4 libatk1.0-0 libatk-bridge2.0-0 libcups2 \
    libdrm2 libdbus-1-3 libxcb1 libxkbcommon0 libx11-6 libxcomposite1 \
    libxdamage1 libxext6 libxfixes3 libxrandr2 libgbm1 libpango-1.0-0 \
    libcairo2 libasound2 ca-certificates fonts-liberation \
    && rm -rf /var/lib/apt/lists/*

# Copy ONLY the final extracted binary from Stage 1 into a single new layer
COPY --from=fetcher /chrome-headless-shell-linux64 /opt/chrome-headless-shell
COPY --from=fetcher /healthcheck /usr/local/bin/healthcheck

LABEL name="chrome-headless" \
    version="1.0" \
    description="Headless Chrome based on chrome-headless-shell"

ENTRYPOINT ["/opt/chrome-headless-shell/chrome-headless-shell"]
