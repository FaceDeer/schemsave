

-- Create and initialize a table for a schematic.
function schematic_save.schematic_array(width, height, depth)
	-- Dimensions of data array.
	local schem = {size={x=width, y=height, z=depth}}
	schem.data = {}

	for z = 0,depth-1 do
		for y = 0,height-1 do
			for x = 0,width-1 do
				local i = z*width*height + y*width + x + 1
				schem.data[i] = {}
				schem.data[i].name = "air"
				schem.data[i].prob = 0
			end
		end
	end

	schem.yslice_prob = {}

	return schem
end

function schematic_save.serialize(pos1, pos2)
	local height = math.abs(pos2.y - pos1.y) + 1
	local width = math.abs(pos2.x - pos1.x) + 1
	local depth = math.abs(pos2.z - pos1.z) + 1

	local schem = schematic_save.schematic_array(width, height, depth)
	schem.data = nil
	local snodes = {}
	local sdata = ""

	local x1, x2 = math.min(pos1.x, pos2.x), math.max(pos1.x, pos2.x)
	local y1, y2 = math.min(pos1.y, pos2.y), math.max(pos1.y, pos2.y)
	local z1, z2 = math.min(pos1.z, pos2.z), math.max(pos1.z, pos2.z)

	local i = 0
	local c = 0
	local node_count = 0
	for z = z1, z2 do
		sdata = sdata .. "\n"
		for y = y1, y2 do
			sdata = sdata .. "\n\t\t-- z="..tostring(z-pos1.z)..", y="..tostring(y-pos1.y).."\n\t\t"
			for x = x1, x2 do
				i = i + 1
				local node = minetest.get_node({x=x, y=y, z=z})
				if node and node.name then
					if not node.param2 then
						node.param2 = 0
					end
					if not snodes[node.name .. "," .. node.param2] then
						node_count = node_count + 1
						snodes[node.name .. "," .. node.param2] = "n" .. node_count
					end
					sdata = sdata .. snodes[node.name .. "," .. node.param2] .. ", "
					c = c + 1
				else
					if not snodes["air,0"] then
						node_count = node_count + 1
						snodes["air,0"] = "n" .. node_count
					end
					sdata = sdata .. snodes["air,0"] .. ", "
				end
			end
		end
	end

	local r_snodes = {}
	for i, j in pairs(snodes) do
		r_snodes[j] = i
	end

	local snode = ""
	for i = 1, node_count do
		local name, rot = string.match(r_snodes["n" .. i], "(.+),(.+)")
		snode = snode .. "local n" .. i .. " = { name = \"" .. name .. "\""
		if tonumber(rot) > 0 then
			snode = snode .. ", param2 = " .. rot
		end
		snode = snode .. " }\n"
	end

	local out = dump(schem)
	out = "local schem = " .. string.sub(out, 1, string.len(out) - 1)
	out = out .. ",\n\tdata = {\n" .. sdata .. "\n}\n}\n"
	out = snode .. "\n" .. out
	print(out)

	return out, c
end
