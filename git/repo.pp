define git::repo (
  $src = "",
  $dst = "",
  $branch = "master",
  ) {

  require git::install
  
  exec { "clone-repo-${name}":
    creates         => "${dst}/${name}/.git",
    path            => "/usr/bin:/bin:/usr/local/bin",
    command         => "git clone ${src}/${name} ${dst}/${name}",
    require         => Package["git"],
  }

  exec { "branch-repo-${name}-${branch}":
    cwd             => "$dst/$name",
    path            => "/usr/bin:/bin:/usr/local/bin",
    command         => "git checkout --track -b ${branch} origin/${branch}",
    unless          => "grep -q ${branch} ${dst}/${name}/.git/HEAD || ( ! ( git branch -r | grep origin/${branch} ) )",
    require         => Exec["clone-repo-${name}"],
  }
}
