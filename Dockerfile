FROM alpine:3.17

ENV DOTNET_SCRIPT_URL "https://dot.net/v1/dotnet-install.sh"
ENV DOTNET_VERSION "8.0"
ENV TECHNITIUM_VERSION "latest"
ENV TECHNITIUM_URL_ARCHIVED_VERSION "https://download.technitium.com/dns/archive/${TECHNITIUM_VERSION}/DnsServerPortable.tar.gz"
ENV TECHNITIUM_URL_LATEST "https://download.technitium.com/dns/DnsServerPortable.tar.gz"


WORKDIR /tmp

# Install dependencies
RUN apk add --no-cache bash icu-libs krb5-libs libgcc libintl libssl1.1 libstdc++ openssl wget zlib
RUN apk add --no-cache libgdiplus --repository https://dl-cdn.alpinelinux.org/alpine/edge/testing/

# Install .NET
RUN wget -O install_dotnet.sh ${DOTNET_SCRIPT_URL} && \
  chmod +x install_dotnet.sh && \
  ./install_dotnet.sh --install-dir /usr/bin/dotnet -c ${DOTNET_VERSION} && \
  rm /tmp/install_dotnet.sh

# Install Technitium
RUN if [ $TECHNITIUM_VERSION != "latest" ] ; then TECHNITIUM_DOWNLOAD_URL=${TECHNITIUM_URL_ARCHIVED_VERSION} ; else TECHNITIUM_DOWNLOAD_URL=${TECHNITIUM_URL_LATEST} ; fi && \
  wget -O technitium.tar.gz ${TECHNITIUM_DOWNLOAD_URL} && \
  mkdir -p /etc/dns/ && \
  tar -zxf technitium.tar.gz -C /etc/dns/ && \
  chmod +x /etc/dns/start.sh && \
  rm /tmp/technitium.tar.gz

EXPOSE 5380/tcp
EXPOSE 53/udp
EXPOSE 53/tcp
EXPOSE 67/udp
EXPOSE 853/tcp
EXPOSE 443/tcp
EXPOSE 80/tcp
EXPOSE 8053/tcp

WORKDIR /etc/dns
VOLUME ["/etc/dns/config"]

ENV PATH /usr/bin/dotnet:$PATH
CMD ["./start.sh"]
