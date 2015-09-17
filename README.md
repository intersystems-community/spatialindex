# spatialindex
spatialindex for Caché

do $system.OBJ.LoadDir("c:\work\spatialindex","*.xml","ck")
do $system.OBJ.ExportAllClassesIndividual("c:\work\spatialindex\","/diff",,,"SpatialIndex")
