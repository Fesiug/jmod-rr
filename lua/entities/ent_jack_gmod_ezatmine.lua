-- Jackarunda 2019
AddCSLuaFile()
ENT.Type="anim"
ENT.Author="Jackarunda"
ENT.Category="JMod - EZ Explosives"
ENT.Information="glhfggwpezpznore"
ENT.PrintName="EZ Vehicle Mine"
ENT.NoSitAllowed=true
ENT.Spawnable=true
ENT.AdminSpawnable=true
---
ENT.JModEZstorable=true
ENT.JModPreferredCarryAngles=Angle(0,0,0)
ENT.BlacklistedNPCs={"bullseye_strider_focus","npc_turret_floor","npc_turret_ceiling","npc_turret_ground"}
ENT.WhitelistedNPCs={"npc_rollermine"}
---
local STATE_BROKEN,STATE_OFF,STATE_ARMING,STATE_ARMED,STATE_WARNING=-1,0,1,2,3
function ENT:SetupDataTables()
	self:NetworkVar("Int",0,"State")
end
---
if(SERVER)then
	function ENT:SpawnFunction(ply,tr)
		local SpawnPos=tr.HitPos+tr.HitNormal*40
		local ent=ents.Create(self.ClassName)
		ent:SetAngles(Angle(0,0,0))
		ent:SetPos(SpawnPos)
		JMod_Owner(ent,ply)
		ent:Spawn()
		ent:Activate()
		--local effectdata=EffectData()
		--effectdata:SetEntity(ent)
		--util.Effect("propspawn",effectdata)
		return ent
	end
	function ENT:Initialize()
		self.Entity:SetModel("models/mechanics/wheels/wheel_smooth_24.mdl")
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)	
		self.Entity:SetSolid(SOLID_VPHYSICS)
		self.Entity:DrawShadow(true)
		self.Entity:SetUseType(SIMPLE_USE)
		self:GetPhysicsObject():SetMass(10)
		---
		timer.Simple(.01,function()
			self:GetPhysicsObject():SetMass(40)
			self:GetPhysicsObject():Wake()
		end)
		---
		self:SetState(STATE_OFF)
		self.NextDet=0
	end
	function ENT:PhysicsCollide(data,physobj)
		if(data.DeltaTime>0.2)then
			if(data.Speed>20)then
				if((self:GetState()==STATE_ARMED)and(math.random(1,5)==1))then
					self:Detonate()
				else
					self.Entity:EmitSound("Weapon.ImpactHard")
				end
			end
		end
	end
	function ENT:OnTakeDamage(dmginfo)
		self.Entity:TakePhysicsDamage(dmginfo)
		if(dmginfo:GetDamage()>=130)then
			local Pos,State=self:GetPos(),self:GetState()
			if((State==STATE_ARMED)and(math.random(1,2)==2))then
				self:Detonate()
			elseif((math.random(1,10)==3)and not(State==STATE_BROKEN))then
				sound.Play("Metal_Box.Break",Pos)
				self:SetState(STATE_BROKEN)
				SafeRemoveEntityDelayed(self,10)
			end
		end
	end
	function ENT:Use(activator)
		local State=self:GetState()
		if(State<0)then return end
		
		local Alt=activator:KeyDown(JMOD_CONFIG.AltFunctionKey)
		if(State==STATE_OFF)then
			if(Alt)then
				JMod_Owner(self,activator)
				net.Start("JMod_MineColor")
				net.WriteEntity(self)
				net.Send(activator)
			else
				activator:PickupObject(self)
				JMod_Hint(activator, "arm", self)
			end
		else
			self:EmitSound("snd_jack_minearm.wav",60,70)
			self:SetState(STATE_OFF)
			JMod_Owner(self,activator)
			self:DrawShadow(true)
		end
	end
	function ENT:Detonate()
		if(self.Exploded)then return end
		self.Exploded=true
		sound.Play("snds_jack_gmod/mine_warn.wav",self:GetPos()+Vector(0,0,30),60,100)
		timer.Simple(math.Rand(.1,.2)*JMOD_CONFIG.MineDelay,function()
			local SelfPos=self:LocalToWorld(self:OBBCenter())
			local Eff="100lb_ground"
			if not(util.QuickTrace(SelfPos,Vector(0,0,-300),{self}).HitWorld)then Eff="100lb_air" end
			util.ScreenShake(SelfPos,99999,99999,1,1000)
			self:EmitSound("snd_jack_fragsplodeclose.wav",90,100)
			sound.Play("ambient/explosions/explode_"..math.random(1,9)..".wav",SelfPos,100,130)
			JMod_Sploom(self.Owner,SelfPos,10)
			local Att=self.Owner or game.GetWorld()
			util.BlastDamage(self,Att,SelfPos+Vector(0,0,30),100,5500)
			util.BlastDamage(self,Att,SelfPos+Vector(0,0,10),300,100)
			timer.Simple(.1,function()
				local Tr=util.QuickTrace(SelfPos+Vector(0,0,10),Vector(0,0,-100))
				if(Tr.Hit)then util.Decal("Scorch",Tr.HitPos+Tr.HitNormal,Tr.HitPos-Tr.HitNormal) end
			end)
			JMod_WreckBuildings(self,SelfPos,3)
			JMod_BlastDoors(self,SelfPos,3)
			ParticleEffect(Eff,SelfPos,Angle(0,0,0))
			self:Remove()
		end)
	end
	function ENT:Arm(armer)
		local State=self:GetState()
		if(State~=STATE_OFF)then return end
		JMod_Hint(armer, "friends", self)
		JMod_Owner(self,armer)
		self:SetState(STATE_ARMING)
		self:EmitSound("snd_jack_minearm.wav",60,90)
		timer.Simple(3,function()
			if(IsValid(self))then
				if(self:GetState()==STATE_ARMING)then
					self:SetState(STATE_ARMED)
					self:DrawShadow(false)
					local Tr=util.QuickTrace(self:GetPos()+Vector(0,0,20),Vector(0,0,-40),self)
					if(Tr.Hit)then
						constraint.Weld(Tr.Entity,self,0,0,40000,false,false)
					end
				end
			end
		end)
	end
	function ENT:CanSee(ent)
		if not(IsValid(ent))then return false end
		local TargPos,SelfPos=ent:LocalToWorld(ent:OBBCenter()),self:LocalToWorld(self:OBBCenter())+vector_up
		local Tr=util.TraceLine({
			start=SelfPos,
			endpos=TargPos,
			filter={self,ent},
			mask=MASK_SHOT+MASK_WATER
		})
		return not Tr.Hit
	end
	function ENT:Think()
		local State,Time=self:GetState(),CurTime()
		if(State==STATE_ARMED)then
			if(self.NextDet<CurTime())then
				self:GetPhysicsObject():SetBuoyancyRatio(.4)
				if(JMod_EnemiesNearPoint(self,self:GetPos(),100,true))then
					self:Detonate()
					return
				end
				self:NextThink(CurTime()+.5)
				return true
			end
		end
	end
	function ENT:OnRemove()
		--aw fuck you
	end
