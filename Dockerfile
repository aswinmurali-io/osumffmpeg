FROM ubuntu:22.10

RUN apt update && apt upgrade -y

# Configure stuff at root.
RUN cd /

# -----------------------------------------------------------------------------
# Get development dependencies.
# -----------------------------------------------------------------------------

# Get flutter dependencies.
RUN apt install zip xz-utils curl libglu1-mesa git -y

# Get flutter linux toolchain dependencies.
RUN apt install clang cmake ninja-build pkg-config libgtk-3-dev -y

# Get flutter.
RUN git clone -b master https://github.com/flutter/flutter.git
ENV PATH="/flutter/bin:${PATH}"
RUN flutter precache --no-universal --linux & flutter doctor

# Get upx to reduce executable size.
# RUN apt install upx -y

# -----------------------------------------------------------------------------
# Get project dependencies.
# -----------------------------------------------------------------------------

# Get flutter runtime dependency.
RUN apt install libgtk-3-0

# Get osumffmpeg external dependencies.
RUN apt install ffmpeg -y

# -----------------------------------------------------------------------------
# Project build instructions.
# -----------------------------------------------------------------------------

# Copy source.
RUN mkdir osumffmpeg/
COPY . /osumffmpeg/
WORKDIR /osumffmpeg/

# Build linux executable.
RUN flutter create . --platforms=linux
RUN flutter build linux && cp -rf /osumffmpeg/build/linux/x64/release/bundle/* /bin/

# Reduce executable size via upx.
# RUN upx /osumffmpeg/build/linux/x64/release/bundle/lib/*

# -----------------------------------------------------------------------------
# Clean up everything.
# -----------------------------------------------------------------------------
 
# Remove development dependencies.
RUN apt remove zip xz-utils curl libglu1-mesa git -y
RUN apt remove clang cmake ninja-build pkg-config libgtk-3-dev -y

# Remove upx used for reducing executable size.
# RUN apt remove upx -y

# Remove flutter.
RUN rm -rf /flutter/

# Remove source code.
RUN rm -rf /osumffmpeg/

# Remove unused packages.
RUN apt autoremove --purge -y && apt clean -y

# -----------------------------------------------------------------------------
# Entry point.
# -----------------------------------------------------------------------------

# Start Osumffmpeg.
CMD ["osumffmpeg"]
