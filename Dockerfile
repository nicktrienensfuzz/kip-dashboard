FROM swiftlang/swift:nightly-5.8-amazonlinux2



# RUN touch ~/.bashrc && chmod +x ~/.bashrc
# RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
# RUN . ~/.nvm/nvm.sh && source ~/.bashrc && nvm install node
#RUN ls="$(ls)" && echo $ls

 RUN yum -y install \
     git \
     libuuid-devel \
     libicu-devel \
     libedit-devel \
     libxml2-devel \
     sqlite-devel \
     ncurses-devel \
     curl-devel \
     openssl-devel \
     tzdata \
     libtool \
     jq \
     tar \
     zip gcc44 gcc-c++ libgcc44 cmake wget gzip make

RUN amazon-linux-extras install python3.8
# RUN wget -q https://www.python.org/ftp/python/3.11.3/Python-3.11.3.tgz 
# RUN tar xzf Python-3.11.3.tgz 
# RUN cd Python-3.11.3 && ./configure --enable-optimizations && make altinstall 

RUN version="$(python --version)" && echo $version

# Install node
# RUN wget -q http://nodejs.org/dist/v18.9.0/node-v18.9.0.tar.gz && \
#   tar -zxvf node-v18.9.0.tar.gz
# RUN cd node-v18.9.0 && ./configure && make && make install


RUN curl --silent --location https://rpm.nodesource.com/setup_16.x | bash -
RUN yum -y install nodejs

# RUN amazon-linux-extras install epel
# RUN yum install nodejs --enablerepo=epel-testing -y

# RUN yum --nogpgcheck localinstall https://intoli.com/blog/installing-google-chrome-on-centos/google-chrome-stable-60.0.3112.113-1.x86_64.rpm
#RUN curl https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm > google-chrome-stable_current_x86_64.rpm
#RUN yum install ./google-chrome-stable_current_*.rpm

#RUN yum install -y cups-libs dbus-glib libXrandr libXcursor libXinerama cairo cairo-gobject pango ruby binutils gcc git glibc-static gzip gcc-c++ make nodejs
# RUN curl -sL https://rpm.nodesource.com/setup_18.x | -E bash - 
# RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
#RUN . ~/.nvm/nvm.sh
RUN npm install -g npm@9.7.2

# Print Installed Swift Version
RUN version="$(swift --version)" && echo $version
RUN nversion="$(node --version)" && echo $nversion

COPY . /work
WORKDIR /work

# RUN cd toPDF && rm -rf node_modules && npm install

EXPOSE 8080

RUN swift build -c release
RUN cmd="$(swift build -c release --show-bin-path)" && echo $cmd
CMD /work/.build/aarch64-unknown-linux-gnu/release/kip-dashboard
#CMD cmd="$(swift build -c release --show-bin-path)" && "$(cmd)/kip-dashboard"

# WORKDIR /work/toPDF
# CMD node server.js
