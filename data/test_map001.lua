return {
  version = "1.9",
  luaversion = "5.1",
  tiledversion = "1.9.2",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 11,
  height = 11,
  tilewidth = 32,
  tileheight = 32,
  nextlayerid = 9,
  nextobjectid = 10,
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
      type = "group",
      id = 8,
      name = "BakeTwo",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      layers = {
        {
          type = "tilelayer",
          x = 0,
          y = 0,
          width = 11,
          height = 11,
          id = 1,
          name = "Ground",
          class = "",
          visible = true,
          opacity = 1,
          offsetx = 0,
          offsety = 0,
          parallaxx = 1,
          parallaxy = 1,
          properties = {
            ["Bake"] = true
          },
          encoding = "lua",
          data = {
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
          }
        },
        {
          type = "tilelayer",
          x = 0,
          y = 0,
          width = 11,
          height = 11,
          id = 2,
          name = "Mud",
          class = "",
          visible = true,
          opacity = 1,
          offsetx = 0,
          offsety = 0,
          parallaxx = 1,
          parallaxy = 1,
          properties = {
            ["Bake"] = true
          },
          encoding = "lua",
          data = {
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 11, 12, 12, 12, 12, 12, 12, 13, 0, 0,
            0, 21, 22, 22, 22, 22, 22, 22, 23, 0, 0,
            0, 21, 22, 22, 22, 22, 22, 22, 23, 0, 0,
            0, 21, 22, 22, 0, 0, 22, 22, 23, 0, 0,
            0, 21, 22, 22, 0, 0, 22, 22, 23, 0, 0,
            0, 21, 22, 22, 22, 22, 22, 22, 23, 0, 0,
            0, 21, 22, 22, 22, 22, 22, 22, 23, 0, 0,
            0, 31, 32, 32, 32, 32, 32, 32, 33, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
          }
        }
      }
    },
    {
      type = "group",
      id = 7,
      name = "BakeOne",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      layers = {
        {
          type = "tilelayer",
          x = 0,
          y = 0,
          width = 11,
          height = 11,
          id = 3,
          name = "Wall",
          class = "",
          visible = true,
          opacity = 1,
          offsetx = 0,
          offsety = 0,
          parallaxx = 1,
          parallaxy = 1,
          properties = {
            ["Bake"] = true
          },
          encoding = "lua",
          data = {
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 46, 47, 47, 48, 0, 0, 0, 0,
            0, 0, 0, 56, 0, 0, 58, 0, 0, 0, 0,
            0, 0, 0, 56, 0, 0, 58, 0, 0, 0, 0,
            0, 0, 0, 66, 67, 67, 68, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
          }
        },
        {
          type = "tilelayer",
          x = 0,
          y = 0,
          width = 11,
          height = 11,
          id = 4,
          name = "Rocks",
          class = "",
          visible = true,
          opacity = 1,
          offsetx = 0,
          offsety = 0,
          parallaxx = 1,
          parallaxy = 1,
          properties = {
            ["Bake"] = true
          },
          encoding = "lua",
          data = {
            41, 42, 42, 42, 42, 42, 42, 42, 42, 43, 0,
            51, 0, 0, 0, 0, 0, 0, 0, 0, 53, 0,
            51, 0, 0, 0, 0, 0, 0, 0, 0, 53, 0,
            51, 0, 0, 0, 0, 0, 0, 0, 0, 53, 0,
            51, 0, 0, 0, 0, 0, 0, 0, 0, 53, 0,
            51, 0, 0, 0, 0, 0, 0, 0, 0, 53, 0,
            51, 0, 0, 0, 0, 0, 0, 0, 0, 53, 0,
            51, 0, 0, 0, 0, 0, 0, 0, 0, 53, 0,
            51, 0, 0, 0, 0, 0, 0, 0, 0, 53, 0,
            61, 62, 62, 62, 62, 62, 62, 62, 62, 63, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 5,
      name = "World",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 4,
          name = "",
          class = "",
          shape = "rectangle",
          x = 0,
          y = 352,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 52,
          visible = true,
          properties = {}
        },
        {
          id = 5,
          name = "",
          class = "",
          shape = "rectangle",
          x = 320,
          y = 352,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 52,
          visible = true,
          properties = {}
        },
        {
          id = 6,
          name = "",
          class = "",
          shape = "rectangle",
          x = 320,
          y = 32,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 52,
          visible = true,
          properties = {}
        },
        {
          id = 7,
          name = "",
          class = "",
          shape = "rectangle",
          x = 0,
          y = 32,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 52,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
