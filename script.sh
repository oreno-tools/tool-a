#!/usr/bin/env bash

source ./functions.sh

# 引数のチェック
CMDNAME=$(basename $0)
if [ ! $# -eq 1 ]; then
  usage
  exit 1
fi

# 変数を外部ファイルから読み込む
incho "Step1. 変数を外部ファイルから読み込みます."
read_variables $1

# コンテナイメージをビルド
incho "Step2. Docker イメージをビルドします."
continue?
docker build -t ${IMAGE_NAME} -f ${DOCKERFILE_PATH} .
docker tag ${IMAGE_NAME} ${ECR_URI}/${IMAGE_NAME}:${TARGET_ENV}

# ECR にコンテナイメージを push する
incho "Step3. Docker イメージを ECR に push します."
continue?
aws ecr list-images --repository-name=${IMAGE_NAME} > /dev/null 2>&1
if [ ! $? -eq 0 ];then
  incho "ECR リポジトリ ${IMAGE_NAME} を作成します."
  continue?
  aws ecr create-repository --repository-name=${IMAGE_NAME}
  if [ ! $? -eq 0 ];then
    wacho "ECR リポジトリ ${IMAGE_NAME} の作成に失敗しました."
    exit 1
  else
    incho "ECR リポジトリ ${IMAGE_NAME} の作成に成功しました."
    continue?
  fi
fi
eval $(aws ecr get-login --no-include-email --region ${REGION})
docker push ${ECR_URI}/${IMAGE_NAME}:${TARGET_ENV} > /dev/null 2>&1
if [ $? -eq 0 ];then
  incho "ECR リポジトリへの push が完了しました."
else
  wacho "ECR リポジトリへの push が失敗しました."
fi
