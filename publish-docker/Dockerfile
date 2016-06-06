FROM ruby
MAINTAINER Fiona Hasanaj

# install necessary software
RUN apt-get -y update && apt-get install -y git

RUN gem install rdoc

RUN echo "---" >> ~/.gem/credentials && \
    echo ":rubygems_api_key: 2b76b99a75e48ab7005c8cb1967c9f21" >> ~/.gem/credentials && \
    chmod 0600 ~/.gem/credentials  

RUN mkdir /ruby
WORKDIR /ruby
COPY publish.sh publish.sh
RUN chmod 0755 publish.sh

# allow interactive bash inside docker container
CMD ./publish.sh

VOLUME ["/source"]
