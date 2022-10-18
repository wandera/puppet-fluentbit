# @summary Plugin to forward logs to another fluentbit/fluentd instance
define fluentbit::output::forward (
  Stdlib::Absolutepath $configfile              = "/etc/fluent-bit/output_forward_${name}.conf",
  String $match                                 = '*',
  Stdlib::Host $host                            = '127.0.0.1',
  Stdlib::Port $port                            = 24240,
  Fluentbit::TLS $tls                           = {},
  Variant[Undef, Boolean, Integer[1]]
    $retry_limit                                = undef,
  Enum['On', 'Off', 'on', 'off'] $net_keepalive = 'On',
  Integer $net_keepalive_max_recycle            = 0,
  String $storage_total_limit_size              = '2G',
  Optional[Boolean] $compress,
  Optional[Boolean] $empty_shared_key,
  Optional[Boolean] $require_ack_response,
) {

  $tls_enabled = $tls['enabled'] ? {
    undef   => undef,
    default => bool2str($tls['enabled'], 'On', 'Off'),
  }
  $tls_verify = $tls['verify'] ? {
    undef   => undef,
    default => bool2str($tls['verify'], 'On', 'Off'),
  }
  $tls_debug = $tls['debug'] ? {
    undef   => undef,
    default => bool2str($tls['debug'], 'On', 'Off'),
  }
  $tls_ca_file = $tls['ca_file']
  $tls_ca_path = $tls['ca_path']
  $tls_crt_file = $tls['crt_file']
  $tls_key_file = $tls['key_file']
  $tls_key_passwd = $tls['key_passwd']
  $tls_vhost = $tls['vhost']

  file { $configfile:
    ensure  => file,
    mode    => $fluentbit::config_file_mode,
    content => template('fluentbit/output/forward.conf.erb'),
    notify  => Class['fluentbit::service'],
    require => Class['fluentbit::install'],
  }
}
