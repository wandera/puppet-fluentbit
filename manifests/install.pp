# @summary Installs fluentbit package
#
# @private
class fluentbit::install {
  assert_private()

  package{ 'fluentbit':
    ensure => $fluentbit::package_ensure,
    mark   => $fluentbit::package_mark,
    name   => $fluentbit::package_name,
  }
}
