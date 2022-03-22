Class SpatialIndex.Index Extends %Library.FunctionalIndex [ System = 3 ]
{

ClassMethod DeleteIndex(pID As %CacheString, pArg... As %Binary) [ CodeMode = generator, ServerOnly = 1 ]
{
	if %mode'="method" {
		set IndexGlobal = ..IndexLocation(%class,%property)
		$$$GENERATE($C(9)_"set indexer = ##class(SpatialIndex.Indexer).%New($Name("_IndexGlobal_"))")
		$$$GENERATE($C(9)_"do indexer.Delete(pArg(1),pArg(2),pID)")
	}
}

/// This method is invoked when an existing instance of va class is deleted.
ClassMethod Find(queryType As %Binary, queryParams As %String) As %Library.Binary [ CodeMode = generator, ServerOnly = 1, SqlProc ]
{
	if %mode'="method" {
		set IndexGlobal = ..IndexLocation(%class,%property)
		set IndexGlobalQ = $$$QUOTE(IndexGlobal)
		$$$GENERATE($C(9)_"set result = ##class(SpatialIndex.SQLResult).%New()")
		$$$GENERATE($C(9)_"do result.PrepareFind($Name("_IndexGlobal_"), queryType, queryParams)")
		$$$GENERATE($C(9)_"quit result")
	}
}

/// This method is invoked when a new instance of a class is inserted into the database.
ClassMethod InsertIndex(pID As %CacheString, pArg... As %Binary) [ CodeMode = generator, ServerOnly = 1 ]
{
	if %mode'="method" {
		set IndexGlobal = ..IndexLocation(%class,%property)
		$$$GENERATE($C(9)_"set indexer = ##class(SpatialIndex.Indexer).%New($Name("_IndexGlobal_"))")
		$$$GENERATE($C(9)_"do indexer.Insert(pArg(1),pArg(2),pID)")
	}
}

ClassMethod PurgeIndex() [ CodeMode = generator, ServerOnly = 1 ]
{
	if %mode'="method" {
		set IndexGlobal = ..IndexLocation(%class,%property)
		$$$GENERATE($C(9)_"kill " _ IndexGlobal)
	}
}

/// This method is invoked when an existing instance of a class is updated.
ClassMethod UpdateIndex(pID As %CacheString, pArg... As %Binary) [ CodeMode = generator, ServerOnly = 1 ]
{
	if %mode'="method" {
		set IndexGlobal = ..IndexLocation(%class,%property)
		$$$GENERATE($C(9)_"set indexer = ##class(SpatialIndex.Indexer).%New($Name("_IndexGlobal_"))")
		$$$GENERATE($C(9)_"do indexer.Delete(pArg(3),pArg(4),pID)")
		$$$GENERATE($C(9)_"do indexer.Insert(pArg(1),pArg(2),pID)")
	}
}

ClassMethod SortBeginIndex() [ CodeMode = generator, ServerOnly = 1 ]
{
	$$$GENERATE($C(9)_"set a = 0")
}

ClassMethod SortEndIndex(pCommit As %Integer = 1) [ CodeMode = generator, ServerOnly = 1 ]
{
	$$$GENERATE($C(9)_"set a = 0")
}

ClassMethod IndexLocation(className As %String, indexName As %String) As %String
{
	set storage = ##class(%Dictionary.ClassDefinition).%OpenId(className).Storages.GetAt(1).IndexLocation
	quit $Name(@storage@(indexName))
}

}
