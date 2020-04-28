FROM elixir:1.10-alpine as build

# Install deps
RUN set -xe; \
    apk add --update  --no-cache --virtual .build-deps \
        ca-certificates \
        g++ \
        gcc \
        git \
        make \
        musl-dev \
        tzdata;

# Use the standard /usr/local/src destination
RUN mkdir -p /usr/local/src/sponsors

COPY . /usr/local/src/sponsors/

# ARG is available during the build and not in the final container
# https://vsupalov.com/docker-arg-vs-env/
ARG MIX_ENV=prod
ARG APP_NAME=sponsors

# Use `set -xe;` to enable debugging and exit on error
# More verbose but that is often beneficial for builds
RUN set -xe; \
    cd /usr/local/src/sponsors/; \
    mix local.hex --force; \
    mix local.rebar --force; \
    mix deps.get; \
    mix deps.compile --all; \
    mix release

FROM alpine:3.9 as release

RUN set -xe; \
    apk add --update  --no-cache --virtual .runtime-deps \
        ca-certificates \
        libmcrypt \
        ncurses-libs \
        tzdata;

# Create a `sponsors` group & user
# I've been told before it's generally a good practice to reserve ids < 1000 for the system
RUN set -xe; \
    addgroup -g 1000 -S sponsors; \
    adduser -u 1000 -S -h /sponsors -s /bin/sh -G sponsors sponsors;

ARG APP_NAME=sponsors

# Copy the release artifact and set `sponsors` ownership
COPY --chown=sponsors:sponsors --from=build /usr/local/src/sponsors/_build/prod/rel/${APP_NAME} /sponsors

# These are fed in from the build script
ARG VCS_REF
ARG BUILD_DATE
ARG VERSION

# `Maintainer` has been deprecated in favor of Labels / Metadata
# https://docs.docker.com/engine/reference/builder/#maintainer-deprecated
LABEL \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.description="sponsors" \
    org.opencontainers.image.revision="${VCS_REF}" \
    org.opencontainers.image.source="https://github.com/system76/sponsors" \
    org.opencontainers.image.title="sponsors" \
    org.opencontainers.image.vendor="system76" \
    org.opencontainers.image.version="${VERSION}"

ENV \
    PATH="/usr/local/bin:$PATH" \
    VERSION="${VERSION}" \
    MIX_APP="sponsors" \
    MIX_ENV="prod" \
    SHELL="/bin/bash"

# Drop down to our unprivileged `sponsors` user
USER sponsors

WORKDIR /sponsors

EXPOSE 8080

ENTRYPOINT ["/sponsors/bin/sponsors"]

CMD ["start"]
