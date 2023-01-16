return {
  version = "1.9",
  luaversion = "5.1",
  tiledversion = "1.9.2",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 10,
  height = 10,
  tilewidth = 32,
  tileheight = 32,
  nextlayerid = 2,
  nextobjectid = 1,
  properties = {},
  tilesets = {
    {
      name = "test_tileset001",
      firstgid = 1,
      filename = "test_tileset001.tsj",
      exportfilename = "test_tileset001.lua"
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 10,
      height = 10,
      id = 1,
      name = "Ground",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 46, 47, 47, 47, 47, 47, 47, 48, 1,
        1, 56, 11, 12, 12, 12, 12, 13, 58, 1,
        1, 56, 21, 22, 22, 22, 22, 23, 58, 1,
        1, 56, 21, 22, 14, 15, 22, 23, 58, 1,
        1, 56, 21, 22, 24, 25, 22, 23, 58, 1,
        1, 56, 21, 22, 22, 22, 22, 23, 58, 1,
        1, 56, 31, 32, 32, 32, 32, 33, 58, 1,
        1, 66, 67, 67, 67, 67, 67, 67, 68, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1
      }
    }
  }
}
