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
  $conf_header_template = $httpd::params::conf_header_template,
  $init_template       = $httpd::params::init_template,
  $logrot_template     = $httpd::params::logrot_template,
  $confdir             = $httpd::params::confdir,
  $vhostconf           = $httpd::params::vhostconf,
  $logdir              = $httpd::params::logdir,
  $webdir              = $httpd::params::webdir,
  $prefix              = $httpd::params::prefix,
  $httpd_bin           = "${prefix}/bin/httpd"
){
  include 'httpd::params'
  include 'account::virtual'
  include 'concat::setup'

  realize (
    Account::Systemgroup[$instance],
    Account::Hostinguser[$instance],
  )

  # Create the target dir for the Configuration:
  file { "${vhostconf}/${instance}":
    ensure => 'directory',
    owner  => 'root',
    group  => 'wheel',
  }

  $configfile =  "${vhostconf}/${instance}/httpd.conf"

  # creates the configuration
  concat { $configfile:
    owner   => 'root',
    group   => 'wheel',
  }
  concat::fragment { "${configfile}_header":
    target  => $configfile,
    content => template($conf_header_template),
    order   => '00000',
  }

  unless $pre_vhost_includes == [] {
    concat::fragment { "${configfile}_pre_vhost_includes":
      target => $configfile,
      source => $pre_vhost_includes,
      order  => '00001',
    }
  }
  unless $post_vhost_includes == [] {
    concat::fragment { "${configfile}_post_vhost_includes":
      target => $configfile,
      source => $post_vhost_includes,
      order  => '99999',
    }
  }

  # creates the service -- doesn't manage the service yet!
  file { "/etc/init/httpd-${shortname}.conf":
    content => template($init_template),
    owner   => 'root',
    group   => 'root',
    require => [ Account::Systemgroup[$instance],
                Account::Hostinguser[$instance],
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

  service { "httpd-${shortname}":
    ensure      => running,
    provider    => 'upstart',
    require     => File[ "/etc/init.d/httpd-${shortname}" ],
    subscribe   => File[ $configfile ],
  }
}
