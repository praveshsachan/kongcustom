FROM kong:3.6

USER root

# Install needed build tools for LuaRocks and TLS-enabled downloads
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      build-essential \
      git \
      unzip \
      ca-certificates \
      curl && \
    rm -rf /var/lib/apt/lists/*

# ---- Install deps via explicit rockspec URLs to avoid manifest parsing ----
# lua-resty-openidc (1.8.0-1)
RUN luarocks install https://raw.githubusercontent.com/zmartzone/lua-resty-openidc/master/lua-resty-openidc-1.8.0-1.rockspec

# lua-resty-http (0.15-0) - NOTE the version is "0.15-0" (not 0.15.0-0)
RUN luarocks install https://raw.githubusercontent.com/ledgetech/lua-resty-http/master/lua-resty-http-0.15-0.rockspec

# lua-resty-session (4.1.5-1) - recent and Lua 5.1 compatible
RUN luarocks install https://raw.githubusercontent.com/bungle/lua-resty-session/master/lua-resty-session-4.1.5-1.rockspec

# ---- Install the community 'kong-openid-connect' plugin (1.1.0-1) ----
RUN luarocks install https://raw.githubusercontent.com/cuongntr/kong-openid-connect-plugin/main/kong-openid-connect-1.1.0-1.rockspec

# Enable the plugin by its exact runtime name
ENV KONG_PLUGINS="bundled,kong-openid-connect"

USER kong
