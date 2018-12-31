FROM pelias/baseimage

# ensure data dirs exists
RUN mkdir -p '/data/gndb'

# downloader apt dependencies
# note: this is done in one command in order to keep down the size of intermediate containers
RUN apt-get update && apt-get install -y bzip2 && apt-get install -y unzip && rm -rf /var/lib/apt/lists/*

# update node version
RUN npm install -g n
RUN n stable

# clone repo
RUN git clone https://github.com/venicegeo/pelias-gndb.git /code/pelias/gndb

# change working dir
WORKDIR /code/pelias/gndb

# consume the build variables
ARG REVISION=master

# switch to desired revision
RUN git checkout $REVISION

# install npm dependencies
RUN npm install

# run tests
RUN npm test

# explicitly download meta data
RUN npm run download_metadata