# schematic_save

This mod lets you mark two positions and save everything inside as a lua schematic file. Node names and rotation data are included, and air is automatically set to prob = 0, so that it won't overwrite anything else. The format is reasonably compact:

```
local n1 = { name = "default:sand" }
local n2 = { name = "default:river_water_source" }
local n3 = { name = "default:river_water_flowing", param2 = 7 }
...

return {
	yslice_prob = {

	},
	size = {
		y = 3,
		x = 7,
		z = 7
	}
	,
	data = {
		-- z=-6, y=-2
		n1, n1, n1, n1, n1, n1, n1, 
		-- z=-6, y=-1
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=-6, y=0
		n2, n2, n2, n2, n2, n2, n2, 
		...
	}
}
```

The code is almost entirely lifted from WorldEdit, and marking positions works the same way. Go to a spot and type "//pos1", then another and type "//pos2". Then type in "//save <file>". The schematic will be saved in your world directory, with a ".txt" suffix. You can then copy it to an appropriate file and add register_decoration code.

![example](https://github.com/duane-r/schematic_save/raw/master/textures/screenshot01.jpg)
