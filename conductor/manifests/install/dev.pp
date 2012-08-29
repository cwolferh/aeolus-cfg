class conductor::install::dev {
  if $conductor_branch != undef {
     $branch = $conductor_branch
  } else {
     $branch = 'master'
  }


  git::repo { conductor:
    src => 'git://github.com/aeolusproject',
    dst => '/tmp',
    branch => $branch
  }

  # converge-ui
  exec { "init submodule":
    cwd => "/tmp/conductor",
    command => "/usr/bin/git submodule init",
    require => Git::Repo[conductor]
  }
  exec { "update submodule":
    cwd => "/tmp/conductor",
    command => "/usr/bin/git submodule update",
    require => Exec["init submodule"]
  }  
}
