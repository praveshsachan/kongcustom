FROM kong:3.6

USER root

# Add required tools
RUN apk add --no-cache git unzip build-base

# Install lua-resty dependencies (via pinned rockspec URLs to avoid manifest errors)
RUN luarocks install https://raw.githubusercontent.com/zmartzone/lua-resty-openidc/v1.7.7/lua-resty-openidc-1.7.7-1.rockspec && \
    luarocks install https://raw.githubusercontent.com/ledgetech/lua-resty-http/v0.15.0-0/lua-resty-http-0.15.0-0.rockspec && \
    luarocks install https://raw.githubusercontent.com/bungle/lua-resty-session/v4.0.7/lua-resty-session-4.0.7-1.rockspec

# Install the kong-openid-connect plugin (official one from optum)
RUN luarocks install https://raw.githubusercontent.com/Optum/kong-openid-connect/master/kong-openid-connect-1.0.1-1.rockspec

# Enable ONLY this plugin
ENV KONG_PLUGINS="bundled,kong-openid-connect"

USER kong
