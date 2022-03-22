Class SpatialIndex.SQLResult Extends %SQL.AbstractFind
{

Property ResultBits [ MultiDimensional, Private ];

Method %OnNew() As %Status [ Private, ServerOnly = 1 ]
{
	kill i%ResultBits
	kill qHandle
	quit $$$OK
}

Method PrepareFind(indexGlobal As %String, queryType As %String, queryParams As %Binary) As %Status
{
	if queryType = "window" {
		for i = 1:1:4 {
			set item = $Piece(queryParams, ",", i)
			set param = $Piece(item, "=", 1)
			set value = $Piece(item, "=" ,2)
			set arg(param) = value
		}
		//set rset = ##class(%ResultSet).%New("SpatialIndex.QueryExecutor:FindWindow")
	 	//do rset.Execute(indexGlobal,arg("minx"),arg("miny"),arg("maxx"),arg("maxy"))
	 	//while (rset.Next()){
		 //	set id = rset.Get("Id")
	 	set qHandle("indexGlobal") = indexGlobal
	 	do ##class(SpatialIndex.QueryExecutor).InternalFindWindow(.qHandle,arg("minx"),arg("miny"),arg("maxx"),arg("maxy"))
	 	set id = ""
	 	for  {
		 	set id = $O(qHandle("data", id),1,idd)
		 	quit:id=""
	 		set tChunk = (idd\64000)+1, tPos=(idd#64000)+1
	 		set $BIT(i%ResultBits(tChunk),tPos) = 1
	 	}
	}elseif queryType = "radius" {
		/*
		SELECT *
		FROM SpatialIndex.Test
		WHERE  %ID %FIND search_index(x1F,'radius','x=55,y=55,radius=100m')
  		and name %StartsWith 'Z'
  		*/
  		for i = 1:1:$L(queryParams, ",") {
			set item = $Piece(queryParams, ",", i)
			set param = $Piece(item, "=", 1)
			set value = $Piece(item, "=" ,2)
			set arg(param) = value
		}
		set qHandle("indexGlobal") = indexGlobal
		set:'$D(arg("radiusX")) arg("radiusX") = arg("radius")
		set:'$D(arg("radiusY")) arg("radiusY") = arg("radius")
	 	do ##class(SpatialIndex.QueryExecutor).InternalFindRadius(.qHandle,arg("x"),arg("y"),arg("radiusX"),arg("radiusY"))
	 	set id = ""
	 	for  {
		 	set id = $O(qHandle("data", id),1,idd)
		 	quit:id=""
	 		set tChunk = (idd\64000)+1, tPos=(idd#64000)+1
	 		set $BIT(i%ResultBits(tChunk),tPos) = 1
	 	}
	}
	quit $$$OK
}

Method ContainsItem(pItem As %String) As %Boolean
{
	set tChunk = (pItem\64000)+1, tPos=(pItem#64000)+1
	quit $bit($get(i%ResultBits(tChunk)),tPos)
}

Method GetChunk(pChunk As %Integer) As %Binary
{
	quit $get(i%ResultBits(pChunk))
}

Method NextChunk(ByRef pChunk As %Integer = "") As %Binary
{
	set pChunk = $order(i%ResultBits(pChunk),1,tBits)
	quit:pChunk="" ""
	quit tBits
}

Method PreviousChunk(ByRef pChunk As %Integer = "") As %Binary
{
	set pChunk = $order(i%ResultBits(pChunk),-1,tBits)
	quit:pChunk="" ""
	quit tBits
}

}
