class bundler::install {
  # rubygem-bundler in fc16 or fc17
  # otherwise, rubygems
  # and "gem install bundler"
  package { ["ruby-devel",
             "gcc",
             "gcc-c++",
             "make"]: }

  if  $lsbdistid == 'RedHatEnterpriseServer' and $lsbmajdistrelease == '6' {
    package { ["rubygems"]: }
    exec { "gem install bundler":
         cwd => "/tmp",
        command => "/usr/bin/gem install bundler",
         require => Package["rubygems"],
	 unless =>  "/usr/bin/gem list bundler | grep -q bundler" }
  } else {
    package { ["rubygem-bundler"]: }
  }
}
