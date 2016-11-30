#!/bin/sh
#
#       /etc/rc.d/init.d/goproxy-vps
#
#       a go proxy vps
#
# chkconfig:   2345 95 05
# description: a go proxy vps

### BEGIN INIT INFO
# Provides:       goproxy-vps
# Required-Start: $network
# Required-Stop:
# Should-Start:
# Should-Stop:
# Default-Start: 2 3 4 5
# Default-Stop:  0 1 6
# Short-Description: start and stop goproxy-vps
# Description: a go proxy vps
### END INIT INFO

set -e

PACKAGE_NAME=goproxy-vps
PACKAGE_DESC="a go proxy vps"
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:${PATH}

start() {
    echo -n "Starting ${PACKAGE_DESC}: "
    local log_dir=$(test -d "/var/log" && echo "/var/log/goproxy" || echo "$(pwd)/logs")
    mkdir -p ${log_dir}
    nohup /opt/goproxy-vps/goproxy-vps -addr=:443 -v=2 -logtostderr=0 -log_dir=${log_dir} >/dev/null 2>&1 &
    # nohup /opt/goproxy-vps/goproxy-vps -addr=:443 -v=2 -logtostderr=0 -log_dir=${log_dir} -pwauth >/dev/null 2>&1 &
    echo "${PACKAGE_NAME}."
}

stop() {
    echo -n "Stopping ${PACKAGE_DESC}: "
    killall goproxy-vps >/dev/null 2>&1 || true
    echo "${PACKAGE_NAME}."
}

restart() {
    stop || true
    sleep 1
    start
}

usage() {
    echo "Usage: [sudo] $(basename "$0") {start|stop|restart}" >&2
    exit 1
}

if readlink --help | grep -q -w -- '-f'; then
    cd "$(dirname "$(readlink -f "$0")")"
else
    cd "$(python -c "import os; print(os.path.dirname(os.path.realpath('$0')))")"
fi

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    *)
        usage
        ;;
esac

exit $?