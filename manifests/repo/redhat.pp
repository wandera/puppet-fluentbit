# A description of what this class does
#
# @example
#   include fluentbit::repo::redhat
class fluentbit::repo::redhat {
  assert_private()

  $flavour = dig($facts, 'os', 'distro', 'id')
  $release = dig($facts, 'os', 'distro', 'codename')

  $supported = $flavour ? {
    'Amazon' => [
      'Karoo',
    ],
    default => [],
  }

  unless $release in $supported {
    fail("OS ${flavour}/${release} is not supported")
  }

  contain '::yum'

  $_flavour = downcase($flavour)

  if $flavour == 'Amazon' {
    $baseurl = "https://packages.fluentbit.io/amazonlinux/2/\$basearch/"
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
