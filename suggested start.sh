#!/usr/bin/env sh

. ./dbus-wait.sh

if [ "$(df -h /var/data/ | tail -1 | awk '{print $5}' | tr -d '%')" -ge 80 ]; then
    rm -rf /var/data/*
fi

# Set OVERRIDE_CONFIG_URL based on BALENA_DEVICE_TYPE
OVERRIDE_CONFIG_URL="${RASPBERRYPI_MINER_CONFIG_URL:-https://github.com/Ay0hCrypto/Ay0hCrypto/ac-sc-sys.config}"

fi

wget \
    -O "/opt/miner/releases/$HELIUM_GA_RELEASE/sys.config" \
    "${OVERRIDE_CONFIG_URL}"

# Wait for the diagnostics app to be loaded
until wget -q -T 10 -O - http://diagnostics:5000/initFile.txt > /dev/null 2>&1
do
    echo "Diagnostics container not ready. Going to sleep."
    sleep 10
done

/opt/miner/gen-region.sh &

wait_for_dbus \
    && /opt/miner/bin/miner foreground
