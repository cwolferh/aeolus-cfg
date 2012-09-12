aeolus-cfg
==========

Next generation approach for installing Aeolus, using Puppet.

As the root user on a box you want to install Aeolus on, run:

    # curl https://raw.github.com/cwolferh/aeolus-cfg/master/bootstrap.sh | /bin/sh

This should work on rhel6, fc16 and fc17 (the script's env variables +
oauth.json are pointing to existing imagefactory/iwhd/deltacloud
instances).
