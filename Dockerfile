FROM ruby:2.3.4

MAINTAINER Faisal Mazidnianto <faisal.mazid41@gmail.com> 

# Set correct environment variables.
ENV HOME /root

# Run Bundle in a cache efficient way
WORKDIR /root
COPY . /root

RUN gem install bundler
RUN bundle install

EXPOSE 4567

ENTRYPOINT ["sudo","service","mongod","start"]
ENTRYPOINT ["bundle","exec","ruby","app/server.rb"]
