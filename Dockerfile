# syntax=docker/dockerfile:1

FROM ruby:3.2.2-slim AS base

ENV APP_ROOT /app

WORKDIR $APP_ROOT

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential pkg-config \
    libpq-dev

COPY Gemfile* $APP_ROOT
RUN bundle check || bundle install

COPY . $APP_ROOT

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
EXPOSE 3000

