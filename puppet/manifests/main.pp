$app_root     = '/vagrant'
$doc_root     = "$app_root/web"
$sys_packages = ['build-essential', 'curl', 'vim']
$php_modules  = ['imagick', 'curl', 'mysql', 'cli', 'intl', 'mcrypt', 'memcache']
$mysql_host   = 'localhost'
$mysql_db     = 'symfony'
$mysql_user   = 'symfony'
$mysql_pass   = 'password'
$pma_port     = 8000
$postfix_db   = 'mailserver'
$postfix_user = 'mailuser'
$postfix_pass = 'mailpassword'
$postfix_host = 'localhost'

Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

File { owner => 0, group => 0, mode => 0644 }

stage { 'first': }
stage { 'last': }
Stage['first'] -> Stage['main'] -> Stage['last']

import 'basic.pp'
import 'nodes.pp'

class{'basic':
  stage => first
}