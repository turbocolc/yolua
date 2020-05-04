
testcode = "aaa\nbbb\nccc"
function execute_yolol(yolol_code)
	print(generate_lua(yolol_code))
end

function generate_lua(yolol_code)
	luacode = ""
	line_label=0
	for line in yolol_code:gmatch("([^\n]*)\n?") do
		line= "::L"..tostring(line_label)..":: "..line
		line_label = line_label + 1
		line = line..'\n'
		luacode = luacode..line
	end
	return luacode
end

execute_yolol(testcode)

