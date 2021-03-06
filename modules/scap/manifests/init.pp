# == Class: scap
#
# Common role for scap masters and targets
#
# == Parameters:
#  [*deployment_server*]
#    Server that provides git repositories for scap3. Default 'deployment'.
#
#  [*wmflabs_master*]
#    Master scap rsync host in the wmflabs domain.
#    Default 'deployment-tin.deployment-prep.eqiad.wmflabs'.
class scap (
    $deployment_server = 'deployment',
    $wmflabs_master = 'deployment-tin.deployment-prep.eqiad.wmflabs',
    $version = '3.6.0-2',
) {
    package { 'scap':
        ensure => $version,
    }

    file { '/etc/scap.cfg':
        content => template('scap/scap.cfg.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0444',
    }

    require_package([
        'python-psutil',
        'python-netifaces',
        'python-yaml',
        'python-requests',
        'python-jinja2',
    ])

    # Using straight up package resource here instead
    # of require_package so that I can specify version.
    if !defined(Package['git-fat']) {
        package { 'git-fat':
            ensure => "0.1.2-1~${::lsbdistcodename}1",
        }
    }
}
