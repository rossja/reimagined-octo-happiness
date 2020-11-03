FROM ruby:2.7 as build
LABEL MAINTAINER algorythm@gmail.com

ARG RAILS_APP_USER
ARG RAILS_APP_GROUP
ARG RAILS_APP_UID
ARG RAILS_APP_GID
ARG RAILS_APP_DIR

RUN addgroup --gid ${RAILS_APP_GID} ${RAILS_APP_GROUP} && adduser --disabled-password --gecos '' --uid ${RAILS_APP_UID} --gid ${RAILS_APP_GID} ${RAILS_APP_USER}

ENV INSTALL_PATH ${RAILS_APP_DIR}
RUN mkdir -p ${RAILS_APP_DIR} && chown -R ${RAILS_APP_USER}:${RAILS_APP_GROUP} ${RAILS_APP_DIR}

# nodejs
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg -o /root/yarn-pubkey.gpg && apt-key add /root/yarn-pubkey.gpg
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y --no-install-recommends nodejs yarn

# rails
RUN gem install rails bundler

WORKDIR ${RAILS_APP_DIR}
COPY src/Gemfile Gemfile
RUN bundle install
RUN chown -R chown -R ${RAILS_APP_USER}:${RAILS_APP_GROUP} ${RAILS_APP_DIR}

FROM build
WORKDIR ${RAILS_APP_DIR}
USER ${RAILS_APP_UID}
ADD src ${RAILS_APP_DIR}
CMD bundle exec unicorn -c config/unicorn.rb