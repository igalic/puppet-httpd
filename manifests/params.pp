# Class: apache::params
#
# This class manages basic Apache httpd parameters
#
class httpd::params {
  $conf_header_template  = 'httpd/httpd.conf_header.erb'
  $conf_vhost_template   = 'httpd/vhost.conf.erb'
  $init_template   = 'httpd/init-httpd.conf.erb'
  $logrot_template = 'httpd/httpd-logrotate.erb'
  $prefix          = '/opt/bw'
  $confdir         = '/etc/bw/httpd'
  $vhostconf       = "${confdir}/vhosts"
  $logdir          = '/var/bwlog'
  $webdir          = '/srv/web'
  $mpm             = 'worker'
}
