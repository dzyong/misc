findcmd="find"
findhistory=""

function Find(cmd)
  findcmd=cmd
  scite.StripShow("!["..findhistory.."](Find File)")
end

function OnStrip(control, change)
  if control == 1 and change == 1 then
    files=io.popen(findcmd.." . "..scite.StripValue(0))
    for f in files:lines() do
      print(f)
    end
  elseif control == 0 and change == 2 then
    findhistory=scite.StripValue(0)
  end
end
