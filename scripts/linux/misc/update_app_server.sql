-- This script updates the app server that Peek points to

-- Update it like so:
-- sed -i 's/APP_HOST_NAME/192.160.10.10/g' dump_config_only.sh
-- sed -i 's/POFINFO_PASS/synerty/g' dump_config_only.sh
-- sed -i 's/SSH_USER/enmac/g' dump_config_only.sh
-- sed -i 's/SSH_PASS/synerty/g' dump_config_only.sh

-- Run it like so
-- psql < dump_config_only.sh

-- ENMAC Diagram Loader
UPDATE pl_enmac_diagram_loader."AppServerSettingsTuple"
SET "appHost"           = 'APP_HOST_NAME',
    "appSshUsername"    = 'SSH_USER',
    "appSshPassword"    = 'SSH_PASS',
    "appOracleUsername" = 'pofinfo',
    "appOraclePassword" = 'POFINFO_PASS';

-- ENMAC Equipment Loader
UPDATE pl_enmac_equipment_loader."AppServerSettingsTuple"
SET "appHost"           = 'APP_HOST_NAME',
    "appOracleUsername" = 'pofinfo',
    "appOraclePassword" = 'POFINFO_PASS';

-- ENMAC GIS Location Loader
UPDATE pl_enmac_gis_location_loader."AppServerSettingsTuple"
SET "appHost"           = 'APP_HOST_NAME',
    "appOracleUsername" = 'pofinfo',
    "appOraclePassword" = 'POFINFO_PASS';

-- ENMAC User Loader
UPDATE pl_enmac_user_loader."AppServerSettingsTuple"
SET "appHost"           = 'APP_HOST_NAME',
    "appOracleUsername" = 'pofinfo',
    "appOraclePassword" = 'POFINFO_PASS';

-- ENMAC LiveDB Loader
UPDATE pl_enmac_livedb_loader."AppServerSettingsTuple"
SET "appHost"           = 'APP_HOST_NAME',
    "appOracleUsername" = 'pofinfo',
    "appOraclePassword" = 'POFINFO_PASS';

-- ENMAC GraphDB Loader
UPDATE pl_enmac_graphdb_loader."AppServerSettingsTuple"
SET "appHost"           = 'APP_HOST_NAME',
    "appOracleUsername" = 'pofinfo',
    "appOraclePassword" = 'POFINFO_PASS';

-- ENMAC SOAP
UPDATE pl_enmac_soap."SettingProperty"
SET "char_value" = 'http://APP_HOST_NAME:80/enmac/SOAP/'
WHERE "key" = 'agent.enmac.soap.url';

-- ENMAC SQL
UPDATE pl_enmac_sql."SettingProperty"
SET "char_value" = 'APP_HOST_NAME'
WHERE "key" = 'agent.oracle.host';

UPDATE pl_enmac_sql."SettingProperty"
SET "char_value" = 'pofinfo'
WHERE "key" = 'agent.oracle.user';

UPDATE pl_enmac_sql."SettingProperty"
SET "char_value" = 'POFINFO_PASS'
WHERE "key" = 'agent.oracle.pass';
