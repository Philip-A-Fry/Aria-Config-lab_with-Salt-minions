FROM photon:5.0

ARG plugin_name
ARG salt_version

COPY ./eapi_plugin/files/$plugin_name $plugin_name

RUN tdnf update -y && \
    tdnf install -y salt3-master-$salt_version python3-pip && \
    pip3 install pyzmq==25.1.2 pyjwt && \
    pip3 install /$plugin_name && \
    rm SSEAPE*.whl

ENTRYPOINT [ "/usr/bin/salt-master" ]
CMD [ "-l", "info" ]