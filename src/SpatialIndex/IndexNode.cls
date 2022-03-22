Class SpatialIndex.IndexNode Extends %RegisteredObject
{

Property isLeaf As %Boolean;

Property minX As %Float;

Property minY As %Float;

Property maxX As %Float;

Property maxY As %Float;

Property size As %Integer;

Method %OnNew(minX, minY, maxX, maxY, isLeaf = {$$$YES}, size = 0) As %Status
{
	set ..isLeaf = isLeaf
	set ..minX = minX
	set ..maxX = maxX
	set ..minY = minY
	set ..maxY = maxY
	set ..size = size
	Quit $$$OK
}

ClassMethod Exists(indexGlobal As %String, nodePath As %String) As %Boolean
{
	return $DATA(@indexGlobal@(nodePath))>0
}

ClassMethod Get(indexGlobal As %String, nodePath As %String) As SpatialIndex.IndexNode
{
	s l = @indexGlobal@(nodePath)
	s $lb(minX,minY,maxX,maxY,isLeaf,size) = l
	/*s minY=@indexGlobal@(nodePath, "minY")
	s maxX=@indexGlobal@(nodePath, "maxX")
	s maxY=@indexGlobal@(nodePath, "maxY")
	s isLeaf=@indexGlobal@(nodePath, "isLeaf")
	s size=@indexGlobal@(nodePath, "size")*/
 return ..%New(minX,minY,maxX,maxY,isLeaf,size)
}

ClassMethod Put(indexGlobal As %String, nodePath As %String, node As SpatialIndex.IndexNode)
{
 	s @indexGlobal@(nodePath) = $lb(node.minX,node.minY,node.maxX,node.maxY,node.isLeaf,node.size)
	/*set @indexGlobal@(nodePath, "minX") = node.minX
 set @indexGlobal@(nodePath, "minY") = node.minY
 set @indexGlobal@(nodePath, "maxX") = node.maxX
 set @indexGlobal@(nodePath, "maxY") = node.maxY
 set @indexGlobal@(nodePath, "isLeaf") = node.isLeaf
 set @indexGlobal@(nodePath, "size") = node.size*/
}

}
