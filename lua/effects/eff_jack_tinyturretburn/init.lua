function EFFECT:Init(data)

	local SelfPos=data:GetOrigin()
	local Scayul=data:GetScale()
	
	if(self:WaterLevel()==3)then
		local Splach=EffectData()
		Splach:SetOrigin(SelfPos)
		Splach:SetNormal(Vector(0,0,1))
		Splach:SetScale(5)
		util.Effect("WaterSplash",Splach)
		return
	end
	
	local Emitter=ParticleEmitter(SelfPos)

	for i=0,1 do
		local Particle=Emitter:Add("particles/flamelet"..tostring(math.random(1,5)),SelfPos+VectorRand()*math.Rand(0,1))
		if(Particle)then
			Particle:SetVelocity(VectorRand()*math.Rand(0,10))
			Particle:SetLifeTime(0)
			Particle:SetDieTime(math.Rand(.1,.4))	
			local shadevariation=math.Rand(-10,10)
			Particle:SetColor(math.Clamp(255+shadevariation+math.Rand(-5,5),0,255),math.Clamp(255+shadevariation+math.Rand(-5,5),0,255),math.Clamp(255+shadevariation+math.Rand(-5,5),0,255))			
			Particle:SetStartAlpha(math.Rand(200,255))
			Particle:SetEndAlpha(0)
			Particle:SetStartSize(math.Rand(3,6)*Scayul)
			Particle:SetEndSize(0)
			Particle:SetRoll(math.Rand(-360,360))
			Particle:SetRollDelta(math.Rand(-5,5))
			Particle:SetAirResistance(10)
			Particle:SetGravity(Vector(0,0,1000))
			Particle:SetCollide(false)
			Particle:SetLighting(false)
		end
	end

	if(true)then
		local Particle=Emitter:Add("sprites/mat_jack_smoke"..tostring(math.random(1,3)),SelfPos+VectorRand()*math.Rand(0,3))
		if(Particle)then
			Particle:SetVelocity(Vector(0,0,0))
			Particle:SetLifeTime(0)
			Particle:SetDieTime(math.Rand(.5,2))
			local shadevariation=math.Rand(-10,10)
			Particle:SetColor(math.Clamp(255+shadevariation+math.Rand(-5,5),0,255),math.Clamp(255+shadevariation+math.Rand(-5,5),0,255),math.Clamp(255+shadevariation+math.Rand(-5,5),0,255))			
			Particle:SetStartAlpha(math.Rand(50,100))
			Particle:SetEndAlpha(0)
			Particle:SetStartSize(math.Rand(0,1)*Scayul)
			Particle:SetEndSize(math.Rand(10,30)*Scayul)
			Particle:SetRoll(math.Rand(-360,360))
			Particle:SetRollDelta(math.Rand(-5,5))
			Particle:SetAirResistance(500)
			Particle:SetGravity(Vector(0,0,400)+VectorRand()*math.Rand(0,300))
			Particle:SetCollide(false)
			Particle:SetLighting(true)
		end
	end
	
	Emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end