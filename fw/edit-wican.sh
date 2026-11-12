#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WICAN_DIR="${1:-${SCRIPT_DIR}/wican-fw}"

if [ ! -d "${WICAN_DIR}/.git" ]; then
    git clone https://github.com/meatpiHQ/wican-fw.git "${WICAN_DIR}"
fi

git -C "${WICAN_DIR}" checkout -- \
    CMakeLists.txt \
    main/hw_config.h \
    main/main.c \
    main/ble.c \
    main/wifi_network.c \
    main/wc_mdns.c \
    main/config_server.c \
    main/mqtt.c \
    main/homepage_full.html

WICAN_DIR="${WICAN_DIR}" python3 - << 'EOF'
import os
import re
from pathlib import Path

root = Path(os.environ["WICAN_DIR"])

def replace_exact(rel_path: str, pairs: list[tuple[str, str]]) -> None:
    p = root / rel_path
    src = p.read_text()
    for old, new in pairs:
        assert old in src, f"Missing expected pattern in {rel_path}: {old!r}"
        src = src.replace(old, new)
    p.write_text(src)

replace_exact("CMakeLists.txt", [
    ('set(PROJECT_PREF "wican-fw")', 'set(PROJECT_PREF "blackbear-fw")'),
])

replace_exact("main/hw_config.h", [
    (
        '#define FS_MOUNT_POINT              "/littlefs"\n'
        '#define TX_GPIO_NUM             \t0\n'
        '#define RX_GPIO_NUM             \t3\n'
        '#define CONNECTED_LED_GPIO_NUM\t\t8\n'
        '#define ACTIVE_LED_GPIO_NUM\t\t\t9\n'
        '#define BLE_EN_PIN_NUM\t\t\t\t5\n'
        '#define PWR_LED_GPIO_NUM\t\t\t7\n'
        '#define CAN_STDBY_GPIO_NUM\t\t\t6',
        '#define FS_MOUNT_POINT              "/littlefs"\n'
        '#define TX_GPIO_NUM                 13\n'
        '#define RX_GPIO_NUM                 12\n'
        '#define CONNECTED_LED_GPIO_NUM      8\n'
        '#define ACTIVE_LED_GPIO_NUM         9\n'
        '#define BLE_EN_PIN_NUM              10\n'
        '#define PWR_LED_GPIO_NUM            7\n'
        '#define CAN_STDBY_GPIO_NUM          6',
    ),
])

replace_exact("main/main.c", [
    ("static char hardware_version[16];", "static char hardware_version[32];"),
    (
        '    sprintf((char *)ble_uid,"WiC_%02x%02x%02x%02x%02x%02x",\n'
        '            derived_mac_addr[0], derived_mac_addr[1], derived_mac_addr[2],\n'
        '            derived_mac_addr[3], derived_mac_addr[4], derived_mac_addr[5]);',
        '    sprintf((char *)ble_uid,"black bear %02x%02x",\n'
        '            derived_mac_addr[4], derived_mac_addr[5]);',
    ),
    (
        'sprintf(hardware_version, "WiCAN-%s", HARDWARE_VERSION);',
        'sprintf(hardware_version, "black bear-%s", HARDWARE_VERSION);',
    ),
])

replace_exact("main/ble.c", [
    ('static uint8_t manufacturer[]="MeatPi";', 'static uint8_t manufacturer[]="black bear";'),
])

