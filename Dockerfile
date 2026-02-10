FROM kong:3.6
USER root

# System tools
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      build-essential git unzip ca-certificates curl && \
    rm -rf /var/lib/apt/lists/*

# --- Core deps installed via direct URLs (no manifest search) ---
# 1) lua-resty-openssl (needed by lua-resty-jwt)
RUN luarocks install https://luarocks.org/lua-resty-openssl-1.6.1-1.src.rock

# 2) lua-resty-jwt (>= 0.2.0)
#    If 0.2.3-0 has issues in your network, fall back to 0.2.0-0.
RUN luarocks install https://luarocks.org/lua-resty-jwt-0.2.3-0.src.rock || \
    luarocks install https://luarocks.org/lua-resty-jwt-0.2.0-0.src.rock

# 3) lua-resty-http, lua-resty-session (via rockspec URLs)
RUN luarocks install https://raw.githubusercontent.com/ledgetech/lua-resty-http/master/lua-resty-http-0.15-0.rockspec && \
    luarocks install https://raw.githubusercontent.com/bungle/lua-resty-session/master/lua-resty-session-4.1.5-1.rockspec

# 4) lua-resty-openidc itself (via rockspec URL)
RUN luarocks install https://raw.githubusercontent.com/zmartzone/lua-resty-openidc/master/lua-resty-openidc-1.8.0-1.rockspec

# 5) The community 'kong-openid-connect' plugin (Kong OSS, not the Enterprise one)
RUN luarocks install https://raw.githubusercontent.com/cuongntr/kong-openid-connect-plugin/main/kong-openid-connect-1.1.0-1.rockspec

# Enable the plugin by its runtime name
ENV KONG_PLUGINS="bundled,kong-openid-connect"

USER kong
