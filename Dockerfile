FROM ruby:2.3.6
MAINTAINER Serge Tkatchouk <sp1j3t@gmail.com>

# Prepare the userland:
RUN apt-get update && apt-get install -y build-essential libpq-dev nodejs

# Pull the app skeleton:
RUN mkdir /srv/kofta
WORKDIR /srv/kofta
COPY Gemfile /srv/kofta/Gemfile
COPY Gemfile.lock /srv/kofta/Gemfile.lock

# Install Ruby/Rails dependencies:
RUN bundle install

# Pull the rest of the app:
COPY . /srv/kofta

# Expose the Web UI port:
EXPOSE 3000/TCP
