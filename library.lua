local modHunter = { }

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
   if not MyTargetDelay or UnitGUID("target") ~= MyTargetGUID and UnitGUID("target") ~= nil then
      MyTargetGUID = UnitGUID("target")
      MyTargetDelay = GetTime()
   end
   if PQIprefix and MyTargetDelay and _G[PQIprefix.."HuntersMark_enable"] then
      if _G[PQIprefix.."HuntersMark_value"] < GetTime() - MyTargetDelay then
         MyTargetDelay = nil
         return true
      end
   end
end

ProbablyEngine.library.register("modHunter", modHunter)
