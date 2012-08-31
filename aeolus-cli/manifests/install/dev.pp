class aeolus-cli::install::dev {
  
  if $aeolus_cli_branch != undef {
     $branch = $aeolus_cli_branch
  } else {
     $branch = 'master'
  }

  if $aeolus_cli_pull_request != undef {
     $pull_request = $aeolus_cli_pull_request
  }

  git::repo { aeolus-cli:
    src => 'git://github.com/aeolusproject',
    dst => '/tmp',
    branch => $branch,
    pull_request => $pull_request
  }
}
