FROM kong:3.6

USER root

# Install required tools (Debian/Ubuntu base)
# - build-essential: gcc/make/ld, etc.
# - git, unzip: needed by luarocks when fetching/building from sources
# - ca-certificates, curl: TLS & downloads during build steps
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      build-essential \
      git \
      unzip \
      ca-certificates \
      curl && \
    rm -rf /var/lib/apt/lists/*

# Install lua-resty dependencies via pinned rockspec URLs (avoid LuaRocks manifest parsing)
RUN luarocks install https://raw.githubusercontent.com/zmartzone/lua-resty-openidc/v1.7.7/lua-resty-openidc-1.7.7-1.rockspec && \
    luarocks install https://raw.githubusercontent.com/ledgetech/lua-resty-http/v0.15.0-0/lua-resty-http-0.15.0-0.rockspec && \
    luarocks install https://raw.githubusercontent.com/bungle/lua-resty-session/v4.0.7/lua-resty-session-4.0.7-1.rockspec

# Install ONLY the kong-openid-connect plugin (Optum)
# Pin to a specific rockspec version for reproducibility; adjust if you need a newer release.
RUN luarocks install https://raw.githubusercontent.com/Optum/kong-openid-connect/master/kong-openid-connect-1.0.1-1.rockspec

# Enable the plugin runtime name exactly as shipped by this rock
ENV KONG_PLUGINS="bundled,kong-openid-connect"

USER kong
