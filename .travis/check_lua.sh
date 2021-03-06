set -o errexit

if [ $# != 1 ] ; then 
	echo "usage: $0 shell_file_name" 
	echo " e.g.: $0 xxx.sh" 
	exit 1; 
fi 

LUA_HOME_DIR=${TRAVIS_BUILD_DIR}/lua
mkdir -p ${LUA_HOME_DIR}

# lua 5.1
cd ${LUA_HOME_DIR}
LUA_5_1_DIR=${LUA_HOME_DIR}/lua-5.1
curl --location http://www.lua.org/ftp/lua-5.1.tar.gz | tar xz;
cd ${LUA_5_1_DIR}
sudo make linux && sudo make local
${LUA_5_1_DIR}/bin/lua -v

# lua 5.2
cd ${LUA_HOME_DIR}
LUA_5_2_DIR=${LUA_HOME_DIR}/lua-5.2.0
curl --location http://www.lua.org/ftp/lua-5.2.0.tar.gz | tar xz;
cd ${LUA_5_2_DIR}
sudo make linux && sudo make install INSTALL_TOP=${LUA_5_2_DIR}
${LUA_5_2_DIR}/bin/lua -v

# lua 5.3
cd ${LUA_HOME_DIR}
LUA_5_3_DIR=${LUA_HOME_DIR}/lua-5.3.2
curl --location http://www.lua.org/ftp/lua-5.3.2.tar.gz | tar xz;
cd ${LUA_5_3_DIR}
sudo make linux && sudo make install INSTALL_TOP=${LUA_5_3_DIR}
${LUA_5_3_DIR}/bin/lua -v

# lua jit
cd ${LUA_HOME_DIR}
LUA_JIT_DIR=${LUA_HOME_DIR}/LuaJIT
git clone https://github.com/LuaJIT/LuaJIT.git
cd ${LUA_JIT_DIR}
sudo make && sudo make install PREFIX=${LUA_JIT_DIR}
cd ${LUA_JIT_DIR}/bin/
${LUA_JIT_DIR}/bin/luajit -v

echo "===================================================================================================="
echo "==================================== Successfully installed Lua ===================================="
echo "===================================================================================================="

######################################################################
cd ${TRAVIS_BUILD_DIR}
sh $1 ${LUA_5_1_DIR}/bin/lua
sh $1 ${LUA_5_2_DIR}/bin/lua
sh $1 ${LUA_5_3_DIR}/bin/lua
sh $1 ${LUA_JIT_DIR}/bin/luajit
