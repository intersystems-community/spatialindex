Class SpatialIndex.Indexer Extends %RegisteredObject
{

Parameter NODESIZE = 100;

Parameter ROOTNODE = " ";

Parameter EPS = 0.0001;

Parameter MINX = -180;

Parameter MINY = -90;

Parameter MAXX = {180 + ..#EPS};

Parameter MAXY = {90 + ..#EPS};

Property indexGlobal As %String [ Private ];

Method %OnNew(indexGlobal As %String) As %Status
{
	set ..indexGlobal = indexGlobal
	if ('##class(IndexNode).Exists(indexGlobal, ..#ROOTNODE)){
		do ##class(IndexNode).Put(indexGlobal, ..#ROOTNODE,
			{"isLeaf":($$$YES), "minX":(..#MINX), "maxX":(..#MAXX), "minY":(..#MINY), "maxY":(..#MAXY), "size":0})
	}
	return $$$OK
}

Method Insert(x As %Float, y As %Float, id As %String, data As %String = "", block As %String = {..#ROOTNODE}, node As IndexNode = "")
{
	set:node="" node = ##class(IndexNode).Get(..indexGlobal, block)
	if ('..IsInside(x, y, node)) return
	if (node.isLeaf){
		if ('..LeafContains(x, y, block)) {
			set node.size = node.size + 1
			do ##class(IndexNode).Put(..indexGlobal, block, node)
		}
		set @..indexGlobal@(block, "data", x, y, id) = data
		if (node.size > ..#NODESIZE) do ..Split(block, node)
	}
	else{
		for i=0:1:3 {
			do ..Insert(x, y, id, data, block_i)
		}
	}
}

Method Delete(x As %Float, y As %Float, id As %String, block As %String = {..#ROOTNODE})
{
	#dim node As IndexNode
	set node = ##class(IndexNode).Get(..indexGlobal, block)
	if ('..IsInside(x, y, node)) return
	if (node.isLeaf){
		if ('..LeafContains(x, y, block)) {
			//TODO: throw error
			return
		}
		kill @..indexGlobal@(block, "data", x, y, id)
		if ('..LeafContains(x, y, block)){
			set node.size=node.size-1
			do ##class(IndexNode).Put(..indexGlobal, block, node)
		}
		
	}
	else{
		for i=0:1:3 {
			do ..Delete(x, y, id, block_i)
		}
	}
}

Method IsInside(x As %Float, y As %Float, node As IndexNode) As %Boolean
{
	return (x>=node.minX) && (x<node.maxX) && (y>=node.minY) && (y<node.maxY)
}

Method LeafContains(x As %Float, y As %Float, block As %String) As %Boolean
{
	return $DATA(@..indexGlobal@(block, "data", x, y))>0
}

Method Split(block As %String, node As IndexNode)
{
	set midX = (node.minX+node.maxX)/2
	set midY = (node.minY+node.maxY)/2
	
	// Create subnodes
	set nodes(0) = ##class(IndexNode).%New(node.minX, node.minY, midX, midY)
	set nodes(1) = ##class(IndexNode).%New(midX, node.minY, node.maxX, midY)
	set nodes(2) = ##class(IndexNode).%New(node.minX, midY, midX, node.maxY)
	set nodes(3) = ##class(IndexNode).%New(midX, midY, node.maxX, node.maxY)
	
	// Saving structure
	set node.isLeaf = $$$NO
	set node.size = 0
	do ##class(IndexNode).Put(..indexGlobal, block, node)
	for i=0:1:3 {
		do ##class(IndexNode).Put(..indexGlobal, block_i, nodes(i))
	}
	
	// Reinsert data into node. Since it's not leaf, data will be inserted in subnodes
	set x = $o(@..indexGlobal@(block, "data", ""))
	while (x'=""){
		set y = $o(@..indexGlobal@(block, "data", x, ""))
		while (y'=""){
			set id = $o(@..indexGlobal@(block, "data", x, y, ""))
			while (id'=""){
				do ..Insert(x, y, id, @..indexGlobal@(block, "data", x, y, id), block, node)
				set id = $o(@..indexGlobal@(block, "data", x, y, id))
			}
			set y = $o(@..indexGlobal@(block, "data", x, y))
		}
		set x = $o(@..indexGlobal@(block, "data", x))
	}
	kill @..indexGlobal@(block, "data")
}

}
