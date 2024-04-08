FROM ruby:3.3.0-slim-bookworm AS base

# Install yarn https://wiki.debian.org/Yarn
RUN apt update && apt install yarnpkg build-essential -y
RUN ln -s /usr/bin/yarnpkg /usr/bin/yarn

WORKDIR /app

FROM base AS builder

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY package.json yarn.lock ./
RUN yarn install

COPY . ./
