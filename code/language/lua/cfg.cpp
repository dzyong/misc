#include <iostream>
#include <vector>
extern "C"{
#include <lauxlib.h>
#include <lualib.h>
};
using namespace std;

namespace{
  void read_global(lua_State* L) {
    lua_getglobal(L,"width"); //FILO for stack
    lua_getglobal(L,"height");
    if(!lua_isnumber(L,-2))
      luaL_error(L,"'width' should be a number\n");
    if(!lua_isnumber(L,-1))
      luaL_error(L,"'height' should be a number\n");
    int width = static_cast<int>(lua_tonumber(L,-2));
    int height = static_cast<int>(lua_tonumber(L,-1));
    printf("width is %d ,height is %d\n",width,height);
    lua_pop(L, 2);
  }

  void read_tableitem(lua_State* L) {
    lua_getglobal(L, "luat_Test1");
    lua_pushstring(L, "a");
    lua_gettable(L, -2); //-2 is table name
    printf("luat_Test1[a]=%d\n", static_cast<int>(lua_tonumber(L, -1)));
    lua_pop(L, 2);
  }

  void read_tableindex(lua_State* L) {
    lua_getglobal(L, "luat_Test2");
    lua_rawgeti(L, -1, 1); // -1 is table name, 1 is index
    printf("luat_Test2[a]=%d\n", static_cast<int>(lua_tonumber(L, -1)));
    lua_pop(L, 2);
  }

  void enum_table(lua_State* L) {
    lua_getglobal(L, "luat_Test1");
    int it = lua_gettop(L); //how many item in stack
    lua_pushnil(L); //mark end of table
    while(lua_next(L, it)) {
      printf("%d ", static_cast<int>(lua_tonumber(L, -1))); //-1 is value, -2 is key
      lua_pop(L, 1);
    }
    printf("\n");
    lua_pop(L, 1);
  }

  void call_func(lua_State* L) {
    lua_getglobal(L,"add"); //fun like a var
    lua_pushnumber(L, 1);
    lua_pushnumber(L, 2);
    if(lua_pcall(L,2,1,0) != 0){ //have 2 param, 1 return, no error handler
      luaL_error(L,"the lua load error! %s",lua_tostring(L,-1));
    }
    int sum = static_cast<int>(lua_tonumber(L,-1));
    lua_pop(L,1);
    printf("%d\n", sum);
  }

  void read_metatable(lua_State* L) {
    lua_getglobal(L, "luat_Test2");
    lua_getmetatable(L, -1);
    lua_pushstring(L, "b");
    lua_gettable(L, -2);
    printf("luat_Test1[b]=%d\n", static_cast<int>(lua_tonumber(L, -1)));
    lua_pop(L, lua_gettop(L));
  }
}

int main(int argc, char *argv[]) {
  vector<const char*> cfgs;
  if (argc == 1)
    cfgs.push_back("cfg.lua");
  else {
    for(auto i = 1; i < argc; i++)
      cfgs.push_back(argv[i]);
  }
  lua_State* L = luaL_newstate();
  luaL_openlibs(L); //init lua internal function
  for(auto cfg:cfgs)
    luaL_dofile(L, cfg); //load custom lua script

  read_global(L);
  read_tableitem(L);
  read_tableindex(L);
  enum_table(L);
  call_func(L);
  read_metatable(L);

  if (lua_gettop(L)) //push/pop is not equal
    fprintf(stderr, "bad stack\n");
  lua_close(L);
  return 0;
}
