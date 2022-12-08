# Angel Siachoque Rodriguez, 201815355. Nicolas Munevar Miranda, 201820040
rm(list=ls())
R.version.string
# R version 4.2.2
#Se instalan los paquetes, y posteriormente se llaman para tenerlos disponibles.
install.packages("pacman")
install.packages("sf")
install.packages("leaflet")
install.packages("rvest")
install.packages("xm12")
install.packages("osmdata")
install.packages("ggsn")
require(pacman)
require(sf)
require(leaflet)
require(rvest)
require(osmdata)
require(ggsn)
#Para llamar librerías de la clase se usa la funcion p_load.
#Con esto podemos tener a la mano, al menos, la libreria tidyverse y rio.
p_load(tidyverse,
       rio,
       sf,
       leaflet,
       skimr,
       tmaptools,
       ggsn,
       osmdata,
       arrow,
       brom,
       mfx,
       margins,
       estimatr,
       lmtest,
       fixest,
       modelsummary,
       stargazer,
       rvest)
# 1) Ejercicio de regresion
#se importan los datos
df <- import("input/data_regresiones.rds")
lm(formula = price ~ dist_cbd + dist_cole + dist_park, data = df)
lm(formula = price ~ rooms + bathrooms + surface_total, data = df)
# 2) Ejercicio de Datos Espaciales
barranquilla = geocode_OSM("Barranquilla Colombia", as.sf = T)
leaflet() %>% addTiles() %>% addCircles(data=barranquilla)
available_features() %>% head(20)
available_tags("amenity") %>% head(20)
available_tags("leisure") %>% head(20)
opq(bbox = getbb("Barranquilla Colombia"))
##Restaurantes de Barranquilla
# objeto osm
osm = opq(bbox = getbb("Barranquilla Colombia")) %>%
  add_osm_feature(key="amenity" , value="restaurant") 
class(osm)

# extraer Simple Features Collection
osm_sf = osm %>% osmdata_sf()
osm_sf

# Obtener un objeto sf
restaurant = osm_sf$osm_points %>% select(osm_id,amenity) 
restaurant

#Pintar los restaurantes
leaflet() %>% addTiles() %>% addCircleMarkers(data=restaurant , col="red")
##Parques de Barranquilla
# objeto osm
osm = opq(bbox = getbb("Barranquilla Colombia")) %>%
  add_osm_feature(key="leisure" , value="park") 
class(osm)

# extraer Simple Features Collection
osm_sf = osm %>% osmdata_sf()
osm_sf

# Obtener un objeto sf
park = osm_sf$osm_polygons %>% select(osm_id,leisure) 
park

# Pintar los restaurantes
leaflet() %>% addTiles() %>% addPolygons(data=restaurant , col="green")


#Geocodificacion
mi_casa = geocode_OSM("Carrera 78 %23% 82-15, Barranquilla", as.sf=T) 
mi_casa

#Exportar mapa


#3) Ejercicio de Web Scrapping
#
browseURL("https://es.wikipedia.org/wiki/Departamentos_de_Colombia")
xml_document <- 
  '<!DOCTYPE html> 
<html>
<meta charset="utf-8">
<head>
<title> Título de la página: ejemplo de clase </title>
</head>
<body>
<h1> Departamentos de Colombia.</h1>
<h2> Wikipedia: <u>Hipervínculo a una página Wiki</u>. </h2>
<p> Este es un párrafo muy pequeño que se encuentra dentro de la etiqueta <b>p</b> de <i>html</i> </p>
<a href="https://es.wikipedia.org/wiki/Departamentos_de_Colombia"> link a wikipedia </a>
</body>
</html>'

write.table(x=xml_document , file='my_page.html' , quote=F , col.names=F , row.names=F)
browseURL("my_page.html")

my_url = "https://es.wikipedia.org/wiki/Departamentos_de_Colombia"
xml_document = read_html(my_url)
class(xml_document)
#Búsqueda de título de la pagina con y sin xpath
xml_document %>% html_elements("h1") %>% html_text()
xml_document %>% html_node(xpath='/html/body/div[3]/h1')
#Extraer tabla
my_table = xml_document %>% html_table()
length(my_table)
my_table[[4]]
View(my_table[[4]])
export(x=my_table[[4]], file="output/tabla_departamento.xlsx")
#Extraer parrafos del documento
sub_html = xml_document %>% html_nodes(xpath='/html')
elements = sub_html %>% html_nodes("p")
export(x=elements, file="output/nube_palabras.png")