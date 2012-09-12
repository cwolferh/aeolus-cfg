
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

if $id == 'root' {
  # only install system dependencies
  class { conductor: dev => true }
} else {
  class { aeolus-image-rubygem: dev => true } -> class { conductor: dev => true }
  class { aeolus-cli: dev => true }
}
