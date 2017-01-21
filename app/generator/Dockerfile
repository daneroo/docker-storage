FROM golang:1.7.4

# From https://github.com/tvtamas/docker-golang-glide
MAINTAINER Daniel Lauzon <daniel.lauzon@gmail.com>

ENV REPO daneroo/docker-storage/app/generator
ENV GLIDE_VERSION 0.12.3

ENV GLIDE_DOWNLOAD_URL https://github.com/Masterminds/glide/releases/download/v${GLIDE_VERSION}/glide-v${GLIDE_VERSION}-linux-amd64.tar.gz
RUN curl -fsSL "$GLIDE_DOWNLOAD_URL" -o glide.tar.gz \
    && tar -xzf glide.tar.gz \
    && mv linux-amd64/glide /usr/bin/ \
    && rm -r linux-amd64 \
    && rm glide.tar.gz

# RUN go get github.com/alecthomas/gometalinter && \
#     gometalinter --install --update

RUN mkdir -p /go/src/github.com/${REPO}
WORKDIR /go/src/github.com/${REPO}

# install dependencies with glide
COPY glide.yaml glide.yaml
COPY glide.lock glide.lock
RUN glide install -v

# copy source and build
COPY . /go/src/github.com/${REPO}
RUN go build

# run the built binary
# CMD ["go-wrapper", "run"]
CMD ./generator