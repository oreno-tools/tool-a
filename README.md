# 俺のカンパニー tool-a

## これなに

* 俺のカンパニーの業務ツールサンプルです
* ツールの機能としては, Docker イメージをビルドして, Amazon ECR に push することが出来ます

## インストール

Amazon S3 からスクリプトを取得するか, Docker イメージを取得して下さい.

### Amazon S3 からスクリプトをインストール

```sh
curl -s https://s3-ap-northeast-1.amazonaws.com/oreno-company-tools/tool-a/setup.sh | bash
```

### Docker イメージを取得

```sh
docker pull $(aws sts get-caller-identity --query=Account --output=text).dkr.ecr.ap-northeast-1.amazonaws.com/oreno-docker-image/tool-a:latest
```

## 使い方

### 設定ファイルを擬似 YAML で書く

以下のような設定ファイルを書きます.

```yaml
APP_NAME: example
REGION: ap-northeast-1
DOCKERFILE_PATH: example/Dockerfile
IMAGE_NAME: oreno-docker-image/${APP_NAME}
ECR_URI: $(aws sts get-caller-identity --query=Account --output=text).dkr.ecr.ap-northeast-1.amazonaws.com
TARGET_ENV: lastest
```

設定ファイルの名前は任意の名前で構いませんが, Dockerfile 自体は `DOCKERFILE_PATH` に定義しているパスに存在している必要があります.

### docker-compose.yml を生成する

docker-compose を利用してスクリプトを実行する場合, 以下を実行して docker-compose.yml を生成しましょう.

```sh
./docker-compose.yml.sh > docker-compose.yml
```

### スクリプトを実行

以下のようにスクリプトを直接実行する方法と, docker-compose を使ってスクリプトを実行することが可能です.

```sh
# スクリプトを直接実行する場合
$ ~/bin/tool-a example/example.yml

# docker-compose で実行する場合
$ docker-compose run --rm tool-a example/example.yml
```
