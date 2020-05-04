
yololtestcode = "if 1==1 then print(\"if works\") end\n"..
			"goto 3\n"..
			"print(\"goto works\")"

function execute_yolol(yolol_code)
	print(generate_lua(yolol_code))
	local y,e = load(generate_lua(yolol_code))
	if(e~=nil) then
		print(e)
	else
		y()
	end

end

function generate_lua(yolol_code)
	luacode,line_label = add_labels(yolol_code)
	luacode,line_label = complete_labels(luacode,line_label)
	luacode = add_goto(luacode,line_label)
	--luacode = luacode.."goto L1\n"
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
		line = add_label(line,line_label)
		line_label = line_label + 1
		line = string.gsub(line,"\t"," ")
		line = line..'\n'
		lua_code = lua_code..line
	end
	return lua_code,line_label
end

function complete_labels(lc,stoped_index)
	local lua_code = lc

	for i=stoped_index,20 do
        local line=""
		line = add_label(line,i)
		line = line.."\n"
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



execute_yolol(yololtestcode)

