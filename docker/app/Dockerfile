FROM ruby:3.1.3

# Additional packages needed for compiling gems
RUN apt-get update -q && \
  apt-get install --assume-yes -q --no-install-recommends \
  build-essential \
  git \
  gpg \
  nodejs \
  npm \
  postgresql-client && \
  apt-get upgrade -y \
  openssh-client
RUN npm install --global yarn

# App location is /app
WORKDIR /app

# Expose Puma port
EXPOSE 3000

# Save timestamp of image building
RUN date -u > BUILD_TIME
