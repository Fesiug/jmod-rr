-- Jackarunda 2020
AddCSLuaFile()
ENT.Base="ent_jack_gmod_ezweapon"
ENT.PrintName="EZ Magnum Revolver"
ENT.Spawnable=true
ENT.Category="JMod - EZ Weapons"
ENT.WeaponName="Magnum Revolver"
---
if(SERVER)then
	--
elseif(CLIENT)then
	language.Add(ENT.ClassName,ENT.PrintName)
end