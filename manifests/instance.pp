define httpd::instance ( $instance = $title,
  $port                = '',
  $interface           = '0.0.0.0',
  $shortname           = '',
  $modules             = [],
  $pre_vhost_includes  = [],
  $post_vhost_includes = [],
  $php                 = $httpd::php,
  $passenger           = $httpd::passenger,
  $wsgi                = $httpd::wsgi,
  $security            = $httpd::security,
  $mpm                 = $httpd::params::mpm,
  $enabled             = true,
  $logrot_interval     = 'weekly',
  $logrot_minsize      = '10M',
  $conf_template       = $httpd::params::conf_template,
  $init_template       = $httpd::params::init_template,
  $logrot_template     = $httpd::params::logrot_template,
  $vhostconf           = $httpd::params::vhostconf,
  $logdir              = "${httpd::params::logdir}/${instance}",
  $prefix              = $httpd::params::prefix,
  $httpd_bin           = "${prefix}/bin/httpd"
){
  include 'httpd::params'
  include 'account::virtual'

  realize (
    Account::Systemgroup[$domain],
    Account::Hostinguser[$domain],
  )

  file { "${vhostconf}/${domain}":
    ensure => 'directory',
    owner  => 'root',
    group  => 'wheel',
  }
    

  # creates the configuration
  file { "${vhostconf}/${domain}/httpd.conf":
    content => template($conf_template),
    owner   => 'root',
    group   => 'wheel',
  }

  # creates the service -- doesn't manage the service yet!
  file { "/etc/init/httpd-${shortname}.conf":
    content => template($init_template),
    owner   => 'root',
    group   => 'root',
    require => [ Account::Systemgroup[$domain],
                Account::Hostinguser[$domain],
              ]
  }
  file { "/etc/init.d/httpd-${shortname}":
    ensure => link,
    target => '/lib/init/upstart-job',
  }

  # Don't let logs rot! Rotate them:
  # creates the service -- doesn't manage the service yet!
  file { "/etc/logrotate.d/httpd-${shortname}":
    content => template($logrot_template),
    owner   => 'root',
    group   => 'root',
  }
}
