#!/bin/bash

set -eu

source tx_token.sh

WESNOTH_RESOURCES="wesnoth \
                   wesnoth-ai \
                   wesnoth-anl \
                   wesnoth-aoi \
                   wesnoth-did \
                   wesnoth-dm \
                   wesnoth-dw \
                   wesnoth-editor \
                   wesnoth-ei \
                   wesnoth-help \
                   wesnoth-httt \
                   wesnoth-l \
                   wesnoth-lib \
                   wesnoth-low \
                   wesnoth-manpages \
                   wesnoth-manual \
                   wesnoth-multiplayer \
                   wesnoth-nr \
                   wesnoth-sof \
                   wesnoth-sota \
                   wesnoth-sotbe \
                   wesnoth-tb \
                   wesnoth-test \
                   wesnoth-thot \
                   wesnoth-trow \
                   wesnoth-tsg \
                   wesnoth-tutorial \
                   wesnoth-units \
                   wesnoth-utbs"
TX_PROJECT="wesnoth114"

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
  wget -N https://raw.githubusercontent.com/wesnoth/wesnoth/1.14/po/${RESOURCE}/${RESOURCE}.pot
done
cd ../

echo 'ローカルプロジェクトに翻訳テンプレートファイルパスを設定'
for RESOURCE in ${WESNOTH_RESOURCES}
do
  tx config mapping -r ${TX_PROJECT}.${RESOURCE} --source-lang en --type PO --source-file pot/${RESOURCE}.pot --expression "translations/${TX_PROJECT}.${RESOURCE}/<lang>.po" --execute
done

echo 'リモートプロジェクトにpotの変更を適用'
tx push -s
