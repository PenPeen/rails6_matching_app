#!/bin/bash
set -e

# Rails に対応したファイル server.pid が存在しているかもしれないので削除
rm -f /myapp/tmp/pids/server.pid

# Gemの依存関係を確認して修正
bundle check || bundle install --path vendor/bundle

# JavaScript依存関係を確認して修正
yarn install --check-files

# データベースのマイグレーションを実行
bundle exec rails db:migrate 2>/dev/null || bundle exec rails db:setup

# Webpackerをコンパイル
bundle exec rails webpacker:compile || true

# コンテナのメインプロセスとしてRailsサーバを実行
exec "$@"
