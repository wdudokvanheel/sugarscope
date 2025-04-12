FROM fedora:41

ARG BINARY_PATH=target/release/sugarscope

COPY ${BINARY_PATH} /usr/local/bin/sugarscope

RUN chmod +x /usr/local/bin/sugarscope

ENTRYPOINT ["/usr/local/bin/sugarscope"]
