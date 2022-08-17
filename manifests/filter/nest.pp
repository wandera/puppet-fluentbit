# @summary Plugin to manipulate structure of records (move maps deeper/lift them up).
define fluentbit::filter::nest (
  String $configfile                 = "/etc/fluent-bit/filter_${name}_nest.conf",
  String $match                      = '*',
  Enum['nest', 'lift'] $operation    = 'nest',
  Optional[Array[String]] $wildcards = [],
  Optional[String] $nest_under       = undef, # to be used with "nest" operation
  Optional[String] $nested_under     = undef, # to be used with "lift" operation
  Optional[String] $add_prefix       = undef,
  Optional[String] $remove_prefix    = undef,
) {
  file { $configfile:
    ensure  => file,
    mode    => '0644',
    content => template('fluentbit/filter/nest.conf.erb'),
    notify  => Class['fluentbit::service'],
    require => Class['fluentbit::install'],
  }
}
