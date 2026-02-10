FROM kong:3.6

USER root

RUN luarocks install lua-resty-openidc && \
    luarocks install lua-resty-http && \
    luarocks install lua-resty-session

RUN luarocks install kong-openid-connect

ENV KONG_PLUGINS=bundled,kong-openid-connect

USER kong
