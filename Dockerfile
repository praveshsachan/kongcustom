FROM kong:3.6

USER root

# Minimal tools
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      build-essential git unzip ca-certificates curl && \
    rm -rf /var/lib/apt/lists/*

# 1) Crypto prerequisite required by lua-resty-jwt
RUN luarocks install https://luarocks.org/lua-resty-openssl-1.6.1-1.src.rock

# 2) lua-resty-jwt (>= 0.2.0). Try 0.2.3 first; fallback to 0.2.0 if mirror hiccups.
RUN luarocks install https://luarocks.org/lua-resty-jwt-0.2.3-0.src.rock || \
    luarocks install https://luarocks.org/lua-resty-jwt-0.2.0-0.src.rock

# 3) Resty libraries from LuaRocks .src.rock (avoids GitHub rockspec URLs)
RUN luarocks install https://luarocks.org/lua-resty-http-0.15-0.src.rock && \
    luarocks install https://luarocks.org/lua-resty-session-4.1.5-1.src.rock

# 4) lua-resty-openidc (pinned to 1.8.0-1 rockspec in repo root)
RUN luarocks install https://raw.githubusercontent.com/zmartzone/lua-resty-openidc/master/lua-resty-openidc-1.8.0-1.rockspec

# 5) Install lua-cjson without manifest search
RUN luarocks install https://luarocks.org/lua-cjson-2.1.0.10-1.src.rock

# 6) Community OSS "kong-openid-connect" plugin (skip dependency resolution)
RUN luarocks install \
  https://raw.githubusercontent.com/cuongntr/kong-openid-connect-plugin/main/kong-openid-connect-1.1.0-1.rockspec \
  --deps-mode=none


# Enable the plugin by its runtime name
ENV KONG_PLUGINS="bundled,kong-openid-connect"

USER kong
