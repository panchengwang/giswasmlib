#!/bin/sh
echo "欢迎使用pcwang提供的GIS webassembly编译工具！"

#安装路径
INSTALL_PATH=$(cd $(dirname $0); pwd)/build
mkdir ${INSTALL_PATH}
PARALLEL_NUM=16

PGSQL_VERSION=15.3
GDAL_VERSION=release/3.7
PROJ_VERSION=9.2
GEOS_VERSION=main
POSTGIS_VERSION=stable-3.3
GEOTIFF_VERSION=master

# 下载源代码
mkdir src
cd src

echo "从github下载gdal 版本分支: ${GDAL_VERSION}, 请等待..."
git clone https://github.com/OSGeo/GDAL.git -b ${GDAL_VERSION}
echo "gdal下载成功"

echo "从github下载proj 版本分支: ${PROJ_VERSION}, 请等待..."
git clone https://github.com/OSGeo/PROJ.git -b ${PROJ_VERSION}
echo "proj下载成功"

echo "从github下载geos 版本分支: ${GEOS_VERSION}, 请等待..."
git clone https://github.com/libgeos/geos.git -b ${GEOS_VERSION}
echo "geos下载成功"

# echo "从github下载postgis 版本分支: ${POSTGIS_VERSION}, 请等待..."
# git clone https://github.com/postgis/postgis.git -b ${POSTGIS_VERSION}
# echo "postgis下载成功"

echo "从github下载libgeotiff 版本分支: ${GEOTIFF_VERSION}, 请等待..."
git clone https://github.com/OSGeo/libgeotiff.git -b ${GEOTIFF_VERSION}
echo "libgeotiff下载成功"

# 必要时需要修改以下下载sqlite3的代码
SQLITE=sqlite-amalgamation-3420000
wget -c https://www.sqlite.org/2023/${SQLITE}.zip

# GEOS=geos-3.11.1
# SQLITE=sqlite-amalgamation-3410200
TIFF=tiff-4.5.0
wget -c http://download.osgeo.org/libtiff/${TIFF}.tar.gz
# PROJ=proj-9.2.0
# GEOTIFF=libgeotiff-1.7.1
# GDAL=gdal-3.5.0



echo "编译geos"
mkdir geos/build
cd geos/build
emcmake cmake -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH -DCMAKE_PREFIX_PATH=$INSTALL_PATH -DBUILD_TESTING=OFF -DCMAKE_BUILD_TYPE=Release ..
emmake make -j ${PARALLEL_NUM}
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
emmake make -j ${PARALLEL_NUM}
emmake make install
cd ../..


echo "编译proj4"
mkdir PROJ/build
cd PROJ/build
# -DBUILD_CCT=OFF -DBUILD_CS2CS=OFF -DBUILD_GEOD=OFF -DBUILD_GIE=OFF -DBUILD_PROJ=OFF -DBUILD_PROJINFO=OFF -DBUILD_PROJSYNC=OFF \
emcmake cmake -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH -DCMAKE_PREFIX_PATH=$INSTALL_PATH \
  -DSQLITE3_INCLUDE_DIR=$INSTALL_PATH/include -DSQLITE3_LIBRARY=$INSTALL_PATH/lib/libsqlite3.a \
  -DTIFF_INCLUDE_DIR=$INSTALL_PATH/include -DTIFF_LIBRARY=$INSTALL_PATH/lib/libtiff.a \
  -DENABLE_CURL=OFF \
  -DBUILD_CCT=OFF -DBUILD_CS2CS=OFF -DBUILD_GEOD=OFF -DBUILD_GIE=OFF -DBUILD_PROJ=OFF -DBUILD_PROJINFO=OFF -DBUILD_PROJSYNC=OFF \
  -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF ..
emmake make -j ${PARALLEL_NUM}
emmake make install
cd ../..


echo "编译安装libgeotiff"
mkdir libgeotiff/libgeotiff/build
cd libgeotiff/libgeotiff/build
emcmake cmake -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH -DCMAKE_PREFIX_PATH=$INSTALL_PATH \
  -DPROJ_LIBRARY=$INSTALL_PATH/lib/libproj.a -DPROJ_INCLUDE_DIR=$INSTALL_PATH/include \
  -DTIFF_INCLUDE_DIR=$INSTALL_PATH/include -DTIFF_LIBRARY=$INSTALL_PATH/lib/libtiff.a \
  -DWITH_UTILITIES=OFF \
  -DCMAKE_BUILD_TYPE=Release ..
emmake make -j ${PARALLEL_NUM}
emmake make install
cd ../../..


echo "编译安装gdal"
mkdir GDAL/build
cd GDAL/build
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
emmake make -j ${PARALLEL_NUM}
emmake make install
cd ../..

