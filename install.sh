#!/bin/bash

OS=$(lsb_release -si)
VER=$(lsb_release -sr)
CODENAME=$(lsb_release -sc)
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
      -m|--master)
      MASTER="$2"
      shift # past argument
      shift # past value
      ;;
    esac
  done
fi

function role() {
  case $OS in
    Ubuntu)
      sudo apt -y install salt-$ROLE
    ;;
    CentOS)
      sudo yum -y install salt-$ROLE
    ;;
  esac
}

function setup-minion() {
  sed -i "s/master: hostname_master/master: $MASTER/" /etc/salt/minion # need to check
}


function pkginstall() {
  case $OS in
    Ubuntu)
      sudo apt -y install salt-$PKG
    ;;
    CentOS)
      sudo yum -y install salt-$PKG
    ;;
  esac
}

function Uinstall() {
  wget -O - https://repo.saltstack.com/$PYVER/ubuntu/$VER/amd64/latest/SALTSTACK-GPG-KEY.pub
  echo "deb http://repo.saltstack.com/$PYVER/ubuntu/$VER/amd64/latest $CODENAME main" > /etc/apt/sources.list.d/saltstack.list
  sudo apt update
  role
}

function Cinstall() {
  CVER=$(lsb_release -sr | head -c 1)
  if [ $PYVER == yum ]; then
    sudo yum -y install https://repo.saltstack.com/$PYVER/redhat/salt-repo-latest-2.el$CVER.noarch.rpm
  else sudo yum -y install https://repo.saltstack.com/$PYVER/redhat/salt-py3-repo-latest-2.el$CVER.noarch.rpm
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