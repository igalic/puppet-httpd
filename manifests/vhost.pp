define httpd::vhost ( $domain = $title,
  $instance,
  $order,
  $remote_port         = '80',
  $remote_proto        = 'http',
  $type                = 'static',
  $conf_vhost_template = $httpd::params::conf_vhost_template,
  $vhostconf           = $httpd::params::vhostconf,
){
  include 'httpd::params'
  include 'concat::setup'

  unless ($order >= 100 and $order <= 90000) {
    fail ("Please supply a valid \$order. It must be between 100 and 9000.")
  }

  $subdomain = regsubst($domain, "(.*).${instance}$", '\1')

  # creates the configuration (fragment)
  $configfile = "${vhostconf}/${instance}/httpd.conf"
  concat::fragment { "${configfile}_$subdomain":
    target  => $configfile,
    content => template($conf_vhost_template),
    order   => $order,
  }
}
