----------------------------------------------------------------------
-- Center the current selection on the sprite
-- Copyright 2020 Geoff Beier <geoff@tuxpup.com>
-- Licensed under the MIT license. See LICENSE.txt for details.
----------------------------------------------------------------------

-- bail if there's no active sprite
local spr = app.activeSprite
if not spr then return end

-- Select Content if nothing's selected
local sel = spr.selection
if sel.isEmpty then
	app.command.MaskContent()
	local spr = app.activeSprite
end
--print("sel:"..sel.bounds.x..","..sel.bounds.y)

-- The MoveMask command requires us to specify X <units> up, Y <units> down
-- rather than just specifying new coordinates.
new_x = spr.bounds.width/2 - sel.bounds.width/2
x_dir = "right"
x_distance = 0
if new_x < sel.bounds.x then
	x_dir = "left"
	x_distance = sel.bounds.x - new_x
elseif new_x > sel.bounds.x then
	x_dir = "right"
	x_distance = new_x - sel.bounds.x
end

new_y = spr.bounds.height/2 - sel.bounds.height/2
y_dir = "down"
y_distance = 0
if new_y < sel.bounds.y then
	y_dir = "up"
	y_distance = sel.bounds.y - new_y
elseif new_y > sel.bounds.y then
	y_dir = "down"
	y_distance = new_y - sel.bounds.y
end

--print('need to move ' .. x_dir .. ' ' .. tostring(x_distance) .. ' and ' .. y_dir .. ' ' .. tostring(y_distance))

if x_distance ~= 0 then
	app.command.MoveMask{
		target='content',
		direction=x_dir,
		units="pixel",
		quantity=x_distance
	}
end

if y_distance ~= 0 then
	app.command.MoveMask{
		target='content',
		direction=y_dir,
		units="pixel",
		quantity=y_distance
	}
end