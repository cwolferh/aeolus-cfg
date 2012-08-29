class aeolus-image-rubygem::setup::dev {
  require aeolus-image-rubygem::install::dev
  require bundler
  #exec { "bundle install":
  #  cwd => "/tmp/aeolus-image-rubygem/src", 
  #  command => "/usr/bin/bundle install --path bundle",
  #  logoutput => on_failure,
  #  #    require => Package[$dependencies]
  #}
  exec { "gem build aeolus-image.gemspec":
    cwd => "/tmp/aeolus-image-rubygem", 
    command => "/usr/bin/gem build aeolus-image.gemspec",
    logoutput => on_failure,
  }
}