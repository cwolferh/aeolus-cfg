class conductor::install::dev {
  if $conductor_branch != undef {
     $branch = $conductor_branch
  } else {
     $branch = 'master'
  }

  if $conductor_pull_request != undef {
     $pull_request = $conductor_pull_request
  }
  
  git::repo { conductor:
    src => 'git://github.com/aeolusproject',
    dst => '/tmp',
    branch => $branch,
    pull_request => $pull_request
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
