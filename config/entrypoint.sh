#!/bin/sh

set -e

if [ "$MATOMO_INSTALL" = '1' ]; then
  echo 'Installation is enabled'
  exit 0
fi

if [ -s /config/config.ini.php ]; then
  mkdir -p ./config

  # The awk script is repeating lines with ${MATOMO_HOST} and replacing by
  # the comma-delimited hosts in ${MATOMO_HOST}
  # The perl script is replacing the other environment values (no envsubst here)
  echo 'Replacing the environment values' >&2
	cat /config/config.ini.php \
		| awk -v hosts="${MATOMO_HOSTS}" '
      /\${MATOMO_HOST}/{
          split(hosts, host_array, ",");
          for(i in host_array) {
            LINE=$0;
            gsub("\\${MATOMO_HOST}", host_array[i], LINE);
            print LINE
          }
          next
      }
      {
        print $0
      }
      ' \
		| perl -pe 's/\$\{([_A-Za-z0-9-]+)\}/$ENV{$1}/g' > ./config/config.ini.php \
	&& chown -R ${MATOMO_UID}:${MATOMO_GID} ./config/
fi
