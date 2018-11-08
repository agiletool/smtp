#!/bin/bash

set -v

/opt/install.sh
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf