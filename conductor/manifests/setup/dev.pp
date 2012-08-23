class conductor::setup::dev {
  require conductor::config::dev
  require bundler

  exec { "bundle install":
    cwd => "/tmp/conductor/src",
    command => "/usr/bin/bundle install --path bundle",
  }
}
