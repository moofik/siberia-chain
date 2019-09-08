#!/bin/bash
set -e

echo "Waiting Rabbit MQ for PHP workers"

while ! nc -z $RABBIT_MQ_HOST $RABBIT_MQ_PORT;  do sleep 3; done

echo "Rabbit MQ is up"

supervisord -c /etc/supervisor/supervisord.conf
service rsyslog start
tail -f /var/log/syslog & wait $!
