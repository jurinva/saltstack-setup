SALTSTACK-SETUP
=======

**saltstack-setup** - install and setup tool for saltstack.

SYNOPSIS
========

**install.sh** \[**-s**|**--server**] \[**-c**|**--client**] \[**-p**|**--package** package]
**install.sh** \[**-h**|**--help**|**-v**|**--version**]

DESCRIPTION
===========

Utility to migrate svn repository to git.

OPTIONS
-------

-s, --server  
:    Install and setup master

-c, --client  
:    Install and setup minion

-p, --package  
:    Install packages ssh syndic cloud api

BUGS
====

See GitHub Issues: <https://github.com/jurinva/saltstack-setup/issues>

EXAMPLE
=======
```bash
install.sh -p ssh
```

AUTHOR
======

Vladimir Yurin <jurinva@gmail.com>
