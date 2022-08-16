# @summary custom filtering via Lua plugin
define fluentbit::filter::lua (
  String $configfile         = "/etc/fluent-bit/filter_${name}_lua.conf",
  String $match              = '*',
  String $script             = undef,
  String $call               = undef,
) {
  # TODO: concat for multiple entries
  file { $configfile:
    ensure  => file,
    mode    => '0644',
    content => template('fluentbit/filter/lua.conf.erb'),
    notify  => Class['fluentbit::service'],
    require => Class['fluentbit::install'],
  }
}
