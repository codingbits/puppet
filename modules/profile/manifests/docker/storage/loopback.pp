# == Class profile::docker::storage::loopback
#
# Sets up the storage for the devicemanager storage driver when
# a loopback device is used.
#
# Do NOT use for serving production traffic.
#
class profile::docker::storage::loopback {
    $dm_target_dir = '/var/lib/docker/devicemapper'
    $dm_source_dir = hiera('profile::docker::storage::loopback::source_dir', $dm_target_dir)

    Class['profile::docker::storage::loopback'] -> Service['docker']

    # This will be used in profile::docker::engine
    $options = {'storage-driver' => 'devicemapper'}

    file { $dm_target_dir:
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
    }


    if $dm_source_dir != $dm_target_dir {
        file { $dm_source_dir:
            ensure => directory,
            owner  => 'root',
            group  => 'root',
            mode   => '0755',
        }

        mount { $dm_target_dir:
            ensure  => mounted,
            device  => $dm_source_dir,
            fstype  => 'none',
            options => 'rw,bind',
        }
    }

}
