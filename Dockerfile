FROM ubuntu

# Install required packages
RUN apt update && apt upgrade -y 

# Install build packages
RUN apt -y install git build-essential gcc zlib1g-dev libssl-dev openssl cmake

# Build the DLU Server
RUN git clone --recursive https://github.com/DarkflameUniverse/DarkflameServer.git
WORKDIR /DarkflameServer
RUN ./build.sh -j$(grep -c '^processor' /proc/cpuinfo)

# Clean up the image
RUN apt -y remove git gcc zlib1g-dev libssl-dev cmake
RUN apt -y autoremove

# Create the default config files and link to the config folder. start.sh will copy the default configs to the config folder if they don't exist already
RUN mkdir /config
RUN mkdir /default-config
WORKDIR /DarkflameServer/build
RUN mv *.ini  /default-config/
RUN for file in /default-config/*.ini; do ln -s /config/$(basename $file) . ; done
# Disable unnecessary sudo auth 
RUN sed -i "s/use_sudo_auth.*/use_sudo_auth=0/g" /default-config/masterconfig.ini

# Set default env vars
ENV MYSQL_DATABASE=luniserver_net

RUN mkdir -p /server/logs

# Set the start script as entrypoint
COPY start.sh start.sh
ENTRYPOINT [ "/bin/bash", "/server/start.sh" ]
