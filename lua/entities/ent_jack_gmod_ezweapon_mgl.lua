-- Jackarunda 2020
AddCSLuaFile()
ENT.Base="ent_jack_gmod_ezweapon"
ENT.PrintName="EZ Multiple Grenade Launcher"
ENT.Spawnable=true
ENT.Category="JMod - EZ Weapons"
ENT.WeaponName="Multiple Grenade Launcher"
---
if(SERVER)then
	--
elseif(CLIENT)then
	language.Add(ENT.ClassName,ENT.PrintName)
end