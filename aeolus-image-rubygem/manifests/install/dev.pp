class aeolus-image-rubygem::install::dev {
  if $aeolus_image_rubygem_branch != undef {
     $branch = $aeolus_image_rubygem_branch
  } else {
     $branch = 'master'
  }

  git::repo { aeolus-image-rubygem:
    src => 'git://github.com/aeolusproject',
    dst => '/tmp',
    branch => $branch
  }
}
