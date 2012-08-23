class conductor ($dev = false) {
  if $dev {
    include conductor::install::dev
  } else {
    include conductor::install
  }
}
