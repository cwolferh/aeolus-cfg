class bundler::install {

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
