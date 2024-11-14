# Use Ubuntu as the base image
FROM mcr.microsoft.com/dotnet/sdk:6.0.428-1-jammy-amd64
# Set environment variables
ENV DOWNLOAD_URL=https://www.eiffel.com/cdn/EiffelStudio/24.05/107822/Eiffel_24.05_rev_107822-linux-x86-64.tar.bz2
ENV ESTUDIO_FOLDER=Eiffel_24.05
ENV ISE_PLATFORM=linux-x86-64
ENV Z3_URL=https://github.com/Z3Prover/z3/releases/download/z3-4.8.8/z3-4.8.8-x64-ubuntu-16.04.zip

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    tar \
    bzip2 \
    git \
    libgtk-3-dev \
    unzip \
    python3 \
    sudo

# Install EiffelStudio
RUN wget --no-verbose -O estudio.tar.bz2 $DOWNLOAD_URL && \
    tar -xf estudio.tar.bz2 && \
    rm estudio.tar.bz2

# Set EiffelStudio environment variables
ENV ISE_EIFFEL=/$ESTUDIO_FOLDER
ENV EIFFEL_SRC=/Src
ENV EXT=/research/extension
ENV AP=$EXT/autoproof
ENV GOBO=$EIFFEL_SRC/contrib/library/gobo
ENV PATH=$PATH:$ISE_EIFFEL/studio/spec/$ISE_PLATFORM/bin

# Install Boogie
RUN git clone https://github.com/boogie-org/boogie.git
WORKDIR /boogie
RUN    git checkout v2.11.1
RUN dotnet build Source/Boogie.sln
WORKDIR $ISE_EIFFEL/studio/tools/boogie 
WORKDIR $ISE_EIFFEL/studio/tools/autoproof


ADD ./Src /Src
ADD ./research /research 
RUN cp -rp $AP/* $ISE_EIFFEL/studio/tools/autoproof 
RUN cp -rp /boogie/Source/BoogieDriver/bin/Debug/net6.0/* $ISE_EIFFEL/studio/tools/boogie/ 
RUN mv $ISE_EIFFEL/studio/tools/boogie/BoogieDriver $ISE_EIFFEL/studio/tools/boogie/boogie

# Install Z3
WORKDIR /
RUN wget --no-verbose -O z3.zip $Z3_URL && \
    unzip z3.zip && \
    mv $(find ./z3* -name bin -type d) /usr/local && \
    rm z3.zip

# Compile C code
WORKDIR /research
RUN ls -al $EIFFEL_SRC/C
RUN bash compile_c.sh

# Build EVE
ENV ISE_LIBRARY=$EIFFEL_SRC
RUN echo 1
RUN ec -config $EXT/autoproof/autoproof-tty.ecf -freeze -c_compile -batch -target batch

ENV AP_EXE=/research/EIFGENs/batch/W_code/apb

WORKDIR /project

# $AP_EXE -config project.ecf -batch -c_compile -autoproof LINEAR_SEARCH

# $AP_EXE -config project.ecf -batch -c_compile -autoproof