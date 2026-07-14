# Based on justinribeiro/chrome-headless but modified to suit Rendora's goal for server-side rendering
FROM ubuntu:noble

ENV DEBIAN_FRONTEND=noninteractive

ARG CHROME_VERSION="150.0.7871.114-1"

LABEL name="chrome-headless" \
    version="1.0" \
    description="Headless Chrome"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    curl \
    apt-transport-https \
    ca-certificates \
    fontconfig \
    wget \
    gnupg \
    && wget --no-verbose -O /tmp/chrome.deb https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${CHROME_VERSION}_amd64.deb \
    && apt-get install -y --no-install-recommends /tmp/chrome.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/chrome.deb

# Create chrome user and directories
RUN groupadd -r chrome && useradd -r -g chrome -G audio,video chrome \
    && mkdir -p /home/chrome && chown -R chrome:chrome /home/chrome \
    && mkdir -p /opt/google/chrome && chown -R chrome:chrome /opt/google/chrome

# Install Tini for proper signal handling
ENV TINI_VERSION=v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

USER chrome

EXPOSE 9222

ENTRYPOINT ["/tini", "--", "google-chrome"]
CMD ["--disable-background-networking", \
    "--disable-background-timer-throttling", \
    "--disable-backgrounding-occluded-windows", \
    "--disable-breakpad", \
    "--disable-client-side-phishing-detection", \
    "--disable-component-update", \
    "--disable-device-discovery-notifications", \
    "--disable-default-apps", \
    "--disable-dev-shm-usage", \
    "--disable-domain-reliability", \
    "--disable-features=AudioServiceOutOfProcess,IsolateOrigins,site-per-process,OptimizationHints,PredictiveParsing,Prerender2", \
    "--disable-gpu", \
    "--disable-ipc-flooding-protection", \
    "--disable-print-preview", \
    "--disable-remote-fonts", \
    "--disable-renderer-backgrounding", \
    "--disable-setuid-sandbox", \
    "--disable-site-isolation-trials", \
    "--headless", \
    "--mute-audio", \
    "--no-first-run", \
    "--no-sandbox", \
    "--no-zygote", \
    "--remote-debugging-address=0.0.0.0", \
    "--remote-debugging-port=9222", \
    "--user-data-dir=/tmp"]
