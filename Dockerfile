FROM kong:3.6
USER root

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ca-certificates curl && \
    rm -rf /var/lib/apt/lists/*

# Install resty libraries via OPM (no LuaRocks lookup)
RUN opm get zmartzone/lua-resty-openidc && \
    opm get openresty/lua-resty-http && \
    opm get bungle/lua-resty-session && \
    opm get SkyLothar/lua-resty-jwt

# Install the community 'kong-openid-connect' plugin but SKIP deps check
RUN luarocks install \
  https://raw.githubusercontent.com/cuongntr/kong-openid-connect-plugin/main/kong-openid-connect-1.1.0-1.rockspec \
  --deps-mode=none

ENV KONG_PLUGINS="bundled,kong-openid-connect"
USER kong
