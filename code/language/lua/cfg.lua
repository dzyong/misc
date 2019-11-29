--my config

width = 300
height = 400

luat_Test1={a=123, b=456, c=789}
luat_Test2={123, 456, 789}
setmetatable(luat_Test2, luat_Test1)

function add(a,b)
  return a+b+width
end
