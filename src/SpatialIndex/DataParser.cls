Class SpatialIndex.DataParser Extends %RegisteredObject
{

Parameter fileName = "E:\InterSystems\GeoNames\allCountries\allCountries.txt";

ClassMethod ParseCountryFromFile() As %Status
{
	kill ^tmp
	set st = $$$OK
	//Set filename = "C:\My Documents\geoname\RU\cut.txt" 
	Set filename = "E:\InterSystems\GeoNames\allCountries\allCountries.txt" 
	Set stream=##class(%FileCharacterStream).%New() 
	Set stream.Filename=filename
	set indexer = ##class(SpatialIndex.Indexer).%New("^tmp(1)")
	set i=0
	set start=$ZHOROLOG
	WHILE i<90000 { 
	    Set line=stream.ReadLine() 
	    If $Length(line) > 0 { 
	    	set columnList = $ListFromString(line,"	")
			
			/*
			for k=1:1:$LL(columnList)
			{
	    		w i_"-"_k_"............"_$List(columnList,k) ,!
			}
			*/

	        set x=$List(columnList,5)
	        set y=$List(columnList,6)
	        set id=$List(columnList,1)
	        set data=$List(columnList,2)
			do indexer.Insert(x, y, id, data)
	    }
	    if i#1000=0 write "."
	    if i#50000=0 write !
	    set i=i+1
	} 
	set finish=$ZHOROLOG
	
	write !,"Success "_(finish-start) ,!
	return st
}

ClassMethod GetFirstGlobLength() As %Status
{
	set x = $order(^tmp(1,""))
	set l=0
	while (x'=""){
		if ($LENGTH(x)>l) set l=$LENGTH(x)
		set x = $order(^tmp(1,x))
	}
	write l
}

}
