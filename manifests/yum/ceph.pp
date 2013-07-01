class ceph::yum::ceph (
  $release = 'cuttlefish'
) {
  file { '/etc/pki/rpm-gpg/RPM-GPG-KEY-CEPH':
    source => 'https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc',
    replace => false,
  }
  yumrepo { "ceph":
    descr   => "Ceph $release repository",
    baseurl => "http://ceph.com/rpm-$release/el6/x86_64/",
    gpgkey   => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CEPH",
    gpgcheck=> 1,
    enabled => 1,
    require  => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-CEPH'],
    before   => Package['ceph'],
  }
}
