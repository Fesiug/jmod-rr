-- EZ radio stations
EZ_RADIO_STATIONS={}
EZ_STATION_STATE_READY=1
EZ_STATION_STATE_DELIVERING=2
EZ_STATION_STATE_BUSY=3

-- EZ item quality grade (upgrade level) definitions
EZ_GRADE_BASIC=1
EZ_GRADE_COPPER=2
EZ_GRADE_SILVER=3
EZ_GRADE_GOLD=4
EZ_GRADE_PLATINUM=5
EZ_GRADE_BUFFS={1,1.25,1.5,1.75,2}
EZ_GRADE_NAMES={"basic","copper","silver","gold","platinum"}

-- Resource enums
JMod_EZammoBoxSize=300
JMod_EZfuelCanSize=100
JMod_EZbatterySize=100
JMod_EZpartBoxSize=100
JMod_EZsmallCrateSize=100
JMod_EZsuperRareResourceSize=10
JMod_EZexplosivesBoxSize=100
JMod_EZchemicalsSize=100
JMod_EZadvPartBoxSize=20
JMod_EZmedSupplyBoxSize=50
JMod_EZnutrientBoxSize=100
JMod_EZcrateSize=15
JMod_EZpartsCrateSize=15
JMod_EZnutrientsCrateSize=15
JMod_EZcoolantDrumSize=100

-- State enums
JMOD_EZ_STATE_BROKEN 	= -1
JMOD_EZ_STATE_OFF 		= 0
JMOD_EZ_STATE_PRIMED 	= 1
JMOD_EZ_STATE_ARMING 	= 2
JMOD_EZ_STATE_ARMED		= 3
JMOD_EZ_STATE_WARNING	= 4

-- TODO
-- yeet a wrench easter egg
-- frickin like ADD npc factions to the whitelist yo, gosh damn
-- add the crate smoke flare
-- santa sleigh aid radio
-- make sentry upgrading part of the mod point system
-- make thermals work with smoke
-- hide hand icon when in seat or vehicle
-- make nuke do flashbang
-- add combustible lemons
-- check armor headgear compat with act3, cull models that are too close to the camera
-- models/thedoctor/mani/dave_the_dummy_on_stand_phys.mdl damage reading mannequin
-- the Mk.8Z
-- armor refactor and radsuit
-- wiremod support
-- moab drogue chute
-- bounding mine unbury
-- if the json cant be read then print an error
-- fuggin like let BK and WB draw from resource crates
-- func for packages to read more info from ez entities
-- clasnames to friendlist
-- craftable keypad entity you can install on anything to lock it with a PIN
-- weapon crate
-- weps spawn with full ammo
-- - fix dropdown in turret customize menu
-- make sentries prioritize targets
-- - make laser sentries do DMG_DIRECT to zombies when they are on fire
-- - config to change the prop spam use effect
-- JIT crashes with sentry terminal
-- black hole, add blacklist st_*
-- armor crate issues
-- todo: implement:
		--	InjurySlowdownMult=0,
		--	InjuryVisionMult=0,
		--	BlastConsussionMult=0,
		--	InjurySwayMult=0,
		--	ArmShotSwayMult=0,
		--	ArmShotDisarmChance=0,
		--	LegShotSlowdownMult=0
--[[
[JMod] lua/jmod/sv_hint.lua:3: Tried to use a NULL entity!
1. __newindex - [C]:-1
2. JMod_Hint - lua/jmod/sv_hint.lua:3
3. unknown - lua/entities/ent_jack_gmod_ezweapon.lua:78
Timer Failed! [Simple][@lua/entities/ent_jack_gmod_ezweapon.lua (line 77)]
-- make each outpost, when established, have a random position outside the map
-- so that drop bearings can be predicted
-- fuckin, like, or something
-- add language translation ability for all the JMod Hints
-- and melee weps
-- healing kit -1 suplies
-- nextbot support
-- add recoil halving back
-- recoil viewpunch has been reduced what in the fuck
-- make breath control time a bit longer
-- make defusal faster with kit
-- make API sentries do more vehicle damage
-- sentries vs doors
-- BP muzzle effect
-- dirty bomb
-- add upgrade level to display
-- add merge func for resources
-- add white phosphorous weapon
-- ALT SHIFT E to split resource crates
-- ez air sensor
--]]
--[[
hook.Add( "OnDamagedByExplosion", "DisableSound", function()
    return true
end )
--]]