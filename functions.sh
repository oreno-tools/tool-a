#!/usr/bin/env bash

# 画面出力用の関数
function incho() {
  printf "\e[34m$1\e[m\n"
}

function wacho() {
  printf "\e[33m$1\e[m\n"
}

# 処理の継続を確認する関数
function continue?() {
  while true; do
    read -p '処理を継続しますか? [Y/n]' Answer
    case $Answer in
      '' | [Yy]* )
        echo "処理を継続します."
        break
        ;;
      [Nn]* )
        echo "処理を中断します."
        exit 0
        ;;
      * )
        echo Please answer YES or NO.
        exit 0
    esac
  done;
}

# 使い方を出力する関数
function usage() {
  echo "Usage: ${CMDNAME} [config file path]" 1>&2
}

# 変数を外部ファイルから設定 (疑似 YAML ファイルから読み込む) する関数
function read_variables() {
  CONFIG_FILE=$1
  if [ -f ${CONFIG_FILE} ];then
    eval $(sed -e 's/:[^:\/\/]/="/g;s/$/"/g;s/ *=/=/g' ${CONFIG_FILE})
    incho "設定ファイルを読み込みました. 以下の変数が設定されています."
    echo "--------------------------------------------------------------------"
    echo APP_NAME=$(incho ${APP_NAME})
    echo REGION=$(incho ${REGION})
    echo DOCKERFILE_PATH=$(incho ${DOCKERFILE_PATH})
    echo IMAGE_NAME=$(incho ${IMAGE_NAME})
    # echo ECR_URI=$(aws sts get-caller-identity --query=Account --output=text).dkr.ecr.ap-northeast-1.amazonaws.com
    echo TARGET_ENV=$(incho ${TARGET_ENV})
    echo "--------------------------------------------------------------------"
    continue?
  else
    wacho "設定ファイルを読み込めません."
    exit 1
  fi
}
