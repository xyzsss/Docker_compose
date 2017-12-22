#!/bin/bash
#   nginx_docker_log_archive.sh
#   -----------------------------------------------------------
#   This script is writen for nginx log archive on Docker  
#
#   Usage:
#       1, CHECK VARIABLES FIRST!!!
#       2, GIVE EXECUTE PERMISSION TO SCRIPTS LIKE `chmod +x nginx_docker_log_archive.sh`
#       3, ADD SCRIPTS TO CRONTAB AS ROOT
#           0 0 * * * /path/to/nginx_docker_log_archive.sh > /var/log/nginx/nginx_docker_log_archive.log 2>&1
#   TODO:
#        support for multiple
#   Created: 2017-10-20
#   Author: Mike
#   Post-History: 2017-10-20 init
# 		  2017-11-22 enable for docker
#   -----------------------------------------------------------

OPLOG="/var/log/nginx/nginx_docker_log_archive.log"
{

LOG_FILE_PATH="/var/log/nginx"
LOG_FILES="access.sentry.log|access.timeEvent.log|access.log"
CONTAINER_NAME="nginx"


# check nginx log dir
[ -d "${LOG_FILE_PATH}" ] || { echo "Log dir ${LOG_FILE_PATH} not found." && exit 1
}

if [ `docker ps |grep "${CONTAINER_NAME}"|wc -l` -ne 1 ];then
	echo -e 'Run failed!!!\nNginx docker number is not only one,please check'
	exit 1 
fi

# Check Container $DOCKER_NAME running or not
CONTAINER_RUNNING_NAME=`docker ps |grep "${CONTAINER_NAME}"| awk '{print $NF}'`
CONTAINER_ID=`docker ps |grep "${CONTAINER_NAME}"| awk '{print $1}'`
if [ "${CONTAINER_NAME}" != "$CONTAINER_RUNNING_NAME" ]
then
    echo "It seems the container ${CONTAINER_NAME} not matched !"
fi

# Do file rename
for LOG_FILE in `echo "${LOG_FILES}"|sed 's;|;\n;g'`
do
    LOG_FILE_FORMAL=`echo "${LOG_FILE}"|sed 's/.log$//'`
    mv "${LOG_FILE_PATH}/${LOG_FILE}" "${LOG_FILE_PATH}/${LOG_FILE_FORMAL}.$(date '+%Y-%m-%d.%H%M%S').log"
done

# send 'USR1' single to nginx in Docker
docker kill --signal="USR1" "${CONTAINER_ID}"

# Change HOUSEKEEPING=1 to enable clean up
HOUSEKEEPING=0
KEEP_DAYS=365
if [ $HOUSEKEEPING -eq 1 ]; then
	if [ -d "${LOGS_PATH}" ]; then
		find "${LOG_FILE_PATH}" -type f -name "access_*.log.gz" -mtime +${KEEP_DAYS} -exec rm -f {} \;
	fi
fi } | tee -a "${OPLOG}" 2>&1
