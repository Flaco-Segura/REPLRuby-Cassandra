FROM ruby:3.0.6-alpine
RUN apk update && apk add make gcc musl-dev
RUN bundle config --global frozen 1
RUN mkdir -p /app
WORKDIR /app
COPY Gemfile /app/
COPY Gemfile.lock /app/
RUN gem install sorted_set
RUN bundle install
COPY . /app/
CMD ["tail", "-f", "/dev/null"]