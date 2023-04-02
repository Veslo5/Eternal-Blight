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
  nextlayerid = 16,
  nextobjectid = 11,
  properties = {},
  tilesets = {
    {
      name = "tutorial_tileset001",
      firstgid = 1,
      filename = "../../!raw/tiled/tutorial_tileset001.tsj",
      exportfilename = "tutorial_tileset001.lua"
    },
    {
      name = "marks",
      firstgid = 101,
      filename = "../../!raw/tiled/marks.tsj",
      exportfilename = "marks.lua"
    }
  },
  layers = {
    {
      type = "group",
      id = 2,
      name = "Ground",
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
            1, 1, 1, 1, 1, 1, 1, 1, 1, 4,
            2, 1, 1, 1, 1, 1, 1, 1, 1, 1,
            1, 1, 1, 1, 1, 4, 1, 2, 1, 1,
            1, 1, 1, 1, 1, 1, 5, 1, 3, 1,
            1, 1, 1, 1, 1, 1, 1, 1, 2, 1,
            1, 1, 1, 2, 1, 3, 1, 1, 1, 1,
            1, 1, 1, 1, 4, 1, 1, 1, 1, 1,
            5, 1, 1, 1, 1, 1, 1, 1, 1, 1,
            3, 1, 1, 1, 1, 1, 1, 1, 1, 1,
            2, 1, 1, 1, 3, 4, 1, 1, 1, 1
          }
        },
        {
          type = "tilelayer",
          x = 0,
          y = 0,
          width = 10,
          height = 10,
          id = 3,
          name = "Paths",
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
            0, 41, 41, 0, 0, 0, 21, 22, 23, 0,
            0, 42, 43, 0, 0, 0, 21, 22, 23, 0,
            0, 41, 42, 0, 11, 12, 22, 22, 23, 0,
            0, 51, 52, 0, 21, 22, 22, 22, 23, 0,
            0, 42, 42, 0, 21, 22, 22, 22, 23, 0,
            0, 41, 41, 0, 21, 22, 22, 22, 23, 0,
            0, 43, 41, 0, 31, 32, 32, 32, 33, 0,
            0, 41, 41, 42, 51, 41, 41, 41, 42, 51,
            0, 41, 52, 41, 41, 42, 43, 42, 41, 43,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0
          }
        },
        {
          type = "tilelayer",
          x = 0,
          y = 0,
          width = 10,
          height = 10,
          id = 4,
          name = "Plants",
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
            40, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 4, 0, 0, 0, 39,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 39, 0, 0, 0, 0, 0, 5,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 40, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 39, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 39, 0, 0, 0, 0, 0, 0, 40
          }
        }
      }
    },
    {
      type = "group",
      id = 15,
      name = "Player",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      layers = {}
    },
    {
      type = "group",
      id = 11,
      name = "Vegetation",
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
          width = 10,
          height = 10,
          id = 5,
          name = "Tree",
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
            0, 0, 28, 29, 30, 18, 19, 20, 0, 0,
            0, 0, 0, 0, 0, 28, 29, 30, 0, 0,
            0, 0, 0, 0, 0, 8, 9, 10, 0, 0,
            9, 10, 0, 0, 0, 18, 19, 20, 0, 0,
            19, 20, 0, 0, 0, 28, 29, 30, 0, 0,
            29, 30, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 8, 9, 10, 0,
            0, 0, 0, 0, 0, 0, 18, 19, 20, 0,
            0, 0, 0, 0, 8, 9, 10, 29, 30, 0,
            8, 9, 10, 0, 18, 19, 20, 0, 0, 0
          }
        },
        {
          type = "tilelayer",
          x = 0,
          y = 0,
          width = 10,
          height = 10,
          id = 6,
          name = "Tree2",
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
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 8, 9, 10,
            0, 0, 0, 0, 0, 0, 0, 18, 19, 20,
            0, 0, 0, 0, 0, 0, 0, 28, 29, 30,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0
          }
        }
      }
    },
    {
      type = "group",
      id = 8,
      name = "Data",
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
          width = 10,
          height = 10,
          id = 9,
          name = "Walls",
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
            101, 0, 0, 101, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 101, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 101, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 101, 0, 0, 0,
            101, 0, 0, 0, 0, 101, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 101, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 101, 0, 0,
            0, 0, 101, 0, 0, 0, 0, 0, 0, 101
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 7,
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
          id = 1,
          name = "",
          class = "",
          shape = "rectangle",
          x = 96,
          y = 224,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 103,
          visible = true,
          properties = {
            ["id"] = 0,
            ["type"] = "spawn"
          }
        },
        {
          id = 7,
          name = "",
          class = "",
          shape = "rectangle",
          x = 288,
          y = 224,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 102,
          visible = true,
          properties = {
            ["map"] = "tutorial_map002.lua",
            ["type"] = "port"
          }
        },
        {
          id = 8,
          name = "",
          class = "",
          shape = "rectangle",
          x = 288,
          y = 256,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 102,
          visible = true,
          properties = {
            ["map"] = "tutorial_map002.lua",
            ["type"] = "port"
          }
        },
        {
          id = 10,
          name = "",
          class = "",
          shape = "rectangle",
          x = 96,
          y = 160,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 104,
          visible = true,
          properties = {
            ["items"] = "m0001",
            ["type"] = "stash"
          }
        }
      }
    }
  }
}
