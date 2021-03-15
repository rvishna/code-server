FROM codercom/code-server:latest

USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https \
    clang \
    clang-format \
    cmake \
    g++ \
    libnss-wrapper \
    libssl-dev \
    libtinfo5 \
    libz-dev \
    lldb \
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

USER coder
EXPOSE 8080

ENTRYPOINT ["dumb-init", "code-server", "--host", "0.0.0.0"]
