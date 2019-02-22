#!/bin/sh
 
ECHO=/bin/echo
TEST=/usr/bin/test
TOMCAT_USER={{ application_name}}-tomcat }}
TOMCAT_HOME/opt/{{ application_name }}/{{ application_name}}-tomcat-{{ tomcat_major_version }}
TOMCAT_START_SCRIPT/opt/{{ application_name }}/{{ application_name}}-tomcat-{{ tomcat_major_version }}/bin/startup.sh
TOMCAT_STOP_SCRIPT=/opt/{{ application_name }}/{{ application_name}}-tomcat-{{ tomcat_major_version }}/bin/shutdown.sh
 
$TEST -x $TOMCAT_START_SCRIPT || exit 0
$TEST -x $TOMCAT_STOP_SCRIPT || exit 0
 
start() {
    $ECHO -n "Starting Tomcat"
    su - $TOMCAT_USER -c "$TOMCAT_START_SCRIPT &"
    $ECHO "."
}
 
stop() {
    $ECHO -n "Stopping Tomcat"
    su - $TOMCAT_USER -c "$TOMCAT_STOP_SCRIPT &"
    while [ "$(ps -fu $TOMCAT_USER | grep java | grep tomcat | wc -l)" -gt "0" ]; do
        sleep 5; $ECHO -n "."
    done
    $ECHO "."
}
 
case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        stop
        sleep 15
        start
        ;;
    *)
        $ECHO "Usage: tomcat {start|stop|restart}"
        exit 1
esac
exit 0