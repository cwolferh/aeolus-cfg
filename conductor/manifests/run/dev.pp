class conductor::run::dev {
  require conductor::setup::dev

  exec { "conductor rails server":
    cwd => "${aeolus_workdir}/conductor/src",
    #    command => 'bundle exec "rails server --daemon"',
    command => 'bundle exec "rails server"&',
    unless => '/usr/bin/curl http://0.0.0.0:3000/'
  }
}
