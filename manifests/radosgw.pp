# Configure a ceph radosgw
#
# == Name
#   This resource's name is the mon's id and must be numeric.
# == Parameters
# [*fsid*] The cluster's fsid.
#   Mandatory. Get one with `uuidgen -r`.
#
# [*auth_type*] Auth type.
#   Optional. undef or 'cephx'. Defaults to 'cephx'.
#
# [*mds_data*] Base path for mon data. Data will be put in a mon.$id folder.
#   Optional. Defaults to '/var/lib/ceph/mds.
#
# == Dependencies
#
# none
#
# == Authors
#
#  Dan van der Ster daniel.vanderster@cern.ch
#
# == Copyright
#
# Copyright 2013 CERN
#

define ceph::radosgw (
  $monitor_secret
) {

  include 'ceph::package'
  include 'ceph::conf'
  include 'ceph::params'

  Package['ceph'] -> Ceph::Key <<| title == 'admin' |>>

  ensure_packages( [ 'ceph-radosgw' ] )

  ceph::conf::radosgw { $name: }

  exec { 'ceph-radosgw-keyring':
    command =>"ceph auth get-or-create client.radosgw.${::hostname} osd 'allow rwx' mon 'allow r' --name mon. --key=${monitor_secret} -o /etc/ceph/ceph.client.radosgw.${::hostname}.keyring",
    path    => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin',
    creates => "/etc/ceph/ceph.client.radosgw.${::hostname}.keyring",
    before  => Service["radosgw"],
    require => Package['ceph'],
  }

  file { '/etc/init.d/radosgw':
    ensure  => link,
    source  => '/etc/init.d/ceph-radosgw',
    require => Package['ceph'],
  }

  service { "radosgw":
    ensure    => running,
    provider  => $::ceph::params::service_provider,
    hasstatus => false,
    require   => [Exec['ceph-radosgw-keyring'], File['/etc/init.d/radosgw']],
  }
}
