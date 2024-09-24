#!/bin/bash

SKYNETROOT=../skynet-cmake/skynet
LUADIR="${SKYNETROOT}/3rd/lua"
SKYNETDIR="${SKYNETROOT}/skynet-src"
OUTFILE=skynetlua.h
rm -f $OUTFILE

cat <<EOF >> $OUTFILE
/*
  skynetlua.h -- Skynet Lua in a single header

  This is Lua contained in a single header to be bundled in C/C++ applications with ease.
  Lua is a powerful, efficient, lightweight, embeddable scripting language.

  Do the following in *one* C file to create the implementation:
    #define LUA_IMPL

  By default it detects the system platform to use, however you could explicitly define one.

  Note that almost no modification was made in the Lua implementation code,
  thus there are some C variable names that may collide with your code,
  therefore it is best to declare the Lua implementation in dedicated C file.

  Optionally provide the following defines:
    LUA_MAKE_LUA     - implement the Lua command line REPL

  LICENSE
    MIT License, same as Lua, see end of file.
*/

/* detect system platform */
#if !defined(LUA_USE_WINDOWS) && !defined(LUA_USE_LINUX) && !defined(LUA_USE_MACOSX) && !defined(LUA_USE_POSIX) && !defined(LUA_USE_C89)
#if defined(_WIN32)
#define LUA_USE_WINDOWS
#elif defined(__linux__)
#define LUA_USE_LINUX
#elif defined(__APPLE__)
#define LUA_USE_MACOSX
#else /* probably a POSIX system */
#define LUA_USE_POSIX
#define LUA_USE_DLOPEN
#endif
#endif

EOF

echo "#ifdef LUA_IMPL" >> $OUTFILE
  echo "#define LUA_CORE" >> $OUTFILE
  cat $LUADIR/lprefix.h >> $OUTFILE
echo "#endif /* LUA_IMPL */" >> $OUTFILE

cat <<EOF >> $OUTFILE
#ifdef __cplusplus
extern "C" {
#endif
EOF

cat $LUADIR/luaconf.h >> $OUTFILE
cat $LUADIR/lua.h >> $OUTFILE
cat $LUADIR/lauxlib.h >> $OUTFILE
cat $LUADIR/lualib.h >> $OUTFILE

cat $SKYNETDIR/atomic.h >> $OUTFILE
cat $SKYNETDIR/rwlock.h >> $OUTFILE
cat $SKYNETDIR/spinlock.h >> $OUTFILE

echo "#ifdef LUA_IMPL" >> $OUTFILE
  # C headers
  echo "typedef struct CallInfo CallInfo;" >> $OUTFILE
  cat $LUADIR/llimits.h >> $OUTFILE
  cat $LUADIR/lobject.h >> $OUTFILE
  cat $LUADIR/lmem.h >> $OUTFILE
  cat $LUADIR/ltm.h >> $OUTFILE
  cat $LUADIR/lstate.h >> $OUTFILE
  cat $LUADIR/lzio.h >> $OUTFILE
  cat $LUADIR/lopcodes.h >> $OUTFILE
  cat $LUADIR/ldebug.h >> $OUTFILE
  cat $LUADIR/ldo.h >> $OUTFILE
  cat $LUADIR/lgc.h >> $OUTFILE
  cat $LUADIR/lfunc.h >> $OUTFILE
  cat $LUADIR/lstring.h >> $OUTFILE
  cat $LUADIR/lundump.h >> $OUTFILE
  cat $LUADIR/lapi.h >> $OUTFILE
  cat $LUADIR/llex.h >> $OUTFILE
  cat $LUADIR/ltable.h >> $OUTFILE
  cat $LUADIR/lparser.h >> $OUTFILE
  cat $LUADIR/lcode.h >> $OUTFILE
  cat $LUADIR/lvm.h >> $OUTFILE
  cat $LUADIR/lctype.h >> $OUTFILE

  # C sources
  cat $LUADIR/lzio.c >> $OUTFILE
  cat $LUADIR/lctype.c >> $OUTFILE
  cat $LUADIR/lopcodes.c >> $OUTFILE
  cat $LUADIR/lmem.c >> $OUTFILE
  cat $LUADIR/lundump.c >> $OUTFILE
  cat $LUADIR/ldump.c >> $OUTFILE
  cat $LUADIR/lstate.c >> $OUTFILE
  cat $LUADIR/lgc.c >> $OUTFILE
  cat $LUADIR/llex.c >> $OUTFILE
  cat $LUADIR/lcode.c >> $OUTFILE
  cat $LUADIR/lparser.c >> $OUTFILE
  cat $LUADIR/ldebug.c >> $OUTFILE
  cat $LUADIR/lfunc.c >> $OUTFILE
  cat $LUADIR/lobject.c >> $OUTFILE
  cat $LUADIR/ltm.c >> $OUTFILE
  cat $LUADIR/lstring.c >> $OUTFILE
  cat $LUADIR/ltable.c >> $OUTFILE
  cat $LUADIR/ldo.c >> $OUTFILE
  cat $LUADIR/lvm.c >> $OUTFILE
  sed -i .bak "/#include \"ljumptab.h\"/r $LUADIR/src/ljumptab.h" $OUTFILE
  cat $LUADIR/lapi.c >> $OUTFILE
  cat $LUADIR/lauxlib.c >> $OUTFILE
  cat $LUADIR/lbaselib.c >> $OUTFILE
  cat $LUADIR/lcorolib.c >> $OUTFILE
  cat $LUADIR/ldblib.c >> $OUTFILE
  cat $LUADIR/liolib.c >> $OUTFILE
  cat $LUADIR/lmathlib.c >> $OUTFILE
  cat $LUADIR/loadlib.c >> $OUTFILE
  cat $LUADIR/loslib.c >> $OUTFILE
  cat $LUADIR/lstrlib.c >> $OUTFILE
  cat $LUADIR/ltablib.c >> $OUTFILE
  cat $LUADIR/lutf8lib.c >> $OUTFILE
  cat $LUADIR/linit.c >> $OUTFILE
echo "#endif /* LUA_IMPL */" >> $OUTFILE

cat <<EOF >> $OUTFILE
#ifdef __cplusplus
}
#endif
EOF

# Implement Lua command line utility when LUA_MAKE_LUA is defined
echo "#ifdef LUA_MAKE_LUA" >> $OUTFILE
cat $LUADIR/lua.c >> $OUTFILE
echo "#endif /* LUA_MAKE_LUA */" >> $OUTFILE

# Comment all include headers
sed -i .bak 's/#include "\([^"]*\)"/\/\*#include "\1"\*\//' $OUTFILE

rm -f *.bak