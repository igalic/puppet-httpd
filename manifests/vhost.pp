define httpd::vhost ( 
  $port                = '80',
  $proto               = 'http',
  $type                = 'static',
  $manage_dir          = 'all',
  $order               = '',
  $conf_vhost_template = $httpd::params::conf_vhost_template,
  $vhostconf           = $httpd::params::vhostconf,
){
  include 'httpd::params'
  include 'concat::setup'

  validate_re ($title, '[|]')
  validate_re ($proto, 'https?')
  validate_re ($manage_dir, 'all|none|htdocs|docroot|webroot|phpdirs')

  $domain = split($title, '[|]')
  $subdomain = $domain[0]
  $instance  = $domain[1]



  if $order == '' {
    $order_real = 100
  } else {
    $order_real = $order
  }
  unless ($order_real >= 100 and $order_real <= 90000) {
    fail ("Please supply a valid \$order. It must be between 100 and 9000.")
  }

  if $proto == 'https' {
    $remote_proto  = $proto
    if $port == '80' {
      $remote_port = 443
    } else {
      $remote_port = $port
    }
  } else {
    $remote_proto = $proto
    $remote_port  = $port
  }

  # creates the configuration (fragment)
  $configfile = "${vhostconf}/${instance}/httpd.conf"
  concat::fragment { "${configfile}_$subdomain":
    target  => $configfile,
    content => template($conf_vhost_template),
    order   => $order_real,
  }

  $webroot = "${httpd::params::webdir}/${instance}/${subdomain}"
  if 'all' in $manage_dir or 'webroot' in $manage_dir {
    file { $webroot:
      owner  => 'root',
      group  => 'wheel',
      ensure => 'directory',
    }
  }
  if 'all' in $manage_dir or 'docroot' in $manage_dir or 'htdocs' in $manage_dir {
    file { "${webroot}/htdocs":
      owner   => 'root',
      group   => 'wheel',
      ensure  => 'directory',
    }
  }

  if 'PHP' in $type and ( 'all' in $manage_dir or 'phpdirs' in $manage_dir) {
    file {[
      "${webroot}/tmp",
      "${webroot}/logs",
      "${webroot}/session",
    ]:
      owner   => $instance,
      group   => $instance,
      ensure  => 'directory',
    }
  }
}
