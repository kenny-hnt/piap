#!/bin/bash

rm -rf ./piap ; mkdir piap
git clone https://github.com/kenny-hnt/piap.git -b master ./piap

pushd piap 
sudo ./piap.sh
popd
