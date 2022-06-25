FROM ubuntu:22.10

RUN apt update && apt upgrade -y

# Configure stuff at root.
RUN cd /

# Copy source.
RUN mkdir osumffmpeg
COPY . /osumffmpeg/

# -----------------------------------------------------------------------------
# Get development dependencies
# -----------------------------------------------------------------------------

# Get Flutter dependencies.
RUN apt install zip xz-utils curl libglu1-mesa git -y

# Get Flutter
RUN git clone -b master https://github.com/flutter/flutter.git
ENV PATH="/flutter/bin:${PATH}"
RUN flutter precache & flutter doctor

# Flutter Linux Toolchain
RUN apt install clang cmake ninja-build pkg-config libgtk-3-dev -y

# Reduce executable size.
# RUN apt install upx -y

# -----------------------------------------------------------------------------
# Project Build
# -----------------------------------------------------------------------------

# Osumffmpeg Project
WORKDIR /osumffmpeg/

# Get Osumffmpeg dependencies.
RUN apt install ffmpeg -y

# Build Osumffmpeg linux executable.
RUN flutter create . && flutter clean && flutter pub get
RUN flutter clean && flutter build linux

# Reduce executable size via upx.
# RUN upx /osumffmpeg/build/linux/x64/release/bundle/lib/*

# Copy compiled binary to /bin/ path.
COPY /osumffmpeg/build/linux/x64/release/bundle/* /bin/

# -----------------------------------------------------------------------------
# Clean up everything.
# -----------------------------------------------------------------------------
 
# Remove development dependencies.
RUN apt remove curl clang cmake ninja-build pkg-config zip xz-utils curl git libgtk-3-dev -y

# Remove upx used for reducing executable size.
# RUN apt remove upx -y

# Remove flutter.
RUN rm -rf /flutter/

# Remove unused packages.
RUN apt autoremove --purge -y

# -----------------------------------------------------------------------------
# Entry point.
# -----------------------------------------------------------------------------

# Start Osumffmpeg.
CMD ["osumffmpeg"]
