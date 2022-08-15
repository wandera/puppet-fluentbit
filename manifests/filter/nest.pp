define fluentbit::filter::nest (
  String $wildcard,
  String $nest_under,
  String $configfile         = "/etc/fluent-bit/filter_nest_${name}.conf",
  String $match              = '*',
  String $operation          = 'nest',
) {
  file { $configfile:
    ensure  => file,
    mode    => '0644',
    content => template('fluentbit/filter/nest.conf.erb'),
    notify  => Class['fluentbit::service'],
    require => Class['fluentbit::install'],
  }
}
