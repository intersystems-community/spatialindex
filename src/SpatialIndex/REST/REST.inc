ROUTINE SpatialIndex.REST.REST [Type=INC]
#include %occErrors
#include %ZEN.Utils
#define get(%name) $get(%request.Data(%name,1))
#define Debug $d(%request.Data("Debug"))
#define R(%property) %request.Content.##Expression(%property)
#define Public ((%request.GetCgiEnv("SERVER_PORT") = 80) || (%request.GetCgiEnv("SERVER_PORT") = 443))
#define Private '$$$Public