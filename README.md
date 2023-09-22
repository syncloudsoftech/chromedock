# chromedock

[Docker](https://www.docker.com) image with latest [Chrome](https://www.google.com/chrome/) + [chromedriver](https://googlechromelabs.github.io/chrome-for-testing/) for use in local development (or maybe elsewhere but not recommended).

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/syncloudsoftech/chromedock/publish.yml?branch=main)
![Docker Pulls](https://img.shields.io/docker/pulls/syncloudsoftech/chromedock)

## Usage

To launch a container from this image, you must have [Docker](https://www.docker.com) installed.
If already, run the below command:

```shell
$ docker run -d --name chromedock -p 4444:4444 syncloudsoftech/chromedock
```

To start/stop the (named) container at a later point in time, use below commnads:

```
# start "chromedock" named container
$ docker start chromedock

# stop "chromedock" named container
$ docker stop chromedock
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
```

## Development

Building or modifying the container yourself from source is also quite easy.
Just clone the repository and run below command:

```shell
$ docker build -t chromedock .
```

Run the locally built container as follows:

```shell
$ docker run -it -p 4444:4444 chromedock
```

## License

See the [LICENSE](LICENSE) file.
