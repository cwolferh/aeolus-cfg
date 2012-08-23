class conductor::install::dev {
  git::repo { conductor:
    src => 'git://github.com/aeolusproject',
    dst => '/tmp'
  }
}
