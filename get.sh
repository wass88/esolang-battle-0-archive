#!/bin/bash
wget -r -np \
     --page-requisites \
     --convert-links \
     --quiet --show-progress \
     --no-host-directories http://esolang-0.wass80.xyz/contests/komabasai2018-day1 \
     -P gh-page

cp ~/Documents/esolang-battle/esolang-battole-0-archive/gh-page/css/{main.css?*,main.css}

wget --convert-links http://esolang-0.wass80.xyz/contests/komabasai2018-day1 -O gh-page/contests/komabasai2018-day1/index.html
wget --convert-links http://esolang-0.wass80.xyz/contests/komabasai2018-day1/submissions -O gh-page/contests/komabasai2018-day1/submissions/index.html

