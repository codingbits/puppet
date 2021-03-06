# == Class: role::webperf
#
# This role provisions a set of front-end monitoring tools that feed
# into StatsD.
#
class role::webperf {

    include ::standard
    include ::base::firewall
    include ::eventlogging
    include ::webperf::statsv

    $eventlogging_host = 'eventlog1001.eqiad.wmnet'
    $statsd_host = 'statsd.eqiad.wmnet'
    # Installed by eventlogging class using trebuchet
    $eventlogging_path = '/srv/deployment/eventlogging/eventlogging'

    # Aggregate client-side latency measurements collected via the
    # NavigationTiming MediaWiki extension and send them to Graphite.
    # See <https://www.mediawiki.org/wiki/Extension:NavigationTiming>
    class { '::webperf::navtiming':
        endpoint          => "tcp://${eventlogging_host}:8600",
        eventlogging_path => $eventlogging_path,
        statsd_host       => $statsd_host,
    }

    # Report VisualEditor performance measurements to Graphite.
    # See <https://meta.wikimedia.org/wiki/Schema:TimingData>
    class { '::webperf::ve':
        endpoint          => "tcp://${eventlogging_host}:8600",
        eventlogging_path => $eventlogging_path,
        statsd_host       => $statsd_host,
    }
}
