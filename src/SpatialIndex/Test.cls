Class SpatialIndex.Test Extends %Persistent
{

Property Name As %String(MAXLEN = 300);

Property Latitude As %String;

Property Longitude As %String;

Index x1F On (Latitude, Longitude) As SpatialIndex.Index;

ClassMethod load(filename As %String = "c:\temp\RUcut.txt", maxline As %Integer = 1000000)
{
	do ..%KillExtent()
	do $system.Process.SetZEOF(1)
	open filename:"R":5
	if '$Test {
		write "cannot open ", filename,!
		quit 
	}
	for i=1:1:maxline{
		use filename read line
		quit:$ZEOF=-1
		set columnList = $ListFromString(line,"	")
		set p = ..%New()
		set p.Name = $List(columnList, 2)
		set p.Latitude=$List(columnList,5)
	    set p.Longitude=$List(columnList,6)
	    set ec = p.%Save()
	    if 'ec {
		    use $Principal zw ec
	    }
	}
	close filename
}

Storage Default
{
<Data name="TestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Latitude</Value>
</Value>
<Value name="4">
<Value>Longitude</Value>
</Value>
</Data>
<DataLocation>^SpatialIndex.TestD</DataLocation>
<DefaultData>TestDefaultData</DefaultData>
<IdLocation>^SpatialIndex.TestD</IdLocation>
<IndexLocation>^SpatialIndex.TestI</IndexLocation>
<StreamLocation>^SpatialIndex.TestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
