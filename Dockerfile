
FROM ubuntu:xenial

RUN apt-get clean && \
  apt-get update && \
  apt-get install -y  \
    bzip2       \
    ca-certificates \
    clang \
    curl        \
    git         \
    python-software-properties \
    screen      \
    software-properties-common \
    sudo


#RUN apt-get update && \
#  apt-get install -y  \
#    python-pip \
#    python3-pip

RUN : "adding user" && \
  addgroup --gid 1000 user && \
  adduser --home /home/user --disabled-password --shell /bin/bash --gid 1000 --uid 1000 --gecos '' user && \
  echo '%user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER user
WORKDIR /home/user
ENV HOME /home/user

RUN \
      curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash - \
  &&  sudo apt install nodejs

RUN \
      curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - \
  &&  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list \
  &&  sudo apt-get update || true \
  &&  sudo apt-get install -y yarn \
  &&  sudo apt-get install -y gettext \
  &&  sudo apt-get install -y libsecret-1-dev

ENV \
  ELECTRON_CACHE=$HOME/.cache/electron \
  ELECTRON_BUILDER_CACHE=$HOME/.cache/electron-builder

RUN \
  git clone --depth 5 https://github.com/laurent22/joplin.git

WORKDIR joplin

# git checkout -b building v1.4.18

RUN \
      npm install \
  &&  cd packages/app-desktop \
  &&  USE_HARD_LINKS=false npm run dist



