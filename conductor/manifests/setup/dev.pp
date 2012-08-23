class conductor::setup::dev {
  require conductor::config::dev

  package { rubygem-bundler: }

  exec { "bundle install":
    cwd => "/tmp/conductor/src",
    command => "/usr/bin/bundle install --path bundle",
    require => Package[rubygem-bundler]
  }
}