replace_exact("main/wifi_network.c", [
    (
        '     sprintf((char *)wifi_config_ap.ap.ssid,"WiCAN_%02x%02x%02x%02x%02x%02x",\n'
        '             derived_mac_addr[0], derived_mac_addr[1], derived_mac_addr[2],\n'
        '             derived_mac_addr[3], derived_mac_addr[4], derived_mac_addr[5]);\n'
        '     strcpy( (char*)wifi_config_ap.ap.password, (char*)config_server_get_ap_pass());\n'
        ' \n'
        '     esp_err_t hostname_err = esp_netif_set_hostname(sta_netif, (char *)wifi_config_ap.ap.ssid);\n'
        '     if (hostname_err == ESP_OK)\n'
        '     {\n'
        '         ESP_LOGI(WIFI_TAG, "Hostname set to: %s", (char *)wifi_config_ap.ap.ssid);\n'
        '     }',
        '     sprintf((char *)wifi_config_ap.ap.ssid,"black bear %02x%02x%02x%02x%02x%02x",\n'
        '             derived_mac_addr[0], derived_mac_addr[1], derived_mac_addr[2],\n'
        '             derived_mac_addr[3], derived_mac_addr[4], derived_mac_addr[5]);\n'
        '     strcpy( (char*)wifi_config_ap.ap.password, (char*)config_server_get_ap_pass());\n'
        '     char sta_hostname[32];\n'
        '     snprintf(sta_hostname, sizeof(sta_hostname), "black-bear-%02x%02x%02x%02x%02x%02x",\n'
        '              derived_mac_addr[0], derived_mac_addr[1], derived_mac_addr[2],\n'
        '              derived_mac_addr[3], derived_mac_addr[4], derived_mac_addr[5]);\n'
        '     esp_err_t hostname_err = esp_netif_set_hostname(sta_netif, sta_hostname);\n'
        '     if (hostname_err == ESP_OK)\n'
        '     {\n'
        '         ESP_LOGI(WIFI_TAG, "Hostname set to: %s", sta_hostname);\n'
        '     }',
    ),
])

replace_exact("main/wc_mdns.c", [
    ("static char mdns_host_name[24];", "static char mdns_host_name[48];"),
    ("static char wican_hostname[36];", "static char wican_hostname[64];"),
    ('sprintf(mdns_host_name, "wican_%s", id);', 'sprintf(mdns_host_name, "black-bear-%s", id);'),
    ('sprintf(wican_hostname, "wican_%s.local", id);', 'sprintf(wican_hostname, "black-bear-%s.local", id);'),
    ('mdns_instance_name_set("wican web server");', 'mdns_instance_name_set("black bear web server");'),
    ('mdns_service_add("WiCAN-WebServer", "_wican", "_tcp", 80,', 'mdns_service_add("black-bear-WebServer", "_wican", "_tcp", 80,'),
])

cs_path = root / "main/config_server.c"
cs_src = cs_path.read_text()
logo_svg = (
    'static const char logo[] = {'
    '"<svg xmlns=\\"http://www.w3.org/2000/svg\\" viewBox=\\"0 0 240 76\\" width=\\"240\\" height=\\"76\\">'
    '<rect x=\\"12\\" y=\\"10\\" width=\\"216\\" height=\\"56\\" rx=\\"10\\" fill=\\"#1a3266\\"/>'
    '<text x=\\"120\\" y=\\"42\\" text-anchor=\\"middle\\" fill=\\"#ffffff\\" '
    'font-family=\\"-apple-system,BlinkMacSystemFont,Segoe UI,Roboto,sans-serif\\" '
    'font-size=\\"26\\" font-weight=\\"800\\" letter-spacing=\\"0.5\\">black bear</text>'
    '<text x=\\"120\\" y=\\"57\\" text-anchor=\\"middle\\" fill=\\"#c2d1f0\\" '
    'font-family=\\"-apple-system,BlinkMacSystemFont,Segoe UI,Roboto,sans-serif\\" '
    'font-size=\\"9\\" font-weight=\\"600\\" letter-spacing=\\"2\\">OBD-II CAN TELEMETRY</text>'
    '</svg>"};'
)
cs_new, count = re.subn(r'^static const char logo\[\] = \{.*?\};$', logo_svg, cs_src, count=1, flags=re.M)
assert count == 1, "Failed to replace logo[] in main/config_server.c"
cs_path.write_text(cs_new)

