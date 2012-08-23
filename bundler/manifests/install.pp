class bundler::install {
  package { ["rubygem-bundler",
             "ruby-devel",
             "gcc",
             "gcc-c++",
             "make"]: }
}
