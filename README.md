# マッチングアプリケーション

## プロジェクト概要
このRailsアプリケーションは、ユーザー同士のマッチングを支援するWebアプリケーションです。

## 必要な環境
* Ruby version: 3.1.x
* Rails version: 6.x
* データベース: MySQL 8.0
* Node.js: 14.x
* Yarn: 最新版
* Docker
* Docker Compose

## セットアップ手順

### 通常のセットアップ
#### 依存関係のインストール
```bash
bundle install
```

#### データベース作成と初期化
```bash
rails db:create
rails db:migrate
```

#### テストの実行
```bash
bundle exec rspec
```

#### サーバーの起動
```bash
rails server
```

### Docker環境でのセットアップ
#### 最初のセットアップ
```bash
# コンテナのビルドと起動
docker compose build
docker compose up -d

# データベースの作成と初期化
docker compose exec web rails db:create
docker compose exec web rails db:migrate
```

#### 再構築時の手順
```bash
# コンテナとイメージを完全に削除
docker compose down --rmi all --volumes
docker system prune -a

# 再ビルドと起動
docker compose build
docker compose up -d
```

## 主な機能
- ユーザー登録・認証
- プロフィール作成
- マッチングアルゴリズム
- メッセージング

## 環境変数
以下の環境変数を `.env` ファイルに設定してください：
- `DATABASE_URL`
- `SECRET_KEY_BASE`

## デプロイ
Herokuへのデプロイを推奨しています。

## ライセンス
MITライセンス

## トラブルシューティング
### Docker環境での一般的な問題
- Bundlerのバージョンが一致しない場合は、Dockerfileで明示的にバージョンを指定してください
- Rubyのバージョンは`Gemfile`で指定されているバージョンと一致させてください

### Node.js・Yarn関連の注意点
- Node.js 14.xを使用しています（Rails 6.x/Webpacker 5.xとの互換性のため）
- Railsアプリケーションでは、Node.jsとYarnのバージョンが重要です
- 複雑な依存関係の問題が発生した場合は、Node.jsのバージョンの変更を検討してください

### ARM64（Apple Silicon）での注意点
- DockerfileとDocker Composeファイルで`--platform=linux/arm64`を指定しています
- `docker buildx`を使用して、マルチアーキテクチャビルドを行うことができます
- イメージのビルド時に互換性の問題が発生した場合は、以下のコマンドを試してください：
  ```bash
  docker buildx build --platform linux/arm64 -t myapp:latest .
  ```
- 最新のDocker Desktopにアップデートしてください

### 依存関係のクリーンアップ
ビルドに問題がある場合は、以下のコマンドを試してみてください：
```bash
# キャッシュとイメージの削除
docker compose down --rmi all --volumes
docker system prune -a

# 再ビルド
docker compose build
docker compose up -d
```

## Docker環境でのトラブルシューティング

### Gem依存関係の問題
- Gemfileの依存関係がインストールされない場合は、以下を試してみてください：
  ```bash
  # コンテナに接続して手動でインストール
  docker compose exec web bash
  bundle install --path vendor/bundle
  ```

- MySQLへの接続エラーが発生する場合は、以下を確認してください：
  ```bash
  # 環境変数の設定
  docker compose exec web bash
  echo $DATABASE_URL

  # データベースの作成
  docker compose exec web rails db:create
  docker compose exec web rails db:migrate
  ```

- ボリュームマウントの問題が発生した場合：
  ```bash
  # ボリュームの削除と再作成
  docker compose down -v
  docker compose up -d
  ```
