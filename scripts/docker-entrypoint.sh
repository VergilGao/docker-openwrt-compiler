#!/bin/bash

USER=user

echo "---Setup Timezone to ${TZ}---"
echo "${TZ}" > /etc/timezone
echo "---Checking if UID: ${UID} matches user---"
usermod -o -u ${UID} ${USER}
echo "---Checking if GID: ${GID} matches user---"
groupmod -o -g ${GID} ${USER} > /dev/null 2>&1 ||:
usermod -g ${GID} ${USER}
echo "---Setting umask to ${UMASK}---"
umask ${UMASK}

echo "---Taking ownership of data...---"
chown -R ${UID}:${GID} /src /opt /config /build

[ -e /config/part1.sh ] && cp -f /config/part1.sh /opt/part1.sh && chmod +x /opt/part1.sh
[ -e /config/part2.sh ] && cp -f /config/part2.sh /opt/part2.sh && chmod +x /opt/part2.sh

gosu ${USER} /opt/scripts/build.sh
