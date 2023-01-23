--- Generaters string from table
---@param o any
function Debug.Dump(o)
	if type(o) == 'table' then
		local s = '{ '
		for k, v in pairs(o) do
			if type(k) ~= 'number' then k = '"' .. k .. '"' end
			s = s .. '[' .. k .. '] = ' .. Debug.Dump(v) .. ','
		end
		return s .. '} '
	else
		return tostring(o)
	end
end
