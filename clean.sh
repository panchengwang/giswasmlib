#!/bin/sh
echo "欢迎使用pcwang提供的GIS webassembly编译工具！"

GEOS=geos-3.11.1
SQLITE=sqlite-amalgamation-3410200
TIFF=tiff-4.5.0
PROJ=proj-9.2.0
GEOTIFF=libgeotiff-1.7.1
GDAL=gdal-3.5.0

rm -rf src/${GEOS}
rm -rf src/${SQLITE}
rm -rf src/${TIFF}
rm -rf src/${PROJ}
rm -rf src/${GEOTIFF}
rm -rf src/${GDAL}