class conductor::config::dev {
  require conductor::install::dev

  exec { "use sqlite gem":
    path => "/bin:/usr/bin",
    cwd => "/tmp/conductor/src",
    command => "sed -i s/'pg'/'sqlite3'/ Gemfile"
  }

  exec { "sqlite database.yml":
    cwd => "/tmp/conductor/src",
    command => "/bin/cp config/database.sqlite config/database.yml",
  }
}
