FROM ubuntu

# Install required packages
RUN apt update && apt upgrade -y 

# Install build packages
RUN apt -y install git build-essential gcc zlib1g-dev libssl-dev openssl cmake

# Build the DLU Server
RUN git clone --recursive https://github.com/DarkflameUniverse/DarkflameServer.git
RUN mkdir LegoFiles
WORKDIR /DarkflameServer
RUN ./build.sh -j$(grep -c '^processor' /proc/cpuinfo)

# Clean up the image
RUN apt -y remove git gcc zlib1g-dev libssl-dev cmake
RUN apt -y autoremove

# Set the start script as entrypoint
COPY /start.sh /DarkflameServer/start.sh
ENTRYPOINT [ "/bin/bash", "/DarkflameServer/start.sh" ]
