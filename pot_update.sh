#!/bin/bash

set -eu

source tx_token.sh
source common_variables.sh

if [ ! -d .tx ]; then
  echo 'ローカルプロジェクトを初期化'
  tx init --token=${TX_TOKEN} --force --no-interactive
  echo "リモートプロジェクトを設定"
  tx config mapping-remote https://www.transifex.com/projects/p/${TX_PROJECT}/
fi

echo "リモートプロジェクトからpoをバックアップ"
tx pull -l ja

echo "GitHubからpotをダウンロード"
if [ ! -d pot ]; then
  mkdir pot
fi
cd pot
for RESOURCE in ${WESNOTH_RESOURCES}
do
  wget -N https://raw.githubusercontent.com/wesnoth/wesnoth/1.16/po/${RESOURCE}/${RESOURCE}.pot
done
cd ../

echo 'ローカルプロジェクトに翻訳テンプレートファイルパスを設定'
for RESOURCE in ${WESNOTH_RESOURCES}
do
  tx config mapping -r ${TX_PROJECT}.${RESOURCE} --source-lang en --type PO --source-file pot/${RESOURCE}.pot --expression "translations/${TX_PROJECT}.${RESOURCE}/<lang>.po" --execute
done

echo 'リモートプロジェクトにpotの変更を適用'
tx push -s
