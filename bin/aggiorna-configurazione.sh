#!/bin/bash

svn co https://svn.dapced.rm/monitoring TEMP
cd TEMP/bin

./aggiorna-test.sh

cd ../../
rm -rf TEMP

