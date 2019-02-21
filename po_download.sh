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
PO_DIR="po"
MO_DIR="mo"

if [ ! -d .tx ]; then
  echo 'ローカルプロジェクトを初期化'
  tx init --token=${TX_TOKEN} --force --no-interactive
  echo "リモートプロジェクトを設定"
  tx config mapping-remote https://www.transifex.com/projects/p/${TX_PROJECT}/
fi

echo "リモートプロジェクトからpoをダウンロード"
tx pull -l ja

echo "poをwesnothソースコードと同様のディレクトリ構造に配置"
for RESOURCE in ${WESNOTH_RESOURCES}
do
  if [ ! -d ${PO_DIR}/${RESOURCE} ]; then
    mkdir -p ${PO_DIR}/${RESOURCE}
  fi 
  cp translations/${TX_PROJECT}.${RESOURCE}/ja.po ${PO_DIR}/${RESOURCE}/ja.po
done

echo "poをmoに変換"
for RESOURCE in ${WESNOTH_RESOURCES}
do
  if [ ! -d ${MO_DIR}/${RESOURCE} ]; then
    mkdir -p ${MO_DIR}/${RESOURCE}
  fi 
  msgfmt -o ${MO_DIR}/${RESOURCE}/ja.mo translations/${TX_PROJECT}.${RESOURCE}/ja.po
done
