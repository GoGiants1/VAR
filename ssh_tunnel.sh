#!/bin/bash

node=$1
port=${2:-"29165"}

ssh $node -L $port:localhost:$port

