FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y gnupg unzip wget && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN apt-get update && \
    apt-get install -y xvfb && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update

RUN apt-get update && \
    apt-get install -y google-chrome-stable && \
    rm /etc/apt/sources.list.d/google-chrome.list && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN CHROME_VERSION=$(google-chrome --version | sed -E "s/.* ([0-9]+)(\.[0-9]+){3}.*/\1/") \
    CHROMEDRIVER_VERSION=$(wget -qO- https://googlechromelabs.github.io/chrome-for-testing/LATEST_RELEASE_$CHROME_VERSION | sed 's/\r$//') \
    CHROMEDRIVER_URL=https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/$CHROMEDRIVER_VERSION/linux64/chromedriver-linux64.zip; \
    wget -q -O /tmp/chromedriver.zip $CHROMEDRIVER_URL && \
    rm -rf /opt/chromedriver && \
    unzip /tmp/chromedriver.zip -d /opt/chromedriver && \
    rm /tmp/chromedriver.zip && \
    mv /opt/chromedriver/chromedriver-linux64/chromedriver /opt/chromedriver/chromedriver-$CHROMEDRIVER_VERSION && \
    chmod 755 /opt/chromedriver/chromedriver-$CHROMEDRIVER_VERSION && \
    ln -fs /opt/chromedriver/chromedriver-$CHROMEDRIVER_VERSION /usr/bin/chromedriver

RUN apt-get update && \
    apt-get install -y fluxbox pulseaudio x11vnc && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN groupadd -r chrome && \
    useradd -rm -g chrome -G audio,pulse-access,video chrome && \
    usermod -s /bin/bash chrome

RUN apt-get update && \
    apt-get install -y supervisor && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

COPY supervisor.conf /etc/supervisor/supervisor.conf

USER chrome

WORKDIR /home/chrome

CMD ["sh", "-c", "supervisord -c /etc/supervisor/supervisor.conf --logfile /dev/null --pidfile /dev/null"]
