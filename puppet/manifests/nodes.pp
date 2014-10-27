node default {
  class { 'php': }
  php::module { $php_modules: }
  txtcmdr::phpini { 'php': 
    service => 'httpd', 
    value => ['date.timezone = "UTC"', 'upload_max_filesize = 8M', 'short_open_tag = 0']
  }

/*
  class { 'composer':
    path    => $app_root,
    require => [Class['php'], Package['curl']]
  }
*/

  class { 'composer':
    command_name => 'composer',
    target_dir   => '/usr/bin',
    require => [Class['php'], Package['curl']]
  }

  txtcmdr::symfony { $app_root:
    require => Class['composer'],
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

  class { 'mysql::server':
    root_password => 'strongpassword',
    override_options => { 'mysqld' => { 'max_connections' => '1024' } },
  }

  class { 'mysql::bindings': php_enable => true }
  package { 'phpmyadmin':
    ensure => 'installed',
    require => [Class['php'], Class['mysql::server']]
  }
  mysql::db { $postfix_db:
    user     => $postfix_user,
    password => $postfix_pass,
    host     => $postfix_host,
    sql      => '/tmp/postfix.sql',
    require  => File['/tmp/postfix.sql'],
  }

  file { '/tmp/postfix.sql':
    ensure => present,
    source => 'puppet:///files/postfix.sql',
  }

  class { 'smstools': }

  class { 'resolver':
    dns_servers => ['172.16.0.2'],
  }

  class { 'bind': }

  bind::zone { 'txtcmdr.xyz':
    zone_type => 'master',
    zone_ns => 'txtcmdr.xyz.',
    zone_contact => 'root.txtcmdr.xyz.',
    zone_ttl => 604800,
    zone_serial => 2,
  }

  bind::ns { 'txtcmdr.xyz.':
    zone   => 'txtcmdr.xyz',
  }

  bind::mx { 'mail':
    zone   => 'txtcmdr.xyz',
    record_priority => 10,
  }

  bind::a { ' ':
    zone   => 'txtcmdr.xyz',
    target => '172.16.0.2',
  }

  bind::a { 'www':
    zone   => 'txtcmdr.xyz',
    target => '172.16.0.2',
  }

  class { '::postfix::server':
    mysql => true,
  }

  /*
  class { 'postfix::mastercf':
    source => 'puppet:///files/master.cf',
  }

  package { 'postfix-mysql':
    require => Class['postfix'],
  }

  file { '/etc/postfix/mysql-virtual-mailbox-domains.cf':
    ensure => present,
    source => 'puppet:///files/mysql-virtual-mailbox-domains.cf',
    notify => Class['postfix'],
  }

  file { '/etc/postfix/mysql-virtual-mailbox-maps.cf':
    ensure => present,
    source => 'puppet:///files/mysql-virtual-mailbox-maps.cf',
    notify => Class['postfix'],
  }

  file { '/etc/postfix/mysql-virtual-alias-maps.cf':
    ensure => present,
    source => 'puppet:///files/mysql-virtual-alias-maps.cf',
    notify => Class['postfix'],
  }
  */

  Firewall <||>
}
