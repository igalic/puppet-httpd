# Class: apache::params
#
# This class manages basic Apache httpd parameters
#
class httpd::params {
  $conf_template   = 'httpd/vhost-default.conf.erb'
  $init_template   = 'httpd/init-httpd.conf.erb'
  $logrot_template = 'httpd/httpd-logrotate.erb'
  $prefix          = '/opt/bw'
  $confdir         = '/etc/bw/httpd'
  $vhostconf       = "${confdir}/vhosts"
  $logdir          = '/var/bwlog'
}
