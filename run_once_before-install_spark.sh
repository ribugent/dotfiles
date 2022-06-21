#!/bin/bash

[ -d ~/local/spark-3.2.1-bin-hadoop2.7 ] && exit 0

mkdir ~/local/spark-3.2.1-bin-hadoop2.7
curl -L https://dlcdn.apache.org/spark/spark-3.2.1/spark-3.2.1-bin-hadoop2.7.tgz | tar -xz --strip-components=1 -C ~/local/spark-3.2.1-bin-hadoop2.7
