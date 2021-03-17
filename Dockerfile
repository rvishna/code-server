FROM codercom/code-server:latest

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    clang \
    clang-format \
    cmake \
    curl \
    default-jdk \
    g++ \
    gnupg \
    libboost-all-dev \
    libnss-wrapper \
    libssl-dev \
    libtinfo5 \
    libz-dev \
    lldb \
    lsb-release \
    make \
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    rake \
    ruby-full \
    software-properties-common \
    unzip \
    wget \
    zip \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/python3 /usr/local/bin/python && \
    ln -s /usr/bin/pip3 /usr/local/bin/pip

RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && apt-get install -y --no-install-recommends \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    && rm -rf /var/lib/apt/lists/* && \
    usermod -aG docker coder

RUN wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm -f packages-microsoft-prod.deb

RUN apt-get update && apt-get install -y --no-install-recommends \
    dotnet-sdk-3.1 \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get update && apt-get install -y --no-install-recommends \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g @angular/cli

RUN git clone --branch v2.10.14 --recurse-submodules https://github.com/microsoft/cpprestsdk.git /usr/local/src/cpprestsdk
RUN cmake -S /usr/local/src/cpprestsdk -B /usr/local/build/cpprestsdk \
    -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTS=OFF -DBUILD_SAMPLES=OFF -DBUILD_SHARED_LIBS=OFF && \
    cmake --build /usr/local/build/cpprestsdk --target install && \
    rm -rf /usr/local/build/cpprestsdk /usr/local/src/cpprestsdk

RUN git clone --branch v2.4.1 https://github.com/HowardHinnant/date.git /usr/local/src/date
RUN cmake -S /usr/local/src/date -B /usr/local/build/date -DCMAKE_BUILD_TYPE=Release -DENABLE_DATE_TESTING=OFF && \
    cmake --build /usr/local/build/date --target install && \
    rm -rf /usr/local/build/date /usr/local/src/date

RUN git clone --branch v3.7.0 https://github.com/nlohmann/json.git /usr/local/src/nlohmann-json
RUN cmake -S /usr/local/src/nlohmann-json -B /usr/local/build/nlohmann-json -DCMAKE_BUILD_TYPE=Release -DJSON_BuildTests=OFF && \
    cmake --build /usr/local/build/nlohmann-json --target install && \
    rm -rf /usr/local/build/nlohmann-json /usr/local/src/nlohmann-json

RUN git clone --branch v2.10.0 https://github.com/catchorg/Catch2.git /usr/local/src/catch2
RUN cmake -S /usr/local/src/catch2 -B /usr/local/build/catch2 -DCMAKE_BUILD_TYPE=Release -DCATCH_BUILD_TESTING=OFF && \
    cmake --build /usr/local/build/catch2 --target install && \
    rm -rf /usr/local/build/catch2 /usr/local/src/catch2

RUN git clone --branch v1.4.2 https://github.com/gabime/spdlog.git /usr/local/src/spdlog
RUN cmake -S /usr/local/src/spdlog -B /usr/local/build/spdlog -DCMAKE_BUILD_TYPE=Release -DSPDLOG_BUILD_TESTS=OFF && \
    cmake --build /usr/local/build/spdlog --target install && \
    rm -rf /usr/local/build/spdlog /usr/local/src/spdlog

USER coder
EXPOSE 8080

ENTRYPOINT ["dumb-init", "code-server", "--host", "0.0.0.0"]
