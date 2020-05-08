
local yololtestcode = "if 1==1 then print(\"if works\") end\n"..
			"goto 3\n"..
			"print(\"goto works\")\n"..
			":OpenDoor = 1\n"..
			"print(:OpenDoor)"


function execute_lua(lua_code)
	local y,e = load(lua_code)
	if(e~=nil) then
		print(e)
	else
		y()
	end

end



function generate_lua(yolol_code)
	local luacode,line_label = add_labels(yolol_code)
	luacode,line_label = complete_labels(luacode,line_label)
	luacode = add_goto(luacode,line_label)
	luacode = luacode.."\tgoto L1\n"
	return luacode
end

function generate_chip(name,yolol_code)
	local luacode = "function "..name.."()\n"
	luacode = luacode..generate_lua(yolol_code)
	luacode = luacode.."end\n"..
					   "coroutine_"..name.." = coroutine.create("..name..")\n"..
					   "coroutine.resume(coroutine_"..name..")"
	return luacode
end

function add_label(line,index)
	return "::L"..tostring(index)..":: "..line
end

function add_labels(yolol_code)
	local lua_code = ""
	local line_label=1
	local lines = yolol_code:gmatch("([^\n]*)\n?")
	for line in lines do
		line = string.gsub(line,"//","--")
		line = string.gsub(line,":","_ENV.")
		line = add_label(line,line_label)
		line_label = line_label + 1
		line = string.gsub(line,"\t"," ")
		line = '\t'..line..'\n'
		lua_code = lua_code..line
	end
	return lua_code,line_label
end

function complete_labels(lc,stoped_index)
	local lua_code = lc

	for i=stoped_index,20 do
        local line=""
		line = add_label(line,i)
		line = '\t'..line.."\n"
		lua_code = lua_code..line
		stoped_index = i
	end
	return lua_code,stoped_index
end

function add_goto(lc,label_amount)
	local lua_code = lc
	for i=0,label_amount do
		lua_code = string.gsub(lua_code,"goto "..i,"goto L"..i)
	end
	return lua_code
end


chip = generate_chip("test",yololtestcode)
execute_lua(chip)

function add_ticks(lc)
	local lua_code = lc

	local timer = "local clock = os.clock"..
				"local ticks = 0"..
				"function tick(num)\n"..
				"	local t0 = clock()"..
				"	while clock() - t0 <= 200 do end"..
				"end\n\n"
	return lc

end



