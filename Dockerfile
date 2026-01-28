FROM ruby:2.5.5-slim

# Fix Debian Buster EOL repos
RUN sed -i 's|deb.debian.org|archive.debian.org|g' /etc/apt/sources.list \
 && sed -i 's|security.debian.org|archive.debian.org|g' /etc/apt/sources.list \
 && sed -i '/buster-updates/d' /etc/apt/sources.list \
 && apt-get update -qq

# System deps
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  build-essential \
  libpq-dev \
  git \
  curl \
  shared-mime-info \
  gnupg \
  && rm -rf /var/lib/apt/lists/*

# Node 10.16.2
RUN curl -fsSL https://nodejs.org/dist/v10.16.2/node-v10.16.2-linux-x64.tar.xz -o node.tar.xz \
 && mkdir -p /usr/local/lib/nodejs \
 && tar -xJf node.tar.xz -C /usr/local/lib/nodejs \
 && rm node.tar.xz

ENV PATH=/usr/local/lib/nodejs/node-v10.16.2-linux-x64/bin:$PATH

# Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
 && apt-get update -qq && apt-get install -y yarn

WORKDIR /app

RUN gem install bundler -v 1.17.3

COPY Gemfile Gemfile.lock ./
RUN bundle _1.17.3_ install --without development test

COPY package.json yarn.lock ./
RUN yarn install

COPY . .

ENV RAILS_ENV=production
ENV RACK_ENV=production

RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rake assets:precompile

EXPOSE 8080

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "8080"]