elseif(CLIENT)then
	function ENT:Initialize()
		self.Mdl=ClientsideModel("models/thedoctor/mines/clustermine_1.mdl")
		self.Mdl:SetMaterial("models/jacky_camouflage/digi2")
		self.Mdl:SetModelScale(1.5,0)
		self.Mdl:SetPos(self:GetPos())
		self.Mdl:SetParent(self)
		self.Mdl:SetNoDraw(true)
	end
	local GlowSprite=Material("sprites/mat_jack_basicglow")
	function ENT:Draw()
		local Pos,Ang=self:GetPos(),self:GetAngles()
		--self:DrawModel()
		self.Mdl:SetRenderOrigin(Pos-Ang:Up()*4.5)
		self.Mdl:SetRenderAngles(Ang)
		self.Mdl:DrawModel()
		local State,Vary=self:GetState(),math.sin(CurTime()*50)/2+.5
		if(State==STATE_ARMING)then
			render.SetMaterial(GlowSprite)
			render.DrawSprite(self:GetPos()+Vector(0,0,4),20,20,Color(255,0,0))
			render.DrawSprite(self:GetPos()+Vector(0,0,4),10,10,Color(255,255,255))
		elseif(State==STATE_WARNING)then
			render.SetMaterial(GlowSprite)
			render.DrawSprite(self:GetPos()+Vector(0,0,4),30*Vary,30*Vary,Color(255,0,0))
			render.DrawSprite(self:GetPos()+Vector(0,0,4),15*Vary,15*Vary,Color(255,255,255))
		end
	end
	language.Add("ent_jack_gmod_ezatmine","EZ Vehicle Mine")
end