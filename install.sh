#!/bin/bash

OS=$(lsb_release -si)
VER=$(lsb_release -sr)
PYVER=apt # if python2 then apt or yum else py3

if [ $# -gt 0 ]; then
  while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
      -s|--server)
      ROLE="master"
      shift # past argument
      shift # past value
      ;;
      -c|--client)
      ROLE="minion"
      shift # past argument
      shift # past value
      ;;
      -p|--package)
      PKG="$2"
      shift # past argument
      shift # past value
      ;;
    esac
  done
fi

function role() {
  case $OS in
    Ubuntu)
      sudo apt install salt-$ROLE
    ;;
    CentOS)
      sudo yum install salt-$ROLE
    ;;
  esac
}

function pkginstall() {
  case $OS in
    Ubuntu)
      sudo apt install salt-$PKG
    ;;
    CentOS)
      sudo yum install salt-$PKG
    ;;
  esac
}

function Uinstall() {
  wget -O - https://repo.saltstack.com/$PYVER/ubuntu/$VER/amd64/latest/SALTSTACK-GPG-KEY.pub
  deb http://repo.saltstack.com/$PYVER/ubuntu/$VER/amd64/latest $OS main
  sudo apt update
  role
}

function Cinstall() {
  CVER=$(lsb_release -sr | head -c 1)
  if [ $PYVER == yum ]; then
    sudo yum install https://repo.saltstack.com/$PYVER/redhat/salt-repo-latest-2.el$CVER.noarch.rpm
  else sudo yum install https://repo.saltstack.com/$PYVER/redhat/salt-py3-repo-latest-2.el$CVER.noarch.rpm
  fi
  sudo yum clean expire-cache
  role
}

function main() {
  if [ ! -z "$ROLE" ]; then
    case $OS in
      CentOS)
        Cinstall
      ;;
      Ubuntu)
        Uinstall
      ;;
    esac
  else
    pkginstall
  fi
}

main