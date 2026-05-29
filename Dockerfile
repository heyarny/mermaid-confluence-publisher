FROM ghcr.io/heyarny/confluence-publisher:0.32.0-heyarny AS publisher

FROM minlag/mermaid-cli:11.15.0

USER root

# dependencies for confluence-publisher
# taken from https://github.com/confluence-publisher/confluence-publisher/blob/0.30.2/asciidoc-confluence-publisher-docker/Dockerfile
COPY --from=publisher /opt/asciidoc-confluence-publisher-docker.jar /opt/asciidoc-confluence-publisher-docker.jar
COPY --from=publisher /usr/local/bin/publish.sh /usr/local/bin/publish.sh
RUN apk add --update --no-cache openjdk11-jre graphviz ttf-dejavu

ENV ASCIIDOC_ROOT_FOLDER="/var/asciidoc-root-folder" \
    SOURCE_ENCODING="" \
    ROOT_CONFLUENCE_URL=""  \
    SKIP_SSL_VERIFICATION="false" \
    SPACE_KEY=""  \
    ANCESTOR_ID=""  \
    USERNAME=""  \
    PASSWORD=""  \
    PAGE_TITLE_PREFIX=""  \
    PAGE_TITLE_SUFFIX="" \
    PUBLISHING_STRATEGY="" \
    ORPHAN_REMOVAL_STRATEGY="" \
    VERSION_MESSAGE="" \
    NOTIFY_WATCHERS="true" \
    ATTRIBUTES="" \
    PROXY_SCHEME="" \
    PROXY_HOST="" \
    PROXY_PORT="" \
    PROXY_USERNAME="" \
    PROXY_PASSWORD="" \
    CONVERT_ONLY="false"

VOLUME /var/asciidoc-root-folder

# taken from https://github.com/mermaid-js/mermaid-cli/blob/11.15.0/Dockerfile#L19
ENV PATH=$PATH:/home/mermaidcli/node_modules/.bin

# wrapper so calls to `mmdc` always use the Puppeteer config (e.g. no-sandbox flags)
RUN printf '%s\n' '#!/bin/sh' \
  '/home/mermaidcli/node_modules/.bin/mmdc -p /puppeteer-config.json "$@"' \
  > /usr/local/bin/mmdc && chmod +x /usr/local/bin/mmdc

USER mermaidcli

ENTRYPOINT ["publish.sh"]
