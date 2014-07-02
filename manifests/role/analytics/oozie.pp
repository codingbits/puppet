# == Class role::analytics::oozie::client
# Installs oozie client, which sets up the OOZIE_URL
# environment variable.  If you are using this class in
# labs, you must include oozie::server on your primary
# Hadoop NameNode for this to work.
#
class role::analytics::oozie::client {
    # Need hadoop client before oozie client.
    Class['role::analytics::hadoop::client'] -> Class['role::analytics::oozie::client']

    # include common labs or production hadoop configs
    # based on $::realm
    if ($::realm == 'labs') {
        $oozie_host      = $role::analytics::hadoop::labs::namenode_hosts[0]
        $cdh_module_name = 'cdh'
    }
    else {
        $oozie_host      = 'analytics1027.eqiad.wmnet'
        $cdh_module_name = 'cdh4'
    }


    class { "${cdh_module_name}::oozie":
        oozie_host => $oozie_host,
    }

}

# == Class role::analytics::oozie::server
# Installs oozie server backed by a MySQL database.
#
class role::analytics::oozie::server inherits role::analytics::oozie::client {
    if (!defined(Package['mysql-server'])) {
        package { 'mysql-server':
            ensure => 'installed',
        }
    }
    # make sure mysql-server is installed before
    # we apply our MySQL Oozie database class.
    Package['mysql-server'] -> Class["${cdh_module_name}::oozie::database::mysql"]

    $jdbc_password = $::realm ? {
        'production' => $passwords::analytics::oozie_jdbc_password,
        'labs'       => 'oozie',
    }

    class { "${cdh_module_name}::oozie::server":
        jdbc_password   => $jdbc_password,
        smtp_host       => $::mail_smarthost[0],
        smtp_from_email => "oozie@$::fqdn",
    }
}
