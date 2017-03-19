FROM ruby:2.3-slim
MAINTAINER Wagner Santos <wagnermecsantos@gmail.com>

# Set noninteractive and installing apt-utils first to avoid errors
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y -qq --no-install-recommends apt-utils
RUN apt-get install -qq -y --no-install-recommends \
      build-essential nodejs libpq-dev

ENV INSTALL_PATH /app

RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

COPY Gemfile Gemfile.lock ./

RUN gem install bundler && bundle install --without development test

COPY . .

EXPOSE 3000

CMD ["bundle", "exec", "rails", "s"]  
