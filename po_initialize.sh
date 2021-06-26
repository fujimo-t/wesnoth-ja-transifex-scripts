#!/bin/bash

# GitHubからpoをダウンロードしてTransifexにpush
# 新バージョン用Transifexプロジェクトで最初にpot_update.shを実行した後に、前バージョンの翻訳を適用するためにこれを使う

set -eu

source common_variables.sh

echo "リモートプロジェクトからpoをバックアップ"

echo "GitHubからpoをダウンロード"
for RESOURCE in ${WESNOTH_RESOURCES}
do
  cd translations/${TX_PROJECT}.${RESOURCE}/
  wget -N https://raw.githubusercontent.com/wesnoth/wesnoth/1.16/po/${RESOURCE}/ja.po
  cd ../../
done

echo 'リモートプロジェクトにpoをpush'
tx push -t
