class conductor::install::dev {
  git::repo { conductor:
    src => 'git://github.com/aeolusproject',
    dst => '/tmp'
  }

  # converge-ui
  exec { "init submodule":
    cwd => "/tmp/conductor"
    command => "/usr/bin/git submodule init"
    require => Git::Repo[conductor]
  }
  exec { "update submodule":
    cwd => "/tmp/conductor"
    command => "/usr/bin/git submodule update"
    requier => Exec["init submodule"]
  }  
}
