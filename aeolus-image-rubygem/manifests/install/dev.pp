class aeolus-image-rubygem::install::dev {
  if $aeolus_image_rubygem_branch != undef {
     $branch = $aeolus_image_rubygem_branch
  } else {
     $branch = 'master'
  }

  if $aeolus_image_rubygem_pull_request != undef {
     $pull_request = $aeolus_image_rubygem_pull_request
  }

  git::repo { aeolus-image-rubygem:
    src => 'git://github.com/aeolusproject',
    dst => '/tmp',
    branch => $branch,
    pull_request => $pull_request
  }
}
