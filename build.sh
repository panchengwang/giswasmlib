#!/bin/sh
echo "欢迎使用pcwang提供的GIS webassembly编译工具！"

#安装路径
INSTALL_PATH=$(cd $(dirname $0); pwd)/build
mkdir ${INSTALL_PATH}

GEOS=geos-3.11.1
SQLITE=sqlite-amalgamation-3410200
TIFF=tiff-4.5.0
PROJ=proj-9.2.0
GEOTIFF=libgeotiff-1.7.1
GDAL=gdal-3.5.0

cd src

echo "编译geos"
tar -jvxf ${GEOS}.tar.bz2 
cd ${GEOS}
mkdir build
cd build
emcmake cmake -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH -DCMAKE_PREFIX_PATH=$INSTALL_PATH -DBUILD_TESTING=OFF -DCMAKE_BUILD_TYPE=Release ..
emmake make -j 8
emmake make install
cd ../..


echo "编译sqlite3"
unzip ${SQLITE}.zip
cd ${SQLITE}
echo "cmake_minimum_required(VERSION 3.13)" > CMakeLists.txt
echo "add_library(sqlite3 sqlite3.c)" >> CMakeLists.txt
echo "install(TARGETS sqlite3 DESTINATION lib)" >> CMakeLists.txt
echo "install(FILES sqlite3.h DESTINATION include)" >> CMakeLists.txt
mkdir build
cd build
emcmake cmake -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH -DCMAKE_PREFIX_PATH=$INSTALL_PATH -DCMAKE_BUILD_TYPE=Release ..
emmake make 
emmake make install
cd ../..

echo "编译libtiff"
tar zvxf ${TIFF}.tar.gz
cd ${TIFF}
mkdir build
cd build
emcmake cmake -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH -DCMAKE_PREFIX_PATH=$INSTALL_PATH -DBUILD_TESTING=OFF -DCMAKE_BUILD_TYPE=Release ..
emmake make -j 8
emmake make install
cd ../..


echo "编译proj4"
tar zvxf ${PROJ}.tar.gz
cd ${PROJ}
mkdir build
cd build
# -DBUILD_CCT=OFF -DBUILD_CS2CS=OFF -DBUILD_GEOD=OFF -DBUILD_GIE=OFF -DBUILD_PROJ=OFF -DBUILD_PROJINFO=OFF -DBUILD_PROJSYNC=OFF \
emcmake cmake -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH -DCMAKE_PREFIX_PATH=$INSTALL_PATH \
  -DSQLITE3_INCLUDE_DIR=$INSTALL_PATH/include -DSQLITE3_LIBRARY=$INSTALL_PATH/lib/libsqlite3.a \
  -DTIFF_INCLUDE_DIR=$INSTALL_PATH/include -DTIFF_LIBRARY=$INSTALL_PATH/lib/libtiff.a \
  -DENABLE_CURL=OFF \
  -DBUILD_CCT=OFF -DBUILD_CS2CS=OFF -DBUILD_GEOD=OFF -DBUILD_GIE=OFF -DBUILD_PROJ=OFF -DBUILD_PROJINFO=OFF -DBUILD_PROJSYNC=OFF \
  -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF ..
emmake make 
emmake make install
cd ../..


echo "编译libgeotiff"
tar zvxf ${GEOTIFF}.tar.gz
cd ${GEOTIFF}
mkdir build
cd build
emcmake cmake -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH -DCMAKE_PREFIX_PATH=$INSTALL_PATH \
  -DPROJ_LIBRARY=$INSTALL_PATH/lib/libproj.a -DPROJ_INCLUDE_DIR=$INSTALL_PATH/include \
  -DTIFF_INCLUDE_DIR=$INSTALL_PATH/include -DTIFF_LIBRARY=$INSTALL_PATH/lib/libtiff.a \
  -DWITH_UTILITIES=OFF \
  -DCMAKE_BUILD_TYPE=Release ..
emmake make -j 8
emmake make install
cd ../..


echo "编译gdal"
tar zvxf ${GDAL}.tar.gz
cd ${GDAL}
mkdir build
cd build
emcmake cmake -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH -DCMAKE_PREFIX_PATH=$INSTALL_PATH \
  -DPROJ_LIBRARY=$INSTALL_PATH/lib/libproj.a -DPROJ_INCLUDE_DIR=$INSTALL_PATH/include \
  -DGDAL_BUILD_OPTIONAL_DRIVERS=OFF -DOGR_BUILD_OPTIONAL_DRIVERS=OFF \
  -DBUILD_APPS=OFF \
  -DGDAL_USE_GEOTIFF_INTERNAL=ON \
  -DGDAL_USE_JPEG_INTERNAL=ON \
  -DGDAL_USE_JSONC_INTERNAL=ON \
  -DGDAL_USE_GIF_INTERNAL=ON \
  -DGDAL_USE_TIFF_INTERNAL=ON \
  -DGDAL_USE_PNG_INTERNAL=ON \
  -DGDAL_USE_ZLIB_INTERNAL=ON \
  -DGDAL_USE_GEOS=ON -DGEOS_LIBRARY=$INSTALL_PATH/lib/libgeos.a -DGEOS_INCLUDE_DIR=$INSTALL_PATH/include\
  -DBUILD_TESTING=OFF \
  -DCMAKE_BUILD_TYPE=Release ..
emmake make -j 8
emmake make install
cd ../..

