FROM ruby:3.1.3

ENV RAILS_ROOT /opt/dev-example
#ENV NPM_BUILD_DIR /opt/node_build_dir
RUN apt-get update -y && apt-get install -y build-essential apt-utils libpq-dev imagemagick curl
RUN mkdir -p $RAILS_ROOT
WORKDIR $RAILS_ROOT
COPY ./Gemfile $RAILS_ROOT
COPY ./Gemfile.lock $RAILS_ROOT
RUN bundle install --jobs 20 --retry 5
EXPOSE 3000
