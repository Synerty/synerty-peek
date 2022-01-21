.. _win_postgres_backup_restore:


Backup and Restore PostgreSQL DB
````````````````````````````````

Backup
~~~~~~

This section describes how to backup the PostgreSQL database for Peek on a windows
server.

----

Open a Powershell window, and change directory to the location of where you want the
backup placed.

For example:

::

    cd 'C:\Users\Peek\Backups\'

----

Run the following command to execute the backup.

This will create a plain text SQL backup of the database.

::

    pg_dump  -h 127.0.0.1 -U peek -d peek -F p -f peek_backup.sql


Here is another example that provides a smaller backup.

The bulk of the data is left behind, and the loader state tables are reset so
the data is reloaded when the destination peek starts.

::

    pg_dump  -h 127.0.0.1 -U peek -d peek -F p -f peek_backup.sql `
    --exclude-table-data 'pl_diagram.\"DispBase\"' `
    --exclude-table-data 'pl_diagram.\"DispEllipse\"' `
    --exclude-table-data 'pl_diagram.\"DispGroup\"' `
    --exclude-table-data 'pl_diagram.\"DispGroupItem\"' `
    --exclude-table-data 'pl_diagram.\"DispGroupPointer\"' `
    --exclude-table-data 'pl_diagram.\"DispPolygon\"' `
    --exclude-table-data 'pl_diagram.\"DispPolyline\"' `
    --exclude-table-data 'pl_diagram.\"DispText\"' `
    --exclude-table-data 'pl_diagram.\"LiveDbDispLink\"' `
    --exclude-table-data 'pl_diagram.\"DispCompilerQueue\"' `
    --exclude-table-data 'pl_diagram.\"GridKeyIndex\"' `
    --exclude-table-data 'pl_diagram.\"GridKeyCompilerQueue\"' `
    --exclude-table-data 'pl_diagram.\"GridKeyIndexCompiled\"' `
    --exclude-table-data 'pl_diagram.\"LocationIndex\"' `
    --exclude-table-data 'pl_diagram.\"LocationIndexCompilerQueue\"' `
    --exclude-table-data 'pl_diagram.\"LocationIndexCompiled\"' `
    --exclude-table-data 'pl_diagram.\"BranchIndex\"' `
    --exclude-table-data 'pl_diagram.\"BranchIndexEncodedChunk\"' `
    --exclude-table-data 'pl_diagram.\"BranchIndexCompilerQueue\"' `
    --exclude-table-data 'pl_docdb.\"DocDbDocument\"' `
    --exclude-table-data 'pl_docdb.\"DocDbChunkQueue\"' `
    --exclude-table-data 'pl_docdb.\"DocDbEncodedChunkTuple\"' `
    --exclude-table-data 'core_search.\"SearchIndex\"' `
    --exclude-table-data 'core_search.\"SearchIndexCompilerQueue\"' `
    --exclude-table-data 'core_search.\"EncodedSearchIndexChunk\"' `
    --exclude-table-data 'core_search.\"SearchObject\"' `
    --exclude-table-data 'core_search.\"SearchObjectRoute\"' `
    --exclude-table-data 'core_search.\"SearchObjectCompilerQueue\"' `
    --exclude-table-data 'core_search.\"EncodedSearchObjectChunk\"' `
    --exclude-table-data 'pl_branch.\"BranchDetail\"' `
    --exclude-table-data 'pl_livedb.\"LiveDbItem\"' `
    --exclude-table-data 'pl_graphdb.\"GraphDbChunkQueue\"' `
    --exclude-table-data 'pl_graphdb.\"GraphDbEncodedChunk\"' `
    --exclude-table-data 'pl_graphdb.\"GraphDbSegment\"' `
    --exclude-table-data 'pl_graphdb.\"ItemKeyIndex\"' `
    --exclude-table-data 'pl_graphdb.\"ItemKeyIndexCompilerQueue\"' `
    --exclude-table-data 'pl_graphdb.\"ItemKeyIndexEncodedChunk\"' `
    --exclude-table-data 'pl_enmac_user_loader.\"LoadState\"' `
    --exclude-table-data 'pl_gis_diagram_loader.\"DxfLoadState\"' `
    --exclude-table-data 'pl_enmac_gis_location_loader.\"ChunkLoadState\"' `
    --exclude-table-data 'pl_enmac_diagram_loader.\"PageLoadState\"' `
    --exclude-table-data 'pl_enmac_graphdb_loader.\"GraphSegmentLoadState\"' `
    --exclude-table-data 'pl_enmac_switching_loader.\"ChunkLoadState\"' `
    --exclude-table-data 'pl_enmac_equipment_loader.\"ChunkLoadState\"'


