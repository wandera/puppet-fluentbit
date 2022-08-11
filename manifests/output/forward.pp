# @summary Plugin to output logs to a configured elasticsearch instance
#
# @param configfile
#  Path to the output configfile. Naming should be output_*.conf to make sure
#  it's getting included by the main config.
# @param match
#  Tag to route the output.
# @param tls
#  Turn TLS encrypted communication with Elasticsearch on / off.
# @param host
#  IP address or hostname of the target Elasticsearch instance
# @param port
#  TCP port of the target Elasticsearch instance
# @param path
#  Elasticsearch accepts new data on HTTP query path "/_bulk".
#  But it is also possible to serve Elasticsearch behind a reverse proxy on a subpath.
#  This option defines such path on the fluent-bit side.
#  It simply adds a path prefix in the indexing HTTP POST URI.
# @param buffer_size
#  Specify the buffer size used to read the response from the Elasticsearch HTTP service.
#  This option is useful for debugging purposes where is required to read full responses,
#  note that response size grows depending of the number of records inserted.
#  To set an unlimited amount of memory set this value to False,
#  otherwise the value must be according to the Unit Size specification.
# @param pipeline
#  Newer versions of Elasticsearch allows to setup filters called pipelines.
#  This option allows to define which pipeline the database should use.
#  For performance reasons is strongly suggested to do parsing and filtering
#  on Fluent Bit side, avoid pipelines.
# @param http_user
#  Optional username credential for Elastic X-Pack access
# @param http_passwd
#  Password for user defined in HTTP_User
# @param index
#  Index name
# @param type
#  Type name
# @param logstash_format
#  Enable Logstash format compatibility.
# @param logstash_prefix
#  When Logstash_Format is enabled, the Index name is composed using a prefix
#  and the date, e.g: If Logstash_Prefix is equals to 'mydata' your index will
#  become 'mydata-YYYY.MM.DD'. The last string appended belongs to the date
#  when the data is being generated.
# @param logstash_dateformat
#  Time format (based on strftime) to generate the second part of the Index name.
# @param time_key
#  When Logstash_Format is enabled, each record will get a new timestamp field.
#  The Time_Key property defines the name of that field.
# @param time_key_format
#  When Logstash_Format is enabled, this property defines the format of the timestamp.
# @param include_tag_key
#  When enabled, it append the Tag name to the record.
# @param tag_key
#  When Include_Tag_Key is enabled, this property defines the key name for the tag.
# @param generate_id
#  When enabled, generate _id for outgoing records. This prevents duplicate records when retrying ES.
# @param replace_dots
#  When enabled, replace field name dots with underscore, required by Elasticsearch 2.0-2.3.
# @param trace_output
#  When enabled print the elasticsearch API calls to stdout (for diag only)
# @param current_time_index
#  Use current time for index generation instead of message record
# @param logstash_prefix_key
#  Prefix keys with this string
# @param aws_auth
# Enable AWS Sigv4 Authentication for Amazon ElasticSearch Service (On/Off)
# @param aws_region
# Specify the AWS region for Amazon ElasticSearch Service
# @param aws_sts_endpoint
# Specify the custom sts endpoint to be used with STS API for Amazon ElasticSearch Service
# @param aws_role_arn
# AWS IAM Role to assume to put records to your Amazon ES cluster
# @param aws_external_id
# External ID for the AWS IAM Role specified with aws_role_arn

# @example
#  include fluentbit::output::forward
define fluentbit::output::forward (
  Stdlib::Absolutepath $configfile              = "/etc/fluent-bit/output_forward_${name}.conf",
  String $match                                 = '*',
  Stdlib::Host $host                            = '127.0.0.1',
  Stdlib::Port $port                            = 24240,
  Fluentbit::TLS $tls                           = {},
  Bool $empty_shared_key                        = True,
  Variant[Undef, Boolean, Integer[1]]
    $retry_limit                                = undef,
  Enum['On', 'Off', 'on', 'off'] $net_keepalive = 'On',
  Integer $net_keepalive_max_recycle            = 0,
  String $storage_total_limit_size              = '2G',
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
