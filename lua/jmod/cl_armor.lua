local function CopyArmorTableToPlayer(ply)
	-- make a copy of the global armor spec table, personalize it, and store it on the player
	ply.JMod_ArmorTableCopy=table.FullCopy(JMod_ArmorTable)
	local plyMdl=ply:GetModel()
	if JMOD_LUA_CONFIG and JMOD_LUA_CONFIG.ArmorOffsets and JMOD_LUA_CONFIG.ArmorOffsets[plyMdl] then
		table.Merge(ply.JMod_ArmorTableCopy,JMOD_LUA_CONFIG.ArmorOffsets[plyMdl])
	end
end
function JMod_ArmorPlayerModelDraw(ply)
	if(ply.EZarmor)then
		if not(ply.EZarmorModels)then ply.EZarmorModels={} end
		local Time=CurTime()
		if(not(ply.JMod_ArmorTableCopy)or(ply.NextEZarmorTableCopy<Time))then
			CopyArmorTableToPlayer(ply)
			ply.NextEZarmorTableCopy=Time+30
		end
		local plyboneedit = {}
		for id,armorData in pairs(ply.EZarmor.items)do
			local ArmorInfo=ply.JMod_ArmorTableCopy[armorData.name]
			if((armorData.tgl)and(ArmorInfo.tgl))then
				ArmorInfo=table.Merge(table.FullCopy(ArmorInfo),ArmorInfo.tgl)
				for k,v in pairs(ArmorInfo.tgl)do -- for some fucking reason table.Merge doesn't copy empty tables
					if(type(v)=="table")then
						if(#table.GetKeys(v)==0)then
							ArmorInfo[k]={}
						end
					end
				end
			end
			if(ply.EZarmorModels[id])then
				local Mdl=ply.EZarmorModels[id]
				local MdlName=Mdl:GetModel()
				if(MdlName==ArmorInfo.mdl and ArmorInfo.bon)then
					-- render it
					local Index=ply:LookupBone(ArmorInfo.bon)
					if(Index)then
						local Pos,Ang=ply:GetBonePosition(Index)
						if ((Pos)and(Ang)) then
							local Right,Forward,Up=Ang:Right(),Ang:Forward(),Ang:Up()
							Pos=Pos+Right*ArmorInfo.pos.x+Forward*ArmorInfo.pos.y+Up*ArmorInfo.pos.z
							Ang:RotateAroundAxis(Right,ArmorInfo.ang.p)
							Ang:RotateAroundAxis(Up,ArmorInfo.ang.y)
							Ang:RotateAroundAxis(Forward,ArmorInfo.ang.r)
							Mdl:SetRenderOrigin(Pos)
							Mdl:SetRenderAngles(Ang)
							local Mat=Matrix()
							Mat:Scale(ArmorInfo.siz)
							Mdl:EnableMatrix("RenderMultiply",Mat)
							local OldR,OldG,OldB=render.GetColorModulation()
							local Colr=armorData.col
							render.SetColorModulation(Colr.r/255,Colr.g/255,Colr.b/255)
							if(ArmorInfo.bdg)then
								for k,v in pairs(ArmorInfo.bdg)do
									Mdl:SetBodygroup(k,v)
								end
							end
							if ArmorInfo.skin then
								Mdl:SetSkin(ArmorInfo.skin)
							end
							Mdl:DrawModel()
							render.SetColorModulation(OldR,OldG,OldB)
						end
						if ArmorInfo.bonsiz then
							ply.EZarmorboneedited = true
							plyboneedit[Index] = ArmorInfo.bonsiz
						end
					end
				else
					-- remove it
					ply.EZarmorModels[id]:Remove()
					ply.EZarmorModels[id]=nil
				end
			else
				-- create it
				local Mdl=ClientsideModel(ArmorInfo.mdl)
				Mdl:SetModel(ArmorInfo.mdl) -- what the FUCK garry
				Mdl:SetPos(ply:GetPos())
				Mdl:SetMaterial(ArmorInfo.mat or "")
				Mdl:SetParent(ply)
				Mdl:SetNoDraw(true)
				ply.EZarmorModels[id]=Mdl
			end
		end
		if ply.EZarmorboneedited then
			local edited = false
			for k = 1, ply:GetBoneCount() do
				if ply:GetManipulateBoneScale(k) ~= (plyboneedit[k] or Vector(1, 1, 1)) then
					ply:ManipulateBoneScale(k, plyboneedit[k] or Vector(1, 1, 1))
				end
				if ply:GetManipulateBoneScale(k) ~= Vector(1, 1, 1) then
					edited = true
				end
			end
			if not edited then print("not edited") ply.EZarmorboneedited = false end
		end
	end
end
hook.Add("PostPlayerDraw","JMOD_ArmorPlayerDraw",function(ply)
	if not(IsValid(ply))then return end
	JMod_ArmorPlayerModelDraw(ply)
end)
net.Receive("JMod_EZarmorSync",function()
	local ply=net.ReadEntity()
	ply.EZarmor=net.ReadTable()
end)