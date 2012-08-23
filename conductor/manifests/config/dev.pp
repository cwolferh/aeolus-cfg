class conductor::config::dev {
  require conductor::install::dev

  exec { "use sqlite":
    cwd => "/tmp/conductor/src",
    command => "/usr/bin/sed -i s/'pg'/'sqlite3'/ Gemfile"
  }
}
