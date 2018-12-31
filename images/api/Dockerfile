FROM pelias/baseimage

# clone repo
RUN git clone https://github.com/venicegeo/pelias-api.git /code/pelias/api

# change working dir
WORKDIR /code/pelias/api

# consume the build variables
ARG REVISION=master

# switch to desired revision
RUN git checkout $REVISION

# install required utilities
RUN apt-get update && \
    apt-get install -y vim curl

# install node 6.x
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get install -y nodejs

# move original node and symlink
RUN mv /usr/local/bin/node /usr/local/bin/node.original

RUN ln -s /usr/bin/nodejs /usr/local/bin/node


# install npm dependencies
RUN npm install

# run tests
RUN npm test

# start service
CMD [ "npm", "start" ]