set -o errexit

if [ $# != 1 ] ; then 
	echo "usage: $0 shell_file_name" 
	echo " e.g.: $0 xxx.sh" 
	exit 1; 
fi 

WORKSPACE_DIR=${TRAVIS_BUILD_DIR}/coverage
mkdir -p ${WORKSPACE_DIR}
cd ${WORKSPACE_DIR}

LUA_5_3_DIR=${WORKSPACE_DIR}/lua-5.3.2
curl --location http://www.lua.org/ftp/lua-5.3.2.tar.gz | tar xz;
cd ${LUA_5_3_DIR}
sudo make linux && sudo make install INSTALL_TOP=${LUA_5_3_DIR}
${LUA_5_3_DIR}/bin/lua -v

cd ${WORKSPACE_DIR}
LUAROCKS_DIR=${WORKSPACE_DIR}/luarocks-2.3.0
curl --location http://luarocks.org/releases/luarocks-2.3.0.tar.gz | tar xz;
cd ${LUAROCKS_DIR}
./configure --with-lua=${LUA_5_3_DIR}; sudo make bootstrap

sudo luarocks install luacov-coveralls

cd ${TRAVIS_BUILD_DIR}
SHELL_FILE=$1
sh ${SHELL_FILE} ${LUA_5_3_DIR}/bin/lua
