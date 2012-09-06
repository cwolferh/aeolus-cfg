class conductor::install::dev {
  # TODO, remove if block below, pushing this logic into repo.pp
  #  and use branch => $conductor_branch
  # i.e., if $conductor_branch is undef, repo.pp knows
  # to use "master"
  if $conductor_branch != undef {
     $branch = $conductor_branch
  } else {
     $branch = 'master'
  }

  git::repo { conductor:
    src => 'git://github.com/aeolusproject',
    dst => '/tmp',
    branch => $branch,
    pull_request => $conductor_pull_request
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
