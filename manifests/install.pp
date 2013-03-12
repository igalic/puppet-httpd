#
# Make sure httpd is installed. Since we heavily use mod_macro
# we want that in the base also.
#
class httpd::install {
  package { ['httpd', 'mod-macro' ]:
    ensure => latest,
  }

  # Additional third party modules:
  if $httpd::php {
    package { 'php':
      ensure => latest,
    }
    if $httpd::php_extensions {
      package { $httpd::php_extensions:
        ensure => latest,
      }
    }
  }
  if $httpd::passenger {
    package { 'passenger':
      ensure => latest,
    }
  }
  if $httpd::wsgi {
    package { 'mod-wsgi':
      ensure => latest,
    }
  }
  if $httpd::security {
    package { 'mod-security':
      ensure => latest,
    }
  }

  file { '/etc/bw/httpd/vhosts/':
    ensure => 'directory',
    owner  => 'root',
    group  => 'wheel',
  }
}