pg_dump --data-only --dbname peek --format p --file peek.sql  \
        --exclude-table-data 'core_search."EncodedSearchIndexChunk"' \
        --exclude-table-data 'core_search."EncodedSearchObjectChunk"' \
        --exclude-table-data 'core_search."SearchIndex"' \
        --exclude-table-data 'core_search."SearchIndexCompilerQueue"' \
        --exclude-table-data 'core_search."SearchObject"' \
        --exclude-table-data 'core_search."SearchObjectCompilerQueue"' \
        --exclude-table-data 'core_search."SearchObjectRoute"' \
        --exclude-table-data 'pl_branch."BranchDetail"' \
        --exclude-table-data 'pl_diagram."BranchIndex"' \
        --exclude-table-data 'pl_diagram."BranchIndexCompilerQueue"' \
        --exclude-table-data 'pl_diagram."BranchIndexEncodedChunk"' \
        --exclude-table-data 'pl_diagram."DispBase"' \
        --exclude-table-data 'pl_diagram."DispCompilerQueue"' \
        --exclude-table-data 'pl_diagram."DispEllipse"' \
        --exclude-table-data 'pl_diagram."DispGroup"' \
        --exclude-table-data 'pl_diagram."DispGroupItem"' \
        --exclude-table-data 'pl_diagram."DispGroupPointer"' \
        --exclude-table-data 'pl_diagram."DispPolygon"' \
        --exclude-table-data 'pl_diagram."DispPolyline"' \
        --exclude-table-data 'pl_diagram."DispText"' \
        --exclude-table-data 'pl_diagram."GridKeyCompilerQueue"' \
        --exclude-table-data 'pl_diagram."GridKeyIndex"' \
        --exclude-table-data 'pl_diagram."GridKeyIndexCompiled"' \
        --exclude-table-data 'pl_diagram."LiveDbDispLink"' \
        --exclude-table-data 'pl_diagram."LocationIndex"' \
        --exclude-table-data 'pl_diagram."LocationIndexCompiled"' \
        --exclude-table-data 'pl_diagram."LocationIndexCompilerQueue"' \
        --exclude-table-data 'core_docdb."DocDbChunkQueue"' \
        --exclude-table-data 'core_docdb."DocDbDocument"' \
        --exclude-table-data 'core_docdb."DocDbEncodedChunkTuple"' \
        --exclude-table-data 'pl_gis_diagram_loader."DxfLoadState"' \
        --exclude-table-data 'pl_graphdb."GraphDbChunkQueue"' \
        --exclude-table-data 'pl_graphdb."GraphDbEncodedChunk"' \
        --exclude-table-data 'pl_graphdb."GraphDbSegment"' \
        --exclude-table-data 'pl_graphdb."ItemKeyIndex"' \
        --exclude-table-data 'pl_graphdb."ItemKeyIndexCompilerQueue"' \
        --exclude-table-data 'pl_graphdb."ItemKeyIndexEncodedChunk"' \
        --exclude-table-data 'pl_livedb."LiveDbItem"' \
        --exclude-table-data 'pl_enmac_diagram_loader."PageLoadState"' \
        --exclude-table-data 'pl_enmac_equipment_loader."ChunkLoadState"'  \
        --exclude-table-data 'pl_enmac_gis_location_loader."ChunkLoadState"' \
        --exclude-table-data 'pl_enmac_graphdb_loader."GraphSegmentLoadState"' \
        --exclude-table-data 'pl_enmac_switching_loader."ChunkLoadState"' \
        --exclude-table-data 'pl_enmac_user_loader."LoadState"' \
        --exclude-table-data 'core_device."GpsLocation"' \
        --exclude-table-data 'core_device."GpsLocationHistory"' \
        --exclude-table-data='_timescaledb_internal._hyper*' \
        --exclude-table-data='_timescaledb_catalog.chunk' \
        --exclude-table-data='_timescaledb_catalog.chunk_constraint' \
        --exclude-table-data='_timescaledb_catalog.chunk_index' \
        --exclude-table-data='_timescaledb_catalog.dimension_slice'

OR, This will create a more binary backup format, suitable for restoring onto an existing
peek server. Some databases modules such as postgis, etc will not be dumped with
the custom format.

To backup to the custom format change :code:`-F p` to :code:`-F c` and change the file
name extension from :file:`.sql` to :file:`.dmp`.

::

    pg_dump  -h 127.0.0.1 -U peek -d peek -F c -f peek_backup.dmp `


Restore
~~~~~~~

This section describes how to restore the PostgreSQL database for Peek on a windows
server.

.. warning:: This procedure deletes the existing Peek database.
            Ensure you have everything in order, backed up and correct before executing
            each command. (Including the server your connected to)

----

Stop all Peek services from the windows services.

These can be quickly accessed by pressing CTRL+ESC to bring up the task manager and then
selecting the services tab.

----

Look in the windows tray / notifications area to see if the **PGAdmin4** server is
running.

If it is, right click on it and select **Shutdown Server**

----

Open a Powershell window, and change directory to the location of the backup.
For example:

::

    cd 'C:\Users\Peek\Downloads\v1.1.6.3\'

----

Run the command to drop the existing Peek database.
You won't see any errors or feedback when this succeeds.

::

    dropdb -h 127.0.0.1 -U peek peek


----

Run the command to create a fresh new Peek database.
You won't see any errors or feedback when this succeeds.

::

    createdb -h 127.0.0.1 -U peek -O peek peek

----

To restore a Plain SQL backup (created with :code:`-F p` and extension :file:`.sql`)
use this section.

Restore the PostgreSQL database. This will create the schema and load the data.

::

    psql.exe -h 127.0.0.1 -U peek -d peek -f .\peek_backup.sql


OR, To restore a Custom backup (created with :code:`-F c` and extension :file:`.dmp`)
use this section.

Restore the PostgreSQL database. This will create the schema and load the data.

::

    pg_restore.exe -h 127.0.0.1 -U peek -d peek  peek_backup.dmp

