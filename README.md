# spatialindex
spatialindex for Caché

do $system.OBJ.LoadDir("c:\work\spatialindex","ck") 

do $system.OBJ.ExportAllClassesIndividual("c:\work\spatialindex\","/diff",,,"SpatialIndex")


#spattest.mac
 s indexer = ##class(SpatialIndex.Indexer).%New("^tmp(1)")
 for i=0:1:9{
	 for j=0:1:9{
		 d indexer.Insert(i, j, i*10+j)
		 d indexer.Insert(i, j, 100+(i*10)+j)
	 }
 }
 s rset = ##class(%ResultSet).%New("SpatialIndex.QueryExecutor:FindWindow")
 w rset.Execute("^tmp(1)",3,3,15,15),!
 while (rset.Next()){
	 w rset.Get("Id"),!
 }
 
