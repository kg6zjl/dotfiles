#!/usr/bin/env bash

mkdir -p $HOME/go
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

go get -u github.com/kardianos/govendor
go get -u github.com/golang/lint/golint
go get -u golang.org/x/tools/cmd/godoc