FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y gnupg unzip wget

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update

RUN apt-get install -y google-chrome-stable && \
    rm /etc/apt/sources.list.d/google-chrome.list && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN CHROME_VERSION=$(google-chrome --version | sed -E "s/.* ([0-9]+)(\.[0-9]+){3}.*/\1/") \
    CHROMEDRIVER_VERSION=$(wget -qO- https://googlechromelabs.github.io/chrome-for-testing/LATEST_RELEASE_$CHROME_VERSION | sed 's/\r$//') \
    CHROMEDRIVER_URL=https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/$CHROMEDRIVER_VERSION/linux64/chromedriver-linux64.zip; \
    wget --no-verbose -O /tmp/chromedriver.zip $CHROMEDRIVER_URL && \
    rm -rf /opt/chromedriver && \
    unzip /tmp/chromedriver.zip -d /opt/chromedriver && \
    rm /tmp/chromedriver.zip && \
    mv /opt/chromedriver/chromedriver-linux64/chromedriver /opt/chromedriver/chromedriver-$CHROME_DRIVER_VERSION && \
    chmod 755 /opt/chromedriver/chromedriver-$CHROME_DRIVER_VERSION && \
    ln -fs /opt/chromedriver/chromedriver-$CHROME_DRIVER_VERSION /usr/bin/chromedriver

RUN groupadd -r chrome && \
    useradd -rm -g chrome -G audio,video chrome

USER chrome

WORKDIR /home/chrome

ENV CHROMEDRIVER_PORT 4444

CMD ["sh", "-c", "chromedriver --allowed-ips= --allowed-origins=* --port=${CHROMEDRIVER_PORT}"]