Debug = {}

Debug.IsOn = true

function Debug:Log(messages, ...)
	if self.IsOn then
		print(messages, ...)
	end
end