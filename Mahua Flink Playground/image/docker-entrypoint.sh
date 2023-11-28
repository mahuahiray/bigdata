#!/bin/sh

# Define the RPC address for the Job Manager, defaulting to the fully qualified domain name
RPC_ADDR_JOB_MANAGER=${JOB_MANAGER_RPC_ADDRESS:-$(hostname -f)}
CONFIG_FILE="${FLINK_HOME}/conf/flink-conf.yaml"

# Function to drop privileges
reduce_privileges() {
    if [ $(id -u) -ne 0 ]; then
        return
    elif [ -x /sbin/su-exec ]; then
        echo su-exec flink
    else
        echo gosu flink
    fi
}

# Main command switch
case "$1" in
    jobmanager)
        shift
        echo "Initiating Job Manager"
        sed -i -e "s/jobmanager\.rpc\.address:.*/jobmanager.rpc.address: ${RPC_ADDR_JOB_MANAGER}/g" "${CONFIG_FILE}"
        exec $(reduce_privileges) "$FLINK_HOME/bin/jobmanager.sh" start-foreground "$@"
        ;;
    taskmanager)
        shift
        echo "Initiating Task Manager"
        NUM_TASK_SLOTS=${TASK_MANAGER_NUMBER_OF_TASK_SLOTS:-$(grep -c ^processor /proc/cpuinfo)}
        sed -i -e "s/taskmanager\.numberOfTaskSlots:.*/taskmanager.numberOfTaskSlots: ${NUM_TASK_SLOTS}/g" "${CONFIG_FILE}"
        exec $(reduce_privileges) "$FLINK_HOME/bin/taskmanager.sh" start-foreground "$@"
        ;;
    *)
        echo "How to use: $(basename "$0") (jobmanager|taskmanager)"
        exit 1
        ;;
esac
