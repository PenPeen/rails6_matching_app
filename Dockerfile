FROM --platform=linux/arm64 ruby:3.1.2

# システムの依存関係をインストール
RUN apt-get update && apt-get install -y \
    curl \
    git \
    apt-transport-https \
    wget \
    mariadb-client \
    build-essential \
    libpq-dev

# Node.js 14をインストール
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install -y nodejs

# Yarnをインストール
RUN npm install -g yarn

RUN mkdir /myapp
WORKDIR /myapp

# Bundlerのバージョンを固定
RUN gem install bundler -v 2.3.7

# Gemfileのコピーと依存関係のインストール
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

# ローカルでのバンドルインストール
RUN bundle config set --local path 'vendor/bundle' && \
    bundle _2.3.7_ install

# package.jsonのコピーと依存関係のインストール
COPY package.json /myapp/package.json
COPY yarn.lock /myapp/yarn.lock
RUN yarn install

# プロジェクトファイルのコピー
COPY . /myapp

# コンテナ起動時に実行させるスクリプトを追加
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Rails サーバ起動
CMD ["rails", "server", "-b", "0.0.0.0"]
