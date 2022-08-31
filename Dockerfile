FROM rust:buster AS rndlab-tools

WORKDIR /usr/src/myapp
RUN apt-get update && apt-get install -y git libssl-dev pkg-config && \
    git clone http://github.com/rndlabs/bee-api-rs bee_api && \
    git clone http://github.com/rndlabs/bee-herder bee_herder && \
    git clone http://github.com/rndlabs/mantaray-rs mantaray && \
    git clone http://github.com/rndlabs/wiki-extractor wiki_extractor && \
    git clone http://github.com/rndlabs/zim-rs zim
COPY . .
RUN rustup toolchain install nightly && \
    rustup default nightly
RUN cargo build --release

FROM node:buster AS svelte-tools
RUN apt-get update && apt-get install -y git curl
COPY --from=rndlab-tools /usr/src/myapp/target/release/bee_herder /usr/bin/bee_herder
COPY --from=rndlab-tools /usr/src/myapp/target/release/wiki_extractor /usr/bin/wiki_extractor
COPY entrypoint.sh /usr/local/bin
RUN chmod +x /usr/bin/bee_herder && chmod +x /usr/bin/wiki_extractor && chmod +x /usr/local/bin/entrypoint.sh

VOLUME [ "/data" ]
CMD []