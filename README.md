#How to use

Import SpatialIndex package.
Define index in class as follows (you can use any index, properties name):

`Index x1f on (Latitude,Longitude) As SpatialIndex.Index;`

See sample class SpatialIndex.Test

Then you can query table with defined index.
Two types of queries are implemented:
window (rectangle) and radius (ellips).

For example:

	SELECT *
	FROM SpatialIndex.Test
	WHERE %ID %FIND search_index(x1F,'window','minx=56,miny=56,maxx=57,maxy=57')

or

	SELECT *
	FROM SpatialIndex.Test
	WHERE  %ID %FIND search_index(x1F,'radius','x=55,y=55,radius=2')
	and name %StartsWith 'Z'

or

	SELECT *
	FROM SpatialIndex.Test
	WHERE  %ID %FIND search_index(x1F,'radius','x=55,y=55,radiusX=2,radiusY=2')
	and name %StartsWith 'Z'
