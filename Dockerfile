FROM ruby:2.5.5-slim

# System deps
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  git \
  && rm -rf /var/lib/apt/lists/*

# App directory
WORKDIR /app

# Bundler version compatible with Rails 5.1
RUN gem install bundler -v 1.17.3

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle _1.17.3_ install --without development test

# Copy app
COPY . .

# Rails env
ENV RAILS_ENV=production
ENV RACK_ENV=production

# Precompile assets (safe even if empty)
RUN bundle exec rake assets:precompile || true

# Fly expects port 8080
EXPOSE 8080

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "8080"]
