#!/bin/sh

JOB_MANAGER_RPC_ADDRESS=${JOB_MANAGER_RPC_ADDRESS:-$(hostname -f)}
CONF_FILE="${FLINK_HOME}/conf/flink-conf.yaml"

drop_privs_cmd() {
    if [ $(id -u) != 0 ]; then
        return
    elif [ -x /sbin/su-exec ]; then
        echo su-exec flink
    else
        echo gosu flink
    fi
}

case "$1" in
    jobmanager)
        shift
        echo "Starting Job Manager"
        sed -i -e "s/jobmanager\.rpc\.address:.*/jobmanager.rpc.address: ${JOB_MANAGER_RPC_ADDRESS}/g" "${CONF_FILE}"
        exec $(drop_privs_cmd) "$FLINK_HOME/bin/jobmanager.sh" start-foreground "$@"
        ;;
    taskmanager)
        shift
        echo "Starting Task Manager"
        TASK_MANAGER_NUMBER_OF_TASK_SLOTS=${TASK_MANAGER_NUMBER_OF_TASK_SLOTS:-$(grep -c ^processor /proc/cpuinfo)}
        sed -i -e "s/taskmanager\.numberOfTaskSlots:.*/taskmanager.numberOfTaskSlots: ${TASK_MANAGER_NUMBER_OF_TASK_SLOTS}/g" "${CONF_FILE}"
        exec $(drop_privs_cmd) "$FLINK_HOME/bin/taskmanager.sh" start-foreground "$@"
        ;;
    *)
        echo "Usage: $(basename "$0") (jobmanager|taskmanager)"
        exit 1
        ;;
esac
