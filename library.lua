local modHunter = { }
modHunter.HMDelay = nil
modHunter.HMTargetGUID = nil

modHunter.eventHandler = function(self, ...)
  local subEvent                = select(1, ...)
  local source                = select(4, ...)
  local destGUID                = select(7, ...)
  local spellID                = select(11, ...)
  local failedType = select(14, ...)
  
  if UnitName("player") == source then
    if subEvent == "SPELL_CAST_SUCCESS" then
      if spellID == 5512 then -- Healthstone
        modHunter.items[5512] = { lastCast = GetTime() }
      end
      if spellID == 124199 then -- Landshark (itemId 77589)
        modHunter.items[77589] = { lastCast = GetTime(), exp = 0 }
      end
    end
  end
end

function modHunter.isHeroism()
   -- Check for hero/bloodlust/etc
   if (UnitBuff("player", 2825) or
         UnitBuff("player", 32182) or
         UnitBuff("player", 80353) or
         UnitBuff("player", 90355)) then
      return true
   end
   return false
end

function modHunter.checkShark(target)
  if GetItemCount(77589, false, false) > 0 then
    if not modHunter.items[77589] then return true end
    if modHunter.items[77589].exp ~= 0 and
      modHunter.items[77589].exp < GetTime() then return true end
  end
end

-- G91 Landshark
function modHunter.Landshark()
  if GetItemCount(77589, false, false) > 0 then
    if not modHunter.items[77589] then return true end
    if modHunter.items[77589].exp ~= 0 and
      modHunter.items[77589].exp < GetTime() then return true end
  end
end

function modHunter.HuntersMark()
   if not modHunter.HMDelay or UnitGUID("target") ~= modHunter.HMTargetGUID and UnitGUID("target") ~= nil then
      modHunter.HMTargetGUID = UnitGUID("target")
      modHunter.HMDelay = GetTime()
   end
   if modHunter.HMDelay then
      if 2 < GetTime() - modHunter.HMDelay then
         modHunter.HMDelay = nil
         return true
      end
   end
end

ProbablyEngine.library.register("modHunter", modHunter)
