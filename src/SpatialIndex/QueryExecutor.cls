Class SpatialIndex.QueryExecutor Extends %RegisteredObject
{

Query FindWindow(indexGlobal As %String, minX As %Float, minY As %Float, maxX As %Float, maxY As %Float) As %Query(ROWSPEC = "Id")
{
}

ClassMethod FindWindowExecute(ByRef qHandle As %Binary, indexGlobal As %String, minX As %Float, minY As %Float, maxX As %Float, maxY As %Float) As %Status
{
	set qHandle("indexGlobal") = indexGlobal
	do ..InternalFindWindow(.qHandle, minX, minY, maxX, maxY)
	return $$$OK
}

ClassMethod FindWindowFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Boolean) As %Status
{
	set index = $i(qHandle("index"))
	set AtEnd = index>=$G(qHandle("data"))
	set Row = $lb(qHandle("data", index))
	return $$$OK
}

ClassMethod InternalFindWindow(ByRef qHandle As %Binary, minX As %Float, minY As %Float, maxX As %Float, maxY As %Float, block As %String = {##class(Indexer).#ROOTNODE})
{
	if (minX>maxX){
		do ..InternalFindWindow(.qHandle, minX, minY, ##class(Indexer).#MAXX, maxY, block)
		do ..InternalFindWindow(.qHandle, ##class(Indexer).#MINX, minY, maxX, maxY, block)
		return
	}
	set indexGlobal = qHandle("indexGlobal")
	#dim node as IndexNode = ##class(IndexNode).Get(indexGlobal, block)
	if ((minX>=node.maxX) || (maxX<node.minX)) return
	if ((minY>=node.maxY) || (maxY<node.minY)) return
	if (node.isLeaf){
		set x = ""
		while ($$$YES){
			set x = $o(@indexGlobal@(block, "data", x))
			quit:x=""
			if ((x<minX) || (x>=maxX)) continue
			
			set y = ""
			while ($$$YES){
				set y = $o(@indexGlobal@(block, "data", x, y))
				quit:y=""
				if ((y<minY) || (y>=maxY)) continue
				
				set id = $o(@indexGlobal@(block, "data", x, y, ""))
				while (id'=""){
					set index = $i(qHandle("data"))
					set qHandle("data", index) = id
					set id = $o(@indexGlobal@(block, "data", x, y, id))
				}
			}
		}
		return
	}
	for i=0:1:3 {
		do ..InternalFindWindow(.qHandle, minX, minY, maxX, maxY, block_i)
	}
}

Query FindRadius(indexGlobal As %String, cX As %Float, cY As %Float, radiusX As %Float, radiusY As %Float) As %Query(ROWSPEC = "Id")
{
}

ClassMethod FindRadiusExecute(ByRef qHandle As %Binary, indexGlobal As %String, cX As %Float, cY As %Float, radiusX As %Float, radiusY As %Float) As %Status
{
	set qHandle("indexGlobal") = indexGlobal
	do ..InternalFindRadius(.qHandle, cX, cY, radiusX, radiusY)
	return $$$OK
}

ClassMethod FindRadiusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Boolean) As %Status
{
	set index = $i(qHandle("index"))
	set AtEnd = index>=$G(qHandle("data"))
	set Row = $lb(qHandle("data", index))
	return $$$OK
}

ClassMethod InternalFindRadius(ByRef qHandle As %Binary, cX As %Float, cY As %Float, radiusX As %Float, radiusY As %Float, block As %String = {##class(Indexer).#ROOTNODE})
{
	set indexGlobal = qHandle("indexGlobal")
	#dim node as IndexNode = ##class(IndexNode).Get(indexGlobal, block)
	set intersect = $$$NO
	if (((cX+radiusX)>=node.minX) && ((cX-radiusX)<node.maxX) && (cY>=node.minY) && (cY<node.maxY)) set intersect = $$$YES
	if ((cX>=node.minX) && (cX<node.maxX) && ((cY+radiusY)>=node.minY) && ((cY-radiusY)<node.maxY)) set intersect = $$$YES
	if (..IsInEllipse(cX, cY, radiusX, radiusY, node.minX, node.minY)) set intersect = $$$YES
	if (..IsInEllipse(cX, cY, radiusX, radiusY, node.minX, node.maxY)) set intersect = $$$YES
	if (..IsInEllipse(cX, cY, radiusX, radiusY, node.maxX, node.minY)) set intersect = $$$YES
	if (..IsInEllipse(cX, cY, radiusX, radiusY, node.maxX, node.maxY)) set intersect = $$$YES
	if ('intersect) return
	if (node.isLeaf){
		set x = ""
		while ($$$YES){
			set x = $o(@indexGlobal@(block, "data", x))
			quit:x=""
			if ((x<(cX-radiusX)) || (x>=(cX+radiusX))) continue
			
			set y = ""
			while ($$$YES){
				set y = $o(@indexGlobal@(block, "data", x, y))
				quit:y=""
				if ((y<(cY-radiusY)) || (y>=(cY+radiusY))) continue
				
				set id = ""
				while ($$$YES){
					set id = $o(@indexGlobal@(block, "data", x, y, id))
					quit:id=""
					if ('..IsInEllipse(cX, cY, radiusX, radiusY, x, y)) continue
					set index = $i(qHandle("data"))
					set qHandle("data", index) = id
				}
			}
		}
		return
	}
	for i=0:1:3 {
		do ..InternalFindRadius(.qHandle, cX, cY, radiusX, radiusY, block_i)
	}
}

ClassMethod IsInEllipse(cX As %Float, cY As %Float, radiusX As %Float, radiusY As %Float, x As %Float, y As %Float) As %Boolean
{
		set x = (x-cX)/radiusX
		set y = (y-cY)/radiusY
		return (x*x)+(y*y)<=1
}

}
