# == Class: httpd
#
# Full description of class httpd here.
#
# === Parameters
#
# Document parameters here.
#
# [*$php*]
#   whether to install PHP as dependency. Default true.
#
# [*$php_extensions*]
#   Array of PHP extensions to install. Default: none.
#
# [*$passenger*]
#   whether to install passenger as dependency. Default false.
#
# [*$wsgi*]
#   whether to install mod_wsgi as dependency. Default false.
#
# [*$security*]
#   whether to install mod_security as dependency. Default false.
#
# === Examples
#
#  class { httpd:
#    passenger => true,
#  }
#
# === Authors
#
# Brainsware <dev@brainsware.org>
#
# === Copyright
#
# Copyright 2013 Brainsware
#
class httpd (
  $php            = true,
  $passenger      = false,
  $wsgi           = false,
  $security       = false,
  $php_extensions = [],
) {
  include 'httpd::params'
  include 'httpd::install'

  anchor { 'httpd::start': } ->
  Class['httpd::params'] ->
  Class['httpd::install'] ->
  anchor { 'httpd::end': }
}
