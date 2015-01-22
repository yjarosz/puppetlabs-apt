class apt::mirrors ($distid, $distcodename, $mirror = undef){
  $mirror = $mirror
  if $mirror == undef {
    case $distid {
      'debian': {
        case $distcodename {
          'squeeze': {
            $mirror = 'http://backports.debian.org'
          }
          'wheezy': {
            $mirror = 'http://ftp.debian.org'
          }
          default: {
            $mirror = 'http://http.debian.net'
          }
        }
      }
      'ubuntu': {
        case $distcodename {
          'lucid': {
            $mirror = 'http://us.archive.ubuntu.com'
          }
          'precise', 'trusty', 'utopic': {
            $mirror = 'http://us.archive.ubuntu.com'
          }
          default: {
            $mirror = 'http://old-releases.ubuntu.com'
          }
        }
      }
    }
  }
}
