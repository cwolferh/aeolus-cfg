
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

class { aeolus-image-rubygem: dev => true } -> class { conductor: dev => true }
class { aeolus-cli: dev => true }

