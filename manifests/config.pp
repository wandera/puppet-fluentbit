# @summary configures the main fluentbit main config
#
# Includes all [input] and [output] configs. (@include)
# Sets global variables (@set)
# Configures global [service] section
#
# @private
#   include fluentbit::config
class fluentbit::config {
  assert_private()

  File {
    ensure  => file,
    mode    => $fluentbit::config_file_mode,
    notify  => Class['fluentbit::service'],
  }

  $config_dir = dirname($fluentbit::config_file)

  if $fluentbit::manage_config_dir {
    file { $config_dir:
      ensure  => directory,
      purge   => true,
      recurse => true,
      mode    => '0755',
    }
  }

  if $fluentbit::manage_config_file {
    $flush = $fluentbit::flush
    $daemon = bool2str($fluentbit::daemon, 'On', 'Off')
    $log_file = $fluentbit::log_file
    $log_level = $fluentbit::log_level
    $parsers_file = $fluentbit::parsers_file
    $plugins_file = $fluentbit::plugins_file
    $streams_file = $fluentbit::streams_file
    $http_server = bool2str($fluentbit::http_server, 'On', 'Off')
    $http_listen = $fluentbit::http_listen
    $http_port = $fluentbit::http_port
    $coro_stack_size = $fluentbit::coro_stack_size
    $storage_path = $fluentbit::storage_path
    $storage_sync = $fluentbit::storage_sync
    $storage_checksum = bool2str($fluentbit::storage_checksum, 'On', 'Off')
    $storage_backlog_mem_limit = $fluentbit::storage_backlog_mem_limit
    $variables = $fluentbit::variables

    file { $fluentbit::config_file:
      content => template('fluentbit/fluent-bit.conf.erb'),
    }
  }

  if $fluentbit::manage_parsers_file {
    $parsers = $fluentbit::parsers

    file { $fluentbit::parsers_file:
      content => template('fluentbit/parsers.conf.erb'),
    }
  }

  if $fluentbit::manage_plugins_file {
    $plugins = $fluentbit::plugins

    file { $fluentbit::plugins_file:
      content => template('fluentbit/plugins.conf.erb'),
    }
  }

  if $fluentbit::manage_streams_file {
    $streams = $fluentbit::streams

    file { $fluentbit::streams_file:
      content => template('fluentbit/streams.conf.erb'),
    }
  }
}