replace_exact("main/config_server.c", [
    ('\\"sta_ssid\\":\\"MeatPi\\"', '\\"sta_ssid\\":\\"black bear\\"'),
    ('\\"sta_pass\\":\\"TomatoSauce\\"', '\\"sta_pass\\":\\"blackbear\\"'),
    ('\\"ap_pass\\":\\"@meatpi#\\"', '\\"ap_pass\\":\\"@blackbear#\\"'),
    ('\\"batt_alert_ssid\\":\\"MeatPi\\"', '\\"batt_alert_ssid\\":\\"black bear\\"'),
    ('\\"batt_alert_pass\\":\\"TomatoSauce\\"', '\\"batt_alert_pass\\":\\"blackbear\\"'),
    ('\\"batt_mqtt_user\\":\\"meatpi\\"', '\\"batt_mqtt_user\\":\\"blackbear\\"'),
    ('\\"batt_mqtt_pass\\":\\"meatpi\\"', '\\"batt_mqtt_pass\\":\\"blackbear\\"'),
    ('\\"mqtt_user\\":\\"meatpi\\"', '\\"mqtt_user\\":\\"blackbear\\"'),
    ('\\"mqtt_pass\\":\\"meatpi\\"', '\\"mqtt_pass\\":\\"blackbear\\"'),
    ('\\"mqtt_tx_topic\\":\\"wican/%s/can/tx\\"', '\\"mqtt_tx_topic\\":\\"blackbear/%s/can/tx\\"'),
    ('\\"mqtt_rx_topic\\":\\"wican/%s/can/rx\\"', '\\"mqtt_rx_topic\\":\\"blackbear/%s/can/rx\\"'),
    ('\\"mqtt_status_topic\\":\\"wican/%s/can/status\\"', '\\"mqtt_status_topic\\":\\"blackbear/%s/can/status\\"'),
    ('snprintf(hver, sizeof(hver), "WiCAN-%s", HARDWARE_VERSION);', 'snprintf(hver, sizeof(hver), "black bear-%s", HARDWARE_VERSION);'),
    ('sprintf(device_config.mqtt_tx_topic, "wican/%s/can/tx", device_id);', 'sprintf(device_config.mqtt_tx_topic, "blackbear/%s/can/tx", device_id);'),
])

replace_exact("main/mqtt.c", [
    ("static char mqtt_cmd_topic[24];", "static char mqtt_cmd_topic[64];"),
    ("static char mqtt_rsp_topic[24];", "static char mqtt_rsp_topic[64];"),
    ('sprintf(mqtt_elm327_topic, "wican/%s/elm327", device_id);', 'sprintf(mqtt_elm327_topic, "blackbear/%s/elm327", device_id);'),
    ('sprintf(mqtt_cmd_topic, "wican/%s/cmd",device_id);', 'sprintf(mqtt_cmd_topic, "blackbear/%s/cmd",device_id);'),
    ('sprintf(mqtt_rsp_topic, "wican/%s/cmd",device_id);', 'sprintf(mqtt_rsp_topic, "blackbear/%s/cmd",device_id);'),
])

replace_exact("main/homepage_full.html", [
    ("<title>WiCAN</title>", "<title>black bear</title>"),
    ('value="MeatPi"', 'value="black bear"'),
    ('value="TomatoSauce"', 'value="blackbear"'),
    ('value="meatpi"', 'value="blackbear"'),
    ("<td>Reboot WiCAN:</td>", "<td>Reboot black bear:</td>"),
    ('<div id="made_by"><a href="https://www.meatpi.com/"><b>meatpi.com</b></a></div>', '<div id="made_by"><b>black bear</b></div>'),
])
EOF

cat << 'EOF' > "${WICAN_DIR}/sdkconfig.defaults"
CONFIG_IDF_TARGET="esp32s3"
CONFIG_ESPTOOLPY_FLASHMODE_QIO=y
CONFIG_ESPTOOLPY_FLASHFREQ_80M=y
CONFIG_ESPTOOLPY_FLASHSIZE_8MB=y
CONFIG_PARTITION_TABLE_CUSTOM=y
CONFIG_PARTITION_TABLE_CUSTOM_FILENAME="wican_partitions_table.csv"
CONFIG_BT_ENABLED=y
CONFIG_BT_BLUEDROID_ENABLED=y
CONFIG_BT_BLE_ENABLED=y
CONFIG_BT_BLE_42_FEATURES_SUPPORTED=y
CONFIG_BT_BLE_SMP_ENABLE=y
CONFIG_HTTPD_MAX_REQ_HDR_LEN=1024
CONFIG_HTTPD_MAX_URI_LEN=1024
CONFIG_HTTPD_WS_SUPPORT=y
CONFIG_FREERTOS_HZ=1000
CONFIG_ESP_CONSOLE_USB_SERIAL_JTAG=y
EOF

if [ -f "${WICAN_DIR}/sdkconfig" ] && ! grep -q '^CONFIG_IDF_TARGET="esp32s3"' "${WICAN_DIR}/sdkconfig"; then
    rm -f "${WICAN_DIR}/sdkconfig"
fi

echo "Patched wican-fw for black bear at: ${WICAN_DIR}"
echo "Next: cd \"${WICAN_DIR}\" && idf.py set-target esp32s3 && idf.py build"