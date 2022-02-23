---
title: "在 CLFS for LoongArch 上运行 Minecraft"
date: 2021-12-27
tags: ["Minecraft", "LoongArch"]
categories: ["LoongArch"]
---

简单介绍在 CLFS for LoongArch 上运行 Minecraft 的过程。

<!--more-->

## CLFS



## assimp

高版本的 gcc 会报额外的警告，而 assimp 默认开了 `-Werror`，导致无法编译通过，手动关闭这些警告（`-Wno-array-compare`）。

```bash
git clone https://github.com/assimp/assimp.git
pushd assimp
    cmake -DCMAKE_C_FLAGS="-Wno-array-compare" -DCMAKE_CXX_FLAGS="-Wno-array-compare" CMakeLists.txt
    make -j4
    sudo make install
popd
```

## GLFW

```bash
git clone https://github.com/glfw/glfw.git
pushd glfw
    cmake -S . -B build
    cd build
    make -j4
    sudo make install
popd
```

## bgfx

bgfx 依赖于二进制的 GENie，需要先编译 GENie。

有很多 x86 gcc 专用的标志，但不会改生成脚本怎么办，生成后直接用 `sed` 把它们删了（暴力大法好）。

```bash
git clone https://github.com/bkaradzic/GENie.git
pushd GENie
    sed -i 's/-m64//g' build/gmake.linux/genie.make
    make -j4
popd

git clone git://github.com/bkaradzic/bx.git
pushd bx
    cp ../GENie/bin/linux/genie tools/bin/linux/genie
popd

git clone git://github.com/bkaradzic/bimg.git
pushd bimg
    # 补丁内容见后文
    git apply bimp.patch
popd

git clone git://github.com/bkaradzic/bgfx.git
pushd bgfx
    make .build/projects/gmake-linux
    sed -i 's/-mfpmath=sse//g' .build/projects/gmake-linux/*
    sed -i 's/-msse2//g' .build/projects/gmake-linux/*
    sed -i 's/-m64//g' .build/projects/gmake-linux/*
    CFLAGS="-Wno-maybe-uninitialized" CXXFLAGS="-Wno-maybe-uninitialized" make -j4 linux-release64
    sudo cp .build/linux64_gcc/bin/libbgfx-shared-libRelease.so /usr/local/lib64/libbgfx.so
    sudo cp .build/linux64_gcc/bin/geometrycRelease /usr/local/bin/geometryc
    sudo cp .build/linux64_gcc/bin/texturecRelease /usr/local/bin/texturec
    sudo cp .build/linux64_gcc/bin/texturevRelease /usr/local/bin/texturev
    sudo cp .build/linux64_gcc/bin/shadercRelease /usr/local/bin/shaderc
popd
```

其中 `bimp.patch` 的内容如下：

```text
diff --git a/3rdparty/nvtt/nvcore/debug.h b/3rdparty/nvtt/nvcore/debug.h
index 31d0f51..5964c5d 100644
--- a/3rdparty/nvtt/nvcore/debug.h
+++ b/3rdparty/nvtt/nvcore/debug.h
@@ -165,7 +165,7 @@ NVCORE_API void NV_CDECL nvDebugPrint( const char *msg, ... ) __attribute__((for
 namespace nv
 {
     inline bool isValidPtr(const void * ptr) {
-    #if NV_CPU_X86_64 || NV_CPU_AARCH64
+    #if NV_CPU_X86_64 || NV_CPU_AARCH64 || NV_CPU_LOONGARCH64
         if (ptr == NULL) return true;
         if (reinterpret_cast<uint64>(ptr) < 0x10000ULL) return false;
         if (reinterpret_cast<uint64>(ptr) >= 0x000007FFFFFEFFFFULL) return false;
diff --git a/3rdparty/nvtt/nvcore/nvcore.h b/3rdparty/nvtt/nvcore/nvcore.h
index 5bd5d7b..8abe5cf 100644
--- a/3rdparty/nvtt/nvcore/nvcore.h
+++ b/3rdparty/nvtt/nvcore/nvcore.h
@@ -141,6 +141,8 @@
 #   define NV_CPU_AARCH64 1
 #elif defined POSH_CPU_EMSCRIPTEN
 #   define NV_CPU_EMSCRIPTEN 1
+#elif defined POSH_CPU_LOONGARCH64
+#   define NV_CPU_LOONGARCH64 1
 #else
 #   error "Unsupported CPU"
 #endif
diff --git a/3rdparty/nvtt/nvcore/posh.h b/3rdparty/nvtt/nvcore/posh.h
index d951174..3bb3090 100644
--- a/3rdparty/nvtt/nvcore/posh.h
+++ b/3rdparty/nvtt/nvcore/posh.h
@@ -538,6 +538,11 @@ LLVM:
 #  define POSH_CPU_STRING "PA-RISC"
 #endif

+#if defined __loongarch__
+#  define POSH_CPU_LOONGARCH64 1
+#  define POSH_CPU_STRING "LoongArch64"
+#endif
+
 #if defined EMSCRIPTEN
 #  define POSH_CPU_EMSCRIPTEN 1
 #  define POSH_CPU_STRING "EMSCRIPTEN"
@@ -680,7 +685,7 @@ LLVM:
 ** the MIPS series, so we have to be careful about those.
 ** ----------------------------------------------------------------------------
 */
-#if defined POSH_CPU_X86 || defined POSH_CPU_AXP || defined POSH_CPU_STRONGARM || defined POSH_CPU_AARCH64 || defined POSH_OS_WIN32 || defined POSH_OS_WINCE || defined __MIPSEL__ || defined POSH_CPU_EMSCRIPTEN
+#if defined POSH_CPU_X86 || defined POSH_CPU_AXP || defined POSH_CPU_STRONGARM || defined POSH_CPU_AARCH64 || defined POSH_OS_WIN32 || defined POSH_OS_WINCE || defined __MIPSEL__ || defined POSH_CPU_EMSCRIPTEN || defined POSH_CPU_LOONGARCH64
 #  define POSH_ENDIAN_STRING "little"
 #  define POSH_LITTLE_ENDIAN 1
 #else
```

## OpenAL Soft

```bash
git clone https://github.com/kcat/openal-soft.git
pushd openal-soft
    cd build
    cmake ..
    make -j4
    sudo make install
popd
```

## OpenXR loader

```bash
git clone https://github.com/KhronosGroup/OpenXR-SDK.git
pushd OpenXR-SDK
    mkdir -p build/linux_release
    cd build/linux_release
    cmake -DCMAKE_BUILD_TYPE=Release ../..
    make -j4
    sudo make install
popd
```

## OpenJDK

```bash
git clone https://github.com/openjdk/jdk.git
pushd jdk
    bash configure --with-boot-jdk=../jdk-11.0.12
    make LP64=1 BUILD_CC="gcc" images
popd
```

## Gradle

```bash
wget https://downloads.gradle-dn.com/distributions/gradle-7.3.3-all.zip
unzip gradle-7.3.3-all.zip
```

## Apache Ant

```bash
wget https://downloads.apache.org/ant/source/apache-ant-1.10.12-src.tar.bz2
tar xf apache-ant-1.10.12-src.tar.bz2
pushd apache-ant-1.10.12
    sh build.sh dist
popd
```

## OpenJFX
