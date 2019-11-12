#!/bin/bash
set -e
WORKDIR=`pwd`

# Parameters
THREADS=$1

CMAKE_ARGS=" -G Ninja\
 -DLLVM_ENABLE_PROJECTS='clang'\
 -DLLVM_USE_LINKER=gold\
 -DLLVM_TARGETS_TO_BUILD=X86\
 -DBUILD_SHARED_LIBS=ON\
 -DCMAKE_BUILD_TYPE=Release\
 -DLLVM_ENABLE_ASSERTIONS=ON"

rm -rf $WORKDIR/build/release
mkdir -p $WORKDIR/build/release

#Build Clang
cd $WORKDIR/build/release
cmake $CMAKE_ARGS ../../llvm-project/llvm
ninja -j$THREADS clang clang-extdef-mapping

#Test Clang
ninja ASTTests && ./tools/clang/unittests/AST/ASTTests
ninja -j$THREADS check-clang-astmerge check-clang-import check-clang-analysis
