Class SpatialIndex.UnitTest.All Extends %RegisteredObject
{

/// do ##class(SpatialIndex.UnitTest.All).runall()
/// After adding new class, add its export here
ClassMethod runall()
{
	set ^UnitTestRoot = $GET(^UnitTestRoot,"C:\UnitTests")
    set spatialIndexRoot = ^UnitTestRoot_"\spatialindex\"
    do ##class(%File).CreateDirectoryChain(spatialIndexRoot)
    
     try {
	    #dim sc As %Library.Status
	    $$$TOE(sc,$system.OBJ.Export("SpatialIndex.UnitTest.SampleTest.cls",spatialIndexRoot_"SpatialIndex.UnitTest.SampleTest.xml"))
	     
	    $$$TOE(sc,##class(%UnitTest.Manager).RunTestSuites("spatialindex", "/noload/nodelete",""))
    }catch ex {
	    #dim ex As %Exception.StatusException
	    w ex.DisplayString(),!
    }
}

}
