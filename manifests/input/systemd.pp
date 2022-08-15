# @summary Input for reading messages from systemd-journald
define fluentbit::input::systemd (
  String $configfile                = "/etc/fluent-bit/input_systemd_${name}.conf",
  Stdlib::Absolutepath $db_dirname  = '/var/lib/fluent-bit',
  String $db_filename               = "input_systemd_${name}.db",
  Enum['On', 'Off', 'on', 'off']
    $read_from_tail                 = 'Off',
  Optional[String] $fluent_tag      = 'systemd.*',
  Enum['On', 'Off', 'on', 'off']
    $lowercase                      = 'On',
  Enum['On', 'Off', 'on', 'off']
    $strip_underscores              = 'On',
  Array[String] $units              = [],
  Array[String] $syslog_identifiers = [],
) {
  file { $db_dirname:
    ensure => directory,
    mode   => $fluentbit::config_file_mode,
  }

  ~> file { "${db_dirname}/${db_filename}":
    ensure => file,
    mode   => $fluentbit::config_file_mode,
  }

  ~> file { $configfile:
    ensure  => file,
    mode    => $fluentbit::config_file_mode,
    content => template('fluentbit/input/systemd.conf.erb'),
    notify  => Class['fluentbit::service'],
    require => Class['fluentbit::install'],
  }
}
