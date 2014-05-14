node default {
  class { 'git': }

  package { ['python-software-properties']:
    ensure  => 'installed',
  }

  class { "apache": }

  apache::module { 'rewrite': }

  apache::vhost { 'default':
    docroot                  => $doc_root,
    directory                => $doc_root,
    directory_allow_override => "All",
    server_name              => false,
    priority                 => '000',
    template                 => 'txtcmdr/apache/vhost.conf.erb',
  }

  class { 'php': }

  php::module { $php_modules: }

  txtcmdr::phpini { 'php':
    value      => ['date.timezone = "UTC"','upload_max_filesize = 8M', 'short_open_tag = 0'],
  }

  class { 'mysql':
    root_password => 'root',
  }

  mysql::grant { $mysql_db:
    mysql_privileges     => 'ALL',
    mysql_db             => $mysql_db,
    mysql_user           => $mysql_user,
    mysql_password       => $mysql_pass,
    mysql_host           => $mysql_host,
    mysql_grant_filepath => '/home/vagrant/puppet-mysql',
  }

  package { 'phpmyadmin':
    require => Class[ 'mysql' ],
  }

  apache::vhost { 'phpmyadmin':
    server_name => false,
    docroot     => '/usr/share/phpmyadmin',
    port        => $pma_port,
    priority    => '10',
    require     => Package['phpmyadmin'],
    template    => 'txtcmdr/apache/vhost.conf.erb',
  }

}