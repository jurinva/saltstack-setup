#!/bin/bash

OS=$(lsb_release -si)
VER=$(lsb_release -sr)
PYVER=apt # if python2 then apt or yum else py3


function Uinstall() {
  wget -O - https://repo.saltstack.com/$PYVER/ubuntu/$VER/amd64/latest/SALTSTACK-GPG-KEY.pub
  deb http://repo.saltstack.com/$PYVER/ubuntu/$VER/amd64/latest $OS main
}

function Cinstall() {
  CVER=$(lsb_release -sr | head -c 1)
  if [ $PYVER == yum ]; then
    sudo yum install https://repo.saltstack.com/$PYVER/redhat/salt-repo-latest-2.el$CVER.noarch.rpm
  else sudo yum install https://repo.saltstack.com/$PYVER/redhat/salt-py3-repo-latest-2.el$CVER.noarch.rpm
  fi
  sudo yum clean expire-cache
}

function main() {
  case $OS in
    CentOS)
      Cinstall
    ;;
    Ubuntu)
      Uinstall
    ;;
  esac
}

main