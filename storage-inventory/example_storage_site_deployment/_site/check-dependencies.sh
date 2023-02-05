#!/bin/bash

echo "Checking for docker..."
which docker
if [ $? -ne 0 ]; then
  echo "**** No docker installation found in path."
fi

echo ""
echo "Checking for docker-compose..."
which docker-compose
if [ $? -ne 0 ]; then
  echo "**** No docker-compose found in path."
fi
