-- Jackarunda 2020
AddCSLuaFile()
ENT.Base="ent_jack_gmod_ezammobox"
ENT.PrintName="EZ Arrow"
ENT.Spawnable=true
ENT.Category="JMod - EZ Ammo Types"
ENT.EZammo="Arrow"
---
if(SERVER)then
	--
elseif(CLIENT)then
	language.Add(ENT.ClassName,ENT.PrintName)
end