--Written by Winnower
--Derived from banish script by KingArthur and others
--
-- Requires: DanNet
--
-- Examples:
--   [ToL/Shei] /lua run MedleyBanish "datiar xi tavuelim" "Slumber of the Diabo"
--   [NoS/Mean Street] /lua run MedleyBanish "tiger" "Requiem of Time"

local mq = require("mq")
local Write = require('lib/Write')
Write.prefix = function() return '\ax['..mq.TLO.Time()..'] [\agMedleyBanish\ax] ' end
Write.loglevel = 'debug'
Write.usecolors = false

local args = {...}

local zone = mq.TLO.Zone.ShortName()
local spawnName = args[1]
local bane = mq.TLO.Spell(args[2]).RankName()

local wasAttacking = false
local targetSaveSpawnId = null

local function StopDPS()
  mq.cmd('/squelch /mqp on')
  mq.delay(10)
  wasAttacking = mq.TLO.Me.Combat()
  targetSaveSpawnId = mq.TLO.Target.ID()
  if (wasAttacking) then
    mq.cmd('/attack off')
    mq.delay(10)
  end
end

local function ResumeDPS()
  if (targettargetSaveSpawnIdSave) then
    mq.cmdf('/target id %d', targetSaveSpawnId)
    mq.delay(10)
  end
  if (wasAttacking) then
    mq.cmd('/attack on')
    mq.delay(10)
  end
  mq.cmd('/squelch /mqp off')
  mq.delay(10)
end

function Main()
  if bane == nil then
    Write.Error(string.format('Bane spell not found: %s', args[2]))
    return
  end
  if mq.TLO.Me.GemTimer(bane)() == null then
    Write.Warn(string.format('Is your bane spell memmed? bane: %s', bane))
  end

  Write.Info(string.format('Medley banish started! spawnName=%s, bane=%s', spawnName, bane))

  while mq.TLO.Zone.ShortName() == zone do
  if (mq.TLO.Medley.TTQE() == 0.0) and mq.TLO.Me.GemTimer(bane)() == 0 then
    -- Write.Debug(string.format('Bane ready: %s', bane))
    local spawnId = mq.TLO.Spawn('radius 150 npc '..spawnName..' los').ID()
    if (spawnId > 0) then
      Write.Info(string.format('attempting mez /medley queue %s -targetid|%d', bane, spawnId))
      StopDPS()
      mq.cmdf('/target id %d', spawnId)
      mq.delay(10)
      mq.cmdf('/medley queue %s -interrupt', bane, spawnId)
      mq.cmdf('/dgt group MedleyBanishing spawnId=%d', spawnId)
      mq.delay(10)
      ResumeDPS()
    end
  end
  mq.delay(10)
  end
end

Main()
Write.Info('Medley banish exiting')