class conductor::config::dev {
  require conductor::install::dev

  exec { "use sqlite gem":
    cwd => "/tmp/conductor/src",
    command => "/usr/bin/sed -i s/'pg'/'sqlite3'/ Gemfile"
  }

  exec { "sqlite database.yml":
    cwd => "/tmp/conductor/src",
    command => "/bin/cp config/database.sqlite config/database.yml",
  }
}
