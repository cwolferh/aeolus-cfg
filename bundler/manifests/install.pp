class bundler::install {
  package { ["rubygem-bundler",
             "ruby-devel",
             "gcc"]: }
}
