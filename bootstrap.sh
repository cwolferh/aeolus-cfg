#!/bin/sh

# Setup a development environment for conductor, aeolus-image-rubygem
# and aeolus-cli.  Configure conductor to use an external
# imagefactory/iwhd/deltacloud by setting env variables and
# oauth.json, below.  Startup conductor on port 3000

# Set the default user to check out repos with, if not requested
if [ "x$DEV_USERNAME" = "x" ]; then
  export DEV_USERNAME=test
fi

# Where the aeolus projects (conductor, aeolus-cli and aeolus-image-rubygem)
# get checked out to
if [ "x$FACTER_AEOLUS_WORKDIR" = "x" ]; then
    export FACTER_AEOLUS_WORKDIR=/tmp/$DEV_USERNAME
fi

# Where aeolus-cfg gets checked out to
export WORKDIR=$FACTER_AEOLUS_WORKDIR

if `netstat -tlpn | grep -q -P ':3000\s'`; then
    echo "A process is already listening on port 3000.  Aborting"
    exit 1
fi

if [ -e $FACTER_AEOLUS_WORKDIR/conductor ] || [ -e $FACTER_AEOLUS_WORKDIR/aeolus-image-rubygem ] || \
    [ -e $FACTER_AEOLUS_WORKDIR/aeolus-cli ]; then
    echo -n "Already existing directories, one of $FACTER_AEOLUS_WORKDIR/conductor, "
    echo "$FACTER_AEOLUS_WORKDIR/aeolus-image-rubygem or $FACTER_AEOLUS_WORKDIR/aeolus-cli.  Aborting"
    exit 1
fi

os=unsupported
if `grep -Eqs 'Red Hat Enterprise Linux Server release 6|CentOS release 6' /etc/redhat-release`; then
  os=el6
fi

if `grep -qs -P 'Fedora release 16' /etc/fedora-release`; then
  os=f16
fi

if `grep -qs -P 'Fedora release 17' /etc/fedora-release`; then
  os=f17
fi

if [ "$os" = "unsupported" ]; then
    echo This script has not been tested outside of EL6, Fedora 16
    echo and Fedora 17. You will need to install development
    echo libraries and set up postgres manually.
    echo
    echo Press Control-C to quit, or ENTER to continue
    read waiting
fi

# Check if gcc rpm is installed
if ! `rpm -q --quiet gcc`; then
    yum install -y gcc
fi

# Check if make rpm is installed
if ! `rpm -q --quiet make`; then
    yum install -y make
fi

# Check if git rpm is installed
if ! `rpm -q --quiet git`; then
    yum install -y git
fi

# Check if rubygems rpm is installed
if ! `rpm -q --quiet rubygems`; then
    yum install -y rubygems
fi

# Check if ruby-devel rpm is installed
if ! `rpm -q --quiet ruby-devel`; then
    yum install -y ruby-devel
fi

# Install the json and puppet gems if they're not already installed
if [ `gem list -i json` = "false" ]; then
    echo Installing json gem
    gem install json
fi
if [ `gem list -i puppet` = "false" ]; then
    echo Installing puppet gem
    gem install puppet
fi

# Set default Deltacloud, ImageFactory, and Image Warehouse values
# (for RH network) if they're not already in the environment
if [ "x$FACTER_IWHD_URL" = "x" ]; then
    export FACTER_IWHD_URL=http://nec-em16.rhts.eng.bos.redhat.com:9090
fi
if [ "x$FACTER_DELTACLOUD_URL" = "x" ]; then
    export FACTER_DELTACLOUD_URL=http://nec-em16.rhts.eng.bos.redhat.com:3002/api
fi
if [ "x$FACTER_IMAGEFACTORY_URL" = "x" ]; then
    export FACTER_IMAGEFACTORY_URL=https://nec-em16.rhts.eng.bos.redhat.com:8075/imagefactory
fi

# Create some default OAuth values
mkdir -p /etc/aeolus-conductor
echo -n '{"factory":{"consumer_key":"B+mSIxE9ybAJTBmyxtCliasV4k4ZyWfv","consumer_secret":"XdVkxAxZLbUgFGfTeqiNLymm6p81XNf+"},"iwhd":{"consumer_key":"Flu3PwQjeg8ypbT7uCeu9bMRJatzHfOc","consumer_secret":"ZUrjoj4RFK0/71L+NkXCqsYnUTzeQdGT"}}' > /etc/aeolus-conductor/oauth.json

# Optional environment variables (sample values are given below)
#
# Note that master is the default branch cloned from each of the three
# projects if a _BRANCH is not specified.
#
# FACTER_AEOLUS_CLI_BRANCH=0.5.x
# FACTER_AEOLUS_IMAGE_RUBYGEM_BRANCH=0.3-maint
# FACTER_CONDUCTOR_BRANCH=0.10.x
#
# Pull requests must be integers
#
# FACTER_AEOLUS_CLI_PULL_REQUEST=6
# FACTER_AEOLUS_IMAGE_RUBYGEM_PULL_REQUEST=7
# FACTER_CONDUCTOR_PULL_REQUEST=47
#
mkdir -p $WORKDIR
cd $WORKDIR
if [ -d aeolus-cfg ]; then
 rm -rf aeolus-cfg
fi
chown $DEV_USERNAME $WORKDIR
su $DEV_USERNAME -c "git clone https://github.com/cwolferh/aeolus-cfg.git"

# First run as root to install needed dependencies
cd aeolus-cfg
puppet apply -d --modulepath=. test.pp

# Run same command as a non-root user (e.g., test) to install repos,
# configure and start up conductor
su $DEV_USERNAME -c "puppet apply -d --modulepath=. test.pp"
