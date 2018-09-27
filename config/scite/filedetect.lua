if(arg[2]) then
  cmdprefix=string.gsub(arg[2],"/","\\")
else
  cmdprefix=""
end
local e = io.popen(cmdprefix.."file --mime-encoding "..arg[1].."|"..cmdprefix.."awk '{print $2}'")
if(e:read() == "utf-8") then
  print("code.page=65001")
else
  print("code.page=936")
end