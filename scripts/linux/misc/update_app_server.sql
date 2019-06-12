-- This script updates the app server that Peek points to

-- Update it like so:
-- sed -i 's/APP_HOST_NAME/192.160.10.10/g' dump_config_only.sh
-- sed -i 's/POFINFO_PASS/synerty/g' dump_config_only.sh
-- sed -i 's/SSH_USER/enmac/g' dump_config_only.sh
-- sed -i 's/SSH_PASS/synerty/g' dump_config_only.sh

-- Run it like so
-- psql < dump_config_only.sh

-- PoF Diagram Loader
UPDATE pl_pof_diagram_loader."AppServerSettingsTuple"
SET "appHost" = 'APP_HOST_NAME',
    "appSshUsername" = 'SSH_USER',
    "appSshPassword" = 'SSH_PASS',
    "appOracleUsername" = 'pofinfo',
    "appOraclePassword" = 'POFINFO_PASS';

-- PoF Equipment Loader
UPDATE pl_pof_equipment_loader."AppServerSettingsTuple"
SET "appHost" = 'APP_HOST_NAME',
    "appOracleUsername" = 'pofinfo',
    "appOraclePassword" = 'POFINFO_PASS';

-- PoF GIS Location Loader
UPDATE pl_pof_gis_location_loader."AppServerSettingsTuple"
SET "appHost" = 'APP_HOST_NAME',
    "appOracleUsername" = 'pofinfo',
    "appOraclePassword" = 'POFINFO_PASS';

-- PoF User Loader
UPDATE pl_pof_user_loader."AppServerSettingsTuple"
SET "appHost" = 'APP_HOST_NAME',
    "appOracleUsername" = 'pofinfo',
    "appOraclePassword" = 'POFINFO_PASS';

-- PoF LiveDB Loader
UPDATE pl_pof_livedb_loader."AppServerSettingsTuple"
SET "appHost" = 'APP_HOST_NAME',
    "appOracleUsername" = 'pofinfo',
    "appOraclePassword" = 'POFINFO_PASS';

-- PoF GraphDB Loader
UPDATE pl_pof_graphdb_loader."AppServerSettingsTuple"
SET "appHost" = 'APP_HOST_NAME',
    "appOracleUsername" = 'pofinfo',
    "appOraclePassword" = 'POFINFO_PASS';

-- PoF SOAP
UPDATE pl_pof_soap."SettingProperty"
SET "char_value" = 'http://APP_HOST_NAME:80/enmac/SOAP/'
WHERE "key" = 'agent.enmac.soap.url';

-- PoF SQL
UPDATE pl_pof_sql."SettingProperty"
SET "char_value" = 'APP_HOST_NAME'
WHERE "key" = 'agent.oracle.host';

UPDATE pl_pof_sql."SettingProperty"
SET "char_value" = 'pofinfo'
WHERE "key" = 'agent.oracle.user';

UPDATE pl_pof_sql."SettingProperty"
SET "char_value" = 'POFINFO_PASS'
WHERE "key" = 'agent.oracle.pass';
