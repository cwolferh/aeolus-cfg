class conductor::setup::dev {
  require conductor::config::dev
  require bundler

  package { ["libxml2-devel" #nokogiri
            ]: }

  exec { "bundle install":
    cwd => "/tmp/conductor/src",
    command => "/usr/bin/bundle install --path bundle",
    logoutput => on_failure,
    require => Package[libxml2-devel]
  }
}
