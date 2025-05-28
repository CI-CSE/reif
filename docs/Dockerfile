FROM ruby:3.3.0-slim-bookworm

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . ./
