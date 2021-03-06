class network::constants {
    # Note this name is misleading.  Most of these are "external" networks,
    # but some subnets of the IPv6 space are not externally routed, even if
    # they're externally route-able (the ones used for private vlans).
    $module_path = get_module_path($module_name)
    $network_data = loadyaml("${module_path}/data/data.yaml")
    $all_network_subnets = $network_data['network::subnets']
    $external_networks = $network_data['network::external']
    $network_infra = $network_data['network::infrastructure']
    $mgmt_networks = $network_data['network::management']


    # are you really sure you want to use this? maybe what you really
    # the trusted/production networks. See $production_networks for this.
    $all_networks = flatten([$external_networks, '10.0.0.0/8'])
    $all_networks_lo = flatten([$all_networks, '127.0.0.0/8', '::1/128'])

    # $domain_networks is a set of all networks belonging to a domain.
    # a domain is a realm currently, but the notion is more generic than that on
    # purpose.
    # TODO: Figure out a way this can be per-project networks in labs
    $domain_networks = slice_network_constants($::realm)
    # $production_networks will always contain just the production networks
    $production_networks = slice_network_constants('production')
    # $labs_networks will always contain just the labs networks
    $labs_networks = slice_network_constants('labs')
    # $frack_networks will always contain just the fundraising networks
    $frack_networks = slice_network_constants('frack')

    $special_hosts = {
        'production' => {
            'bastion_hosts' => [
                    '208.80.154.149',                   # bast1001.wikimedia.org
                    '2620:0:861:2:208:80:154:149',      # bast1001.wikimedia.org
                    '208.80.153.5',                     # bast2001.wikimedia.org
                    '2620:0:860:1:208:80:153:5',        # bast2001.wikimedia.org
                    '91.198.174.113',                   # bast3002.wikimedia.org
                    '2620:0:862:1:91:198:174:113',      # bast3002.wikimedia.org
                    '198.35.26.5',                      # bast4001.wikimedia.org
                    '2620:0:863:1:198:35:26:5',         # bast4001.wikimedia.org
                    '208.80.154.151',                   # iron.wikimedia.org
                    '2620:0:861:2:208:80:154:151',      # iron.wikimedia.org
                ],
            'monitoring_hosts' => [
                    '208.80.153.74',                    # tegmen.wikimedia.org
                    '2620:0:860:3:208:80:153:74',       # tegmen.wikimedia.org
                    '208.80.155.119',                   # einsteinium.wikimedia.org
                    '2620:0:861:4:208:80:155:119',      # einsteinium.wikimedia.org
                    '208.80.154.82',                    # dbmonitor1001.wikimedia.org
                    '2620:0:861:3:208:80:154:82',       # dbmonitor1001.wikimedia.org
                    '208.80.153.52',                    # dbmonitor2001.wikimedia.org
                    '2620:0:860:2:208:80:153:52',       # dbmonitor2001.wikimedia.org
                    '208.80.154.53',                    # uranium.wikimedia.org (ganglia, gmetad needs it)
                    '2620:0:861:1:208:80:154:53',       # uranium.wikimedia.org
                ],
            'deployment_hosts' => [
                    '10.64.0.196',                      # tin.eqiad.wmnet
                    '2620:0:861:101:10:64:0:196',       # tin.eqiad.wmnet
                    '10.192.32.22',                     # naos.codfw.wmnet
                    '2620:0:860:103:10:192:32:22',      # naos.codfw.wmnet
                ],
            'maintenance_hosts' => [
                    '10.64.32.13',                      # terbium.eqiad.wmnet
                    '2620:0:861:103:10:64:32:13',       # terbium.eqiad.wmnet
                    '10.192.48.45',                     # wasat.codfw.wmnet
                    '2620:0:860:104:10:192:48:45',      # wasat.codfw.wmnet
                ],
            'puppet_frontends' => [
                    '10.64.16.73',                # puppetmaster1001.eqiad.wmnet
                    '2620:0:861:102:10:64:16:73', # puppetmaster1001.eqiad.wmnet
                    '10.192.0.27',                # puppetmaster2001.codfw.wmnet
                    '2620:0:860:101:10:192:0:27', # puppetmaster2001.codfw.wmnet
                ],
            'cumin_masters' => [
                    '10.64.32.20',                 # neodymium.eqiad.wmnet
                    '2620:0:861:103:10:64:32:20',  # neodymium.eqiad.wmnet
                    '10.192.0.140',                # sarin.codfw.wmnet
                    '2620:0:860:101:10:192:0:140', # sarin.codfw.wmnet
                ],
            'kafka_brokers_main' => [
                    '10.64.0.11',                         # kafka1001.eqiad.wmnet
                    '2620:0:861:101:1618:77ff:fe33:5242', # kafka1001.eqiad.wmnet
                    '10.64.16.41',                        # kafka1002.eqiad.wmnet
                    '2620:0:861:102:1618:77ff:fe33:4a4e', # kafka1002.eqiad.wmnet
                    '10.64.32.127',                       # kafka1003.eqiad.wmnet
                    '2620:0:861:103:1618:77ff:fe33:4ad2', # kafka1003.eqiad.wmnet
                    '10.192.0.139',                       # kafka2001.codfw.wmnet
                    '2620:0:860:101:1618:77ff:fe39:6f37', # kafka2001.codfw.wmnet
                    '10.192.16.169',                      # kafka2002.codfw.wmnet
                    '2620:0:860:102:1618:77ff:fe33:500d', # kafka2002.codfw.wmnet
                    '10.192.32.150',                      # kafka2003.codfw.wmnet
                    '2620:0:860:103:1a66:daff:fe7f:23f0', # kafka2003.codfw.wmnet
                ],
            'kafka_brokers_analytics' => [
                    '10.64.5.12',                  # kafka1012.eqiad.wmnet
                    '2620:0:861:104:10:64:5:12',   # kafka1012.eqiad.wmnet
                    '10.64.5.13',                  # kafka1013.eqiad.wmnet
                    '2620:0:861:104:10:64:5:13',   # kafka1013.eqiad.wmnet
                    '10.64.36.114',                # kafka1014.eqiad.wmnet
                    '2620:0:861:106:10:64:36:114', # kafka1014.eqiad.wmnet
                    '10.64.53.10',                 # kafka1018.eqiad.wmnet
                    '2620:0:861:108:10:64:53:10',  # kafka1018.eqiad.wmnet
                    '10.64.53.12',                 # kafka1020.eqiad.wmnet
                    '2620:0:861:108:10:64:53:12',  # kafka1020.eqiad.wmnet
                    '10.64.36.122',                # kafka1022.eqiad.wmnet
                    '2620:0:861:106:10:64:36:122', # kafka1022.eqiad.wmnet
                ],
            'hadoop_masters' => [
                    '10.64.36.118',                       # analytics1001.eqiad.wmnet
                    '2620:0:861:106:f21f:afff:fee8:af06', # analytics1001.eqiad.wmnet
                    '10.64.53.21',                        # analytics1002.eqiad.wmnet
                    '2620:0:861:108:f21f:afff:fee8:bc3f', # analytics1002.eqiad.wmnet
                ],
            'druid_hosts' => [
                    '10.64.5.101',                        # druid1001.eqiad.wmnet
                    '2620:0:861:104:1e98:ecff:fe29:e298', # druid1001.eqiad.wmnet
                    '10.64.36.102',                       # druid1002.eqiad.wmnet
                    '2620:0:861:106:1602:ecff:fe06:8bec', # druid1002.eqiad.wmnet
                    '10.64.53.103',                       # druid1003.eqiad.wmnet
                    '2620:0:861:108:1e98:ecff:fe29:e278', # druid1003.eqiad.wmnet
                ],
            'cache_misc' => [
                    '10.64.32.97',                        # cp1045.eqiad.wmnet
                    '2620:0:861:103:10:64:32:97',         # cp1045.eqiad.wmnet
                    '10.64.32.103',                       # cp1051.eqiad.wmnet
                    '2620:0:861:103:10:64:32:103',        # cp1051.eqiad.wmnet
                    '10.64.0.95',                         # cp1058.eqiad.wmnet
                    '2620:0:861:101:10:64:0:95',          # cp1058.eqiad.wmnet
                    '10.64.0.98',                         # cp1061.eqiad.wmnet
                    '2620:0:861:101:10:64:0:98',          # cp1061.eqiad.wmnet
                    '10.192.0.127',                       # cp2006.codfw.wmnet
                    '2620:0:860:101:10:192:0:127',        # cp2006.codfw.wmnet
                    '10.192.16.138',                      # cp2012.codfw.wmnet
                    '2620:0:860:102:10:192:16:138',       # cp2012.codfw.wmnet
                    '10.192.32.117',                      # cp2018.codfw.wmnet
                    '2620:0:860:103:10:192:32:117',       # cp2018.codfw.wmnet
                    '10.192.48.29',                       # cp2025.codfw.wmnet
                    '2620:0:860:104:10:192:48:29',        # cp2025.codfw.wmnet
                    '10.20.0.107',                        # cp3007.esams.wmnet
                    '2620:0:862:102:10:20:0:107',         # cp3007.esams.wmnet
                    '10.20.0.108',                        # cp3008.esams.wmnet
                    '2620:0:862:102:10:20:0:108',         # cp3008.esams.wmnet
                    '10.20.0.109',                        # cp3009.esams.wmnet
                    '2620:0:862:102:10:20:0:109',         # cp3009.esams.wmnet
                    '10.20.0.110',                        # cp3010.esams.wmnet
                    '2620:0:862:102:10:20:0:110',         # cp3010.esams.wmnet
                ],
            },
        'labs' => {
            'bastion_hosts' => concat([
                    '10.68.17.232', # bastion-01.eqiad.wmflabs
                    '10.68.18.65',  # bastion-02.eqiad.wmflabs
                    '10.68.18.66',  # bastion-restricted-01.eqiad.wmflabs
                    '10.68.18.68',  # bastion-restricted-02.eqiad.wmflabs
                ], hiera('network::allow_ssh_from_ips', [])), # Allow labs projects to setup their own ssh origination points
            'monitoring_hosts' => [
                    '10.68.16.210', # shinken-01.eqiad.wmflabs
                ],
            'deployment_hosts' => [
                    '10.68.21.205',  # deployment-tin.deployment-prep.eqiad.wmflabs
                    '10.68.20.135',  # deployment-mira.deployment-prep.eqiad.wmflabs
                ],
            'maintenance_hosts' => [
                    '',  # deployment-terbium.deployment-prep.eqiad.wmflabs ?
                    '',  # deployment-wasat.deployment-prep.eqiad.wmflabs ?
                ],
            }
    }


    # Networks hosting MediaWiki application servers
    # These are:
    #  - public hosts in eqiad/codfw
    #  - all private networks in eqiad/codfw
    if $::realm == 'production' {
        $mw_appserver_networks = flatten([
            slice_network_constants('production', {
                'site'   => 'eqiad',
                'sphere' => 'public',
                }),
            slice_network_constants('production', {
                'site'   => 'codfw',
                'sphere' => 'public',
                }),
            slice_network_constants('production', {
                'site'        => 'eqiad',
                'sphere'      => 'private',
                'description' => 'private',
                }),
            slice_network_constants('production', {
                'site'        => 'codfw',
                'sphere'      => 'private',
                'description' => 'private',
                }),
            slice_network_constants('production', {
                'site'        => 'eqiad',
                'sphere'      => 'private',
                'description' => 'labs-support',
                }),
            ])
    } elsif $::realm == 'labs' {
        # rely on security groups in labs to restrict this
        $mw_appserver_networks = flatten([
            slice_network_constants('labs'),
            '127.0.0.1'])
    }

    # Analytics subnets
    $analytics_networks = slice_network_constants('production', { 'description' => 'analytics'})

    # Networks that trebuchet/git-deploy
    # will be able to deploy to.
    # (Puppet does array concatenation
    # by declaring array of other arrays! (?!)
    # See: http://weblog.etherized.com/posts/175)
    $deployable_networks = [
        $mw_appserver_networks,
        $analytics_networks,
    ]
}
