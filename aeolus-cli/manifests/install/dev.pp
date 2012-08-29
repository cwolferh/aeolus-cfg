class aeolus-cli::install::dev {
  
  if $aeolus_cli_branch != undef {
     $branch = $aeolus_cli_branch
  } else {
     $branch = 'master'
  }

  git::repo { aeolus-cli:
    src => 'git://github.com/aeolusproject',
    dst => '/tmp',
    branch => $branch
  }
}
