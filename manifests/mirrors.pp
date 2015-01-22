class apt::mirrors ($distid, $distcodename, $mirror = undef){
  if $mirror == undef {
    case $distid {
      'debian': {
        case $distcodename {
          'squeeze': {
            $chosen_one = 'http://backports.debian.org'
          }
          'wheezy': {
            $chosen_one = 'http://ftp.debian.org'
          }
          default: {
            $chosen_one = 'http://http.debian.net'
          }
        }
      }
      'ubuntu': {
        case $distcodename {
          'lucid': {
            $chosen_one = 'http://us.archive.ubuntu.com'
          }
          'precise', 'trusty', 'utopic': {
            $chosen_one = 'http://us.archive.ubuntu.com'
          }
          default: {
            $chosen_one = 'http://old-releases.ubuntu.com'
          }
        }
      }
    }
  } else {
    $chosen_one = $mirror
  }
}
