# A description of what this class does
#
# @example
#   include fluentbit::repo::redhat
class fluentbit::repo::redhat {
  assert_private()

  $flavour = dig($facts, 'operatingsystem')
  $release = dig($facts, 'operatingsystemmajrelease')

  $supported = $flavour ? {
    'Amazon' => [
      '2',
    ],
    default => [],
  }

  unless $release in $supported {
    fail("OS ${flavour}/${release} is not supported")
  }

  contain '::yum'

  if $flavour == 'Amazon' {
    $baseurl = "https://packages.fluentbit.io/amazonlinux/${release}/\$basearch/"
  } else {
    fail("OS ${family}/${os_name} is not supported")l
  }


  yumrepo { 'fluentbit':
    descr         => 'Official Treasure Data repository for Fluent-Bit',
    gpgkey        => 'https://packages.fluentbit.io/fluentbit.key',
    baseurl       => $baseurl,
    enabled       => '1',
    gpgcheck      => '1',
    repo_gpgcheck => '0',
  }

  Yumrepo['fluentbit'] -> Package['fluentbit']
}
