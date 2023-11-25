#!/bin/bash

# This script file backs up the Peek PostGreSQL database,
# 1) Omitting any loaded data
# 2) Retaining any configuration
# Peek will reload the missing data when it restarts (allows a few hours)

ARGS=""

# Ignore postgres tables
ARGS=${ARGS}' --exclude-table-data public."pgbench_history" '
ARGS=${ARGS}' --exclude-table-data public."pgbench_accounts" '

# Remove the diagram data, but keeo the config, including layers, levels coordsets, etc
ARGS=${ARGS}' --exclude-table-data core_device."GpsLocationHistory" '

# Remove the diagram data, but keeo the config, including layers, levels coordsets, etc
ARGS=${ARGS}' --exclude-table-data pl_diagram."DispBase" '
ARGS=${ARGS}' --exclude-table-data pl_diagram."DispEllipse" '
ARGS=${ARGS}' --exclude-table-data pl_diagram."DispGroup" '
ARGS=${ARGS}' --exclude-table-data pl_diagram."DispGroupItem" '
ARGS=${ARGS}' --exclude-table-data pl_diagram."DispGroupPointer" '
ARGS=${ARGS}' --exclude-table-data pl_diagram."DispPolygon" '
ARGS=${ARGS}' --exclude-table-data pl_diagram."DispPolyline" '
ARGS=${ARGS}' --exclude-table-data pl_diagram."DispEdgeTemplate" '
ARGS=${ARGS}' --exclude-table-data pl_diagram."DispText" '
ARGS=${ARGS}' --exclude-table-data pl_diagram."LiveDbDispLink" '
ARGS=${ARGS}' --exclude-table-data pl_diagram."DispCompilerQueue" '
ARGS=${ARGS}' --exclude-table-data pl_diagram."GridKeyIndex" '
ARGS=${ARGS}' --exclude-table-data pl_diagram."GridKeyCompilerQueue" '
ARGS=${ARGS}' --exclude-table-data pl_diagram."GridKeyIndexCompiled" '
ARGS=${ARGS}' --exclude-table-data pl_diagram."LocationIndex" '
ARGS=${ARGS}' --exclude-table-data pl_diagram."LocationIndexCompilerQueue" '
ARGS=${ARGS}' --exclude-table-data pl_diagram."LocationIndexCompiled" '
ARGS=${ARGS}' --exclude-table-data pl_diagram."BranchIndex" '
ARGS=${ARGS}' --exclude-table-data pl_diagram."BranchIndexEncodedChunk" '
ARGS=${ARGS}' --exclude-table-data pl_diagram."BranchIndexCompilerQueue" '

# Ignore EventDB Events
ARGS=${ARGS}' --exclude-table-data pl_eventdb."EventDBEvent" '
ARGS=${ARGS}' --exclude-table-data _timescaledb_internal.* '

# Ignore the DocDB data
ARGS=${ARGS}' --exclude-table-data core_docdb."DocDbDocument" '
ARGS=${ARGS}' --exclude-table-data core_docdb."DocDbChunkQueue" '
ARGS=${ARGS}' --exclude-table-data core_docdb."DocDbEncodedChunkTuple" '

# Ignore the search data
ARGS=${ARGS}' --exclude-table-data core_search."SearchIndex" '
ARGS=${ARGS}' --exclude-table-data core_search."SearchIndexCompilerQueue" '
ARGS=${ARGS}' --exclude-table-data core_search."EncodedSearchIndexChunk" '
ARGS=${ARGS}' --exclude-table-data core_search."SearchObject" '
ARGS=${ARGS}' --exclude-table-data core_search."SearchObjectRoute" '
ARGS=${ARGS}' --exclude-table-data core_search."SearchObjectCompilerQueue" '
ARGS=${ARGS}' --exclude-table-data core_search."EncodedSearchObjectChunk" '

# Ignore the branches
ARGS=${ARGS}' --exclude-table-data pl_branch."BranchDetail" '

# NOTE, Leave the LiveDB load states, This will reduce the load time.
ARGS=${ARGS}' --exclude-table-data pl_livedb."LiveDbItem" '

# Remove the GraphDB data, This only takes 10 minutes to reload
# The graph chunks
ARGS=${ARGS}' --exclude-table-data pl_graphdb."GraphDbChunkQueue" '
ARGS=${ARGS}' --exclude-table-data pl_graphdb."GraphDbEncodedChunk" '
ARGS=${ARGS}' --exclude-table-data pl_graphdb."GraphDbSegment" '
# The key map
ARGS=${ARGS}' --exclude-table-data pl_graphdb."ItemKeyIndex" '
ARGS=${ARGS}' --exclude-table-data pl_graphdb."ItemKeyIndexCompilerQueue" '
ARGS=${ARGS}' --exclude-table-data pl_graphdb."ItemKeyIndexEncodedChunk" '

# Ignore the user loader state
ARGS=${ARGS}' --exclude-table-data pl_enmac_user_loader."LoadState" '

# Ignore the equipment loader state
ARGS=${ARGS}' --exclude-table-data pl_enmac_equipment_loader."ChunkLoadState" '

# Ignore the work package loader state
ARGS=${ARGS}' --exclude-table-data pl_enmac_switching_loader."ChunkLoadState" '

# Remove the diagram load states from the GIS loader
ARGS=${ARGS}' --exclude-table-data pl_gis_diagram_loader."DxfLoadState" '

# Remove the diagram states from the GIS location loader
ARGS=${ARGS}' --exclude-table-data pl_enmac_gis_location_loader."ChunkLoadState" '

# Remove the DMS diagram load states from the loader
ARGS=${ARGS}' --exclude-table-data pl_enmac_diagram_loader."PageLoadState" '

# NOTE, Leave the LiveDB load states, This will reduce the load time.
ARGS=${ARGS}' --exclude-table-data pl_enmac_graphdb_loader."GraphSegmentLoadState" '

pg_dump  -F p ${ARGS} -f peek_backup.sql --verbose --insert

