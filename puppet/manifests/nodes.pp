node default {
  class { 'php': }
  php::module { $php_modules: }
  txtcmdr::phpini { 'php': 
    service => 'httpd', 
    value => ['date.timezone = "UTC"', 'upload_max_filesize = 8M', 'short_open_tag = 0']
  }

  class { 'composer':
    path    => $app_root,
    require => [Class['php'], Package['curl']]
  }

  class { 'apache':
    default_mods        => false,
    default_confd_files => false,
    default_vhost       => false,
    mpm_module          => 'prefork' 
  }
  include apache::mod::prefork
  include apache::mod::rewrite
  class { '::apache::mod::php': package_name => 'php' }
  apache::vhost { $::fqdn:
    port    => '80',
    docroot => $doc_root,
    require => Class['composer']
  }
  apache::vhost { 'phpmyadmin':
    docroot  => '/usr/share/phpmyadmin',
    port     => $pma_port,
    priority => '10',
    require  => Package['phpmyadmin'],
  }

  class { 'mysql::server': root_password => 'strongpassword' }
  class { 'mysql::bindings': php_enable => true }
  package { 'phpmyadmin': 
    ensure => 'installed', 
    require => [Class['php'], Class['mysql::server']
  }

  class { 'smstools': }

  Firewall <||>
}