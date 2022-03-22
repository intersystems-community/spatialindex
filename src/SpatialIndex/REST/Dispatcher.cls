Class SpatialIndex.REST.Dispatcher Extends SpatialIndex.REST.AbstractREST
{

XData UrlMap
{
<Routes>
	<!-- Test method-->
	<Route Url="/test" Method="GET" Call="Test"/>
	
	<!--Get Random Point-->
	<Route Url="/points" Method="GET" Call="GetRandomPoints"/>
	
	<!--Get Neighbourhood-->
	<Route Url="/square/:lat/:lon/:rad" Method="GET" Call="GetNeighbourhood"/>
		
	<!--Get Window-->
	<Route Url="/points/:minx/:miny/:maxx/:maxy" Method="GET" Call="GetWindow"/>
	
</Routes>
}

ClassMethod Test() As %Status
{
	write "{""Status"": ""OK""}"
	return $$$OK
}

ClassMethod GetRandomPoints() As %Status
{
	write "{""Status"": ""OK""}"
	return $$$OK
}

ClassMethod GetNeighbourhood(lat As %String, lon As %String, rad As %String) As %Status
{
	//s rset = ##class(%ResultSet).%New("SpatialIndex.QueryExecutor:FindWindow")
	//d rset.Execute("^tmp(1)",3,15,15)
	//while (rset.Next()){ w rset.Get("Id"),! }
	return $$$OK
}

ClassMethod GetWindow(minx As %String, miny As %String, maxx As %String, maxy As %String) As %Status
{
    set st = $$$OK
    set sql = "SELECT * FROM SpatialIndex.Test WHERE %ID %FIND search_index(x1F,'window','minx="_minx_",miny="_miny_",maxx="_maxx_",maxy="_maxy_"')"
    try {        
        do ##class(%ZEN.Auxiliary.jsonSQLProvider).%WriteJSONFromSQL(,sql)
    } catch ex {
        set st = ex.AsStatus()
    }
    return st
}

}
