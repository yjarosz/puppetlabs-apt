class apt::params ($mirror = undef){
  $root           = '/etc/apt'
  $provider       = '/usr/bin/apt-get'
  $sources_list_d = "${root}/sources.list.d"
  $apt_conf_d     = "${root}/apt.conf.d"
  $preferences_d  = "${root}/preferences.d"

  case $::lsbdistid {
    'ubuntu', 'debian': {
      $distid = $::lsbdistid
      $distcodename = $::lsbdistcodename
    }
    'linuxmint': {
      if $::lsbdistcodename == 'debian' {
        $distid = 'debian'
        $distcodename = 'wheezy'
      } else {
        $distid = 'ubuntu'
        $distcodename = $::lsbdistcodename ? {
          'qiana'  => 'trusty',
          'petra'  => 'saucy',
          'olivia' => 'raring',
          'nadia'  => 'quantal',
          'maya'   => 'precise',
        }
      }
    }
    '': {
      fail('Unable to determine lsbdistid, is lsb-release installed?')
    }
    default: {
      fail("Unsupported lsbdistid (${::lsbdistid})")
    }
  }
  # choose a mirror
  class { '::apt::mirrors':
    mirror        => $mirror,
    distid        => $distid,
    distcodename  => $distcodename
  }
  $mirror = $apt::mirrors::mirror

  case $distid {
    'debian': {
      case $distcodename {
        'squeeze': {
          $backports_location = "${mirror}/debian-backports"
          $legacy_origin       = true
          $origins             = ['${distro_id} oldstable', #lint:ignore:single_quote_string_with_variables
                                  '${distro_id} ${distro_codename}-security', #lint:ignore:single_quote_string_with_variables
                                  '${distro_id} ${distro_codename}-lts'] #lint:ignore:single_quote_string_with_variables
        }
        'wheezy': {
          $backports_location = "${mirror}/debian/"
          $legacy_origin      = false
          $origins            = ['origin=Debian,archive=stable,label=Debian-Security',
                                  'origin=Debian,archive=oldstable,label=Debian-Security']
        }
        default: {
          $backports_location = "${mirror}/debian/"
          $legacy_origin      = false
          $origins            = ['origin=Debian,archive=stable,label=Debian-Security']
        }
      }
    }
    'ubuntu': {
      case $distcodename {
        'lucid': {
          $backports_location = "${mirror}/ubuntu"
          $ppa_options        = undef
          $legacy_origin      = true
          $origins            = ['${distro_id} ${distro_codename}-security'] #lint:ignore:single_quote_string_with_variables
        }
        'precise', 'trusty', 'utopic': {
          $backports_location = "${mirror}/ubuntu"
          $ppa_options        = '-y'
          $legacy_origin      = true
          $origins            = ['${distro_id}:${distro_codename}-security'] #lint:ignore:single_quote_string_with_variables
        }
        default: {
          $backports_location = "${mirror}/ubuntu"
          $ppa_options        = '-y'
          $legacy_origin      = true
          $origins            = ['${distro_id}:${distro_codename}-security'] #lint:ignore:single_quote_string_with_variables
        }
      }
    }
  }
}
