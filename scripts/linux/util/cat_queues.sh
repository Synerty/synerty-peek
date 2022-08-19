#!/bin/bash

psql <<EOF
select 'SearchObjectCompilerQueue', count(*) from core_search."SearchObjectCompilerQueue" UNION ALL
select 'SearchIndexCompilerQueue', count(*) from core_search."SearchIndexCompilerQueue" UNION ALL
select 'BranchIndexCompilerQueue', count(*) from pl_diagram."BranchIndexCompilerQueue" UNION ALL
select 'DispCompilerQueue', count(*) from pl_diagram."DispCompilerQueue" UNION ALL
select 'GridKeyCompilerQueue', count(*) from pl_diagram."GridKeyCompilerQueue" UNION ALL
select 'LocationIndexCompilerQueue', count(*) from pl_diagram."LocationIndexCompilerQueue" UNION ALL
select 'DocDbChunkQueue', count(*) from core_docdb."DocDbChunkQueue" UNION ALL
select 'GraphDbChunkQueue', count(*) from pl_graphdb."GraphDbChunkQueue" UNION ALL
select 'ItemKeyIndexCompilerQueue', count(*) from pl_graphdb."ItemKeyIndexCompilerQueue" UNION ALL
select 'LiveDbRawValueQueue', count(*) from pl_livedb."LiveDbRawValueQueue";
EOF


