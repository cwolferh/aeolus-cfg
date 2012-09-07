#!/bin/sh

# Setup a development environment for conductor, aeolus-image-rubygem
# and aeolus-cli.  Configure conductor to use an external
# imagefactory/iwhd/deltacloud by setting env variables and
# oauth.json, below.  Startup conductor on port 3000

if `netstat -tulpn | grep -q -P ':3000\s'`; then
    echo "A process is already listening on port 3000.  Aborting"
    exit 1
fi

if [ -e /tmp/conductor ] || [ -e /tmp/aeolus-image-rubygem ] || \
    [ -e /tmp/aeolus-cli ]; then
    echo -n "Already existing directories, one of /tmp/conductor, "
    echo "/tmp/aeolus-image-rubygem or /tmp/aeolus-cli.  Aborting"
    exit 1
fi


os=unsupported
if `grep -qs 'Red Hat Enterprise Linux Server release 6' /etc/redhat-release`; then
  os=rhel6
fi

if `grep -qs -P 'Fedora release 16' /etc/fedora-release`; then
  os=fc16
fi

if `grep -qs -P 'Fedora release 17' /etc/fedora-release`; then
  os=fc17
fi

if [ "$os" == "unsupported" ]; then
    echo This script has not been tested outside of RHEL6, FC16 and FC17.
    echo You will need to install development libraries and set up
    echo postgres manually.
    exit 1
fi

if [ "$os" == "fc16" ]; then
    yum -y install rubygem-json
fi

if [ "$os" == "rhel6" ]; then
    yum -y install gem rubygems
    echo '[epel]
name=Extra Packages for Enterprise Linux 6 - $basearch
#baseurl=http://download.fedoraproject.org/pub/epel/6/$basearch
mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=$basearch
failovermethod=priority
enabled=1
gpgcheck=0' > /tmp/epel.repo
    gem install json
    yum -y -c /tmp/epel.repo install puppet
else
    yum -y install puppet
fi

mkdir /etc/aeolus-conductor

# CONFIGURE YOUR SETTINGS FOR IWHD/IMAGEFACTORY/DELTACLOUD HERE
echo -n '{"factory":{"consumer_key":"B+mSIxE9ybAJTBmyxtCliasV4k4ZyWfv","consumer_secret":"XdVkxAxZLbUgFGfTeqiNLymm6p81XNf+"},"iwhd":{"consumer_key":"Flu3PwQjeg8ypbT7uCeu9bMRJatzHfOc","consumer_secret":"ZUrjoj4RFK0/71L+NkXCqsYnUTzeQdGT"}}' > /etc/aeolus-conductor/oauth.json
export FACTER_IWHD_URL=http://nec-em16.rhts.eng.bos.redhat.com:9090
export FACTER_DELTACLOUD_URL=http://nec-em16.rhts.eng.bos.redhat.com:3002/api
export FACTER_IMAGEFACTORY_URL=https://nec-em16.rhts.eng.bos.redhat.com:8075/imagefactory 

git clone https://github.com/cwolferh/aeolus-cfg.git
cd aeolus-cfg/
puppet apply -d --modulepath=. test.pp
