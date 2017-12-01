FROM ruby:latest
ENV APP_HOME /app
ENV RAILS_ENV=production

RUN apt-get update && \
    apt-get install --yes --no-install-recommends locales && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN gem update --no-document --system

RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
RUN locale-gen
ENV LC_ALL en_US.UTF-8

RUN mkdir "$APP_HOME"
WORKDIR $APP_HOME

RUN gem install bundler
COPY Gemfile* $APP_HOME/
RUN bundle install -j 4 --without development test

COPY . $APP_HOME

CMD /app/bin/rails server --port ${PORT:-3000} --binding 0.0.0.0
