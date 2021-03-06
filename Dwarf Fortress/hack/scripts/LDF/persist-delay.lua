function commandDelay(ticks,script)
 local persistTable = require 'persist-table'
 local currentTick = 1200*28*3*4*df.global.cur_year + df.global.cur_year_tick
 local runTick = currentTick + ticks
 local persistDelay = persistTable.GlobalTable.roses.CommandDelay
 local number = #persistDelay._children
 persistDelay[tostring(number+1)] = {}
 persistDelay[tostring(number+1)].Tick = tostring(runTick)
 persistDelay[tostring(number+1)].Command = script
 id = dfhack.timeout(ticks,'ticks',
                     function () 
                       dfhack.run_command(script) 
                     end
                    )
 return id
end

function environmentDelay(ticks,environment,functions,arguments)
 id = dfhack.timeout(ticks,'ticks',
                     function () 
                      dfhack.script_environment(environment)[functions](table.unpack(arguments))
                     end
                    )
 local persistTable = require 'persist-table'
 local currentTick = 1200*28*3*4*df.global.cur_year + df.global.cur_year_tick
 local runTick = currentTick + ticks
 local persistDelay = persistTable.GlobalTable.roses.EnvironmentDelay
 local number = #persistDelay._children
 persistDelay[tostring(number+1)] = {}
 persistDelay[tostring(number+1)].ID = tostring(id)
 persistDelay[tostring(number+1)].Tick = tostring(runTick)
 persistDelay[tostring(number+1)].Environment = environment
 persistDelay[tostring(number+1)].Function = functions
 persistDelay[tostring(number+1)].Arguments = {}
 for i,x in ipairs(arguments) do
  persistDelay[tostring(number+1)].Arguments[tostring(i)] = tostring(x)
 end
 return id
end

function environmentDelete(id)
 local persistTable = require 'persist-table'
 local persistDelay = persistTable.GlobalTable.roses.EnvironmentDelay
 for _,x in pairs(persistDelay._children) do
  if tonumber(persistDelay[x].ID) == tonumber(id) then
   persistDelay[x] = nil
   break
  end
 end
end
