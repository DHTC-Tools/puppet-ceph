define ceph::conf::osd (
  $device,
  $cluster_addr,
  $public_addr,
  $osd_journal,
) {

  concat::fragment { "ceph-osd-${name}.conf":
    target  => '/etc/ceph/ceph.conf',
    order   => '80',
    content => template('ceph/ceph.conf-osd.erb'),
  }

}
