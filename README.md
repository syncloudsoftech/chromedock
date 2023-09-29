# chromedock

[Docker](https://www.docker.com) image with latest [Chrome](https://www.google.com/chrome/), [chromedriver](https://googlechromelabs.github.io/chrome-for-testing/) and a [VNC](https://en.wikipedia.org/wiki/Virtual_Network_Computing) server for use in local development (or maybe elsewhere but not recommended).

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/syncloudsoftech/chromedock/publish.yml?branch=main)
![Docker Pulls](https://img.shields.io/docker/pulls/syncloudsoftech/chromedock)

## Usage

To launch a container from this image, you must have [Docker](https://www.docker.com) installed.
If already, run the below command:

```shell
$ docker run -d --name chromedock -p 4444:4444 -p 5900:5900 syncloudsoftech/chromedock
```

To start/stop the (named) container at a later point in time, use below commnads:

```shell
# start "chromedock" named container
$ docker start chromedock

# stop "chromedock" named container
$ docker stop chromedock
```

You can also connect to port `5900` using any [VNC](https://en.wikipedia.org/wiki/Virtual_Network_Computing) client e.g., [RealVNC Viewer](https://www.realvnc.com/en/connect/download/viewer/) to interact with running [Chrome](https://www.google.com/chrome/) instances.

Further to use in automation, you can specify the [chromedriver](https://googlechromelabs.github.io/chrome-for-testing/) server address shown as below:

```js
const { Builder, By, Key, until } = require('selenium-webdriver');

(async function example() {
  const driver = await new Builder()
    .forBrowser('chrome')
    .usingServer('http://<container_hostname_or_ip>:4444')
    .build();
  try {
    await driver.get('http://www.google.com/ncr');
    await driver.findElement(By.name('q')).sendKeys('Syncloud Softech', Key.RETURN);
    await driver.wait(until.titleIs('Syncloud Softech - Google Search'), 1000);
  } finally {
    await driver.quit();
  }
})();
```

### docker-compose.yml

To include this container as a service in your existing `docker-compose.yml` setup, use below definition:

```yml
version: "3"

services:
  chromedock:
    image: syncloudsoftech/chromedock
    ports:
      - "4444:4444"
      - "5900:5900"
```

If you wish to use the `--user-data-dir` option for persisting sessions, you need to create a directory under `/home/chrome` folder and use its abosolue path with [Chrome](https://www.google.com/chrome/) arguments:

```Dockerfile
FROM syncloudsoftech/chromedock

RUN mkdir -p /home/chrome/data && \
    chown chrome:chrome /home/chrome/data
```

Then run as below:

```shell
# build the container
$ docker build -t chromedock .

# create a "data" directory
$ mkdir data

# start the container
$ docker run --rm -it -p 4444:4444 -p 5900:5900 -v ./data:/home/chrome/data chromedock
```

If using `docker-compose.yml` file, you can do as below:

```yml
version: "3"

services:
  chromedock:
    build:
      dockerfile_inline: |
        FROM syncloudsoftech/chromedock
        RUN mkdir -p /home/chrome/data && \
        chown chrome:chrome /home/chrome/data
    image: syncloudsoftech/chromedock
    ports:
      - "4444:4444"
      - "5900:5900"
    volumes:
      - chromedock-data:/home/chrome/data

volumes:
  chromedock-data:
```

## Development

Building or modifying the container yourself from source is also quite easy.
Just clone the repository and run below command:

```shell
$ docker build -t chromedock .
```

Run the locally built container as follows:

```shell
$ docker run --rm -it -p 4444:4444 -p 5900:5900 chromedock
```

## License

See the [LICENSE](LICENSE) file.
