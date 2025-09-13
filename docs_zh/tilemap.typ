= 瓦片地图
<瓦片地图>
#emph[瓦片地图]是一个组件，允许您将#emph[瓦片图源]中的瓦片组装或绘制到大网格区域上。瓦片地图通常用于构建游戏关卡环境。您还可以在地图中使用瓦片图源中的#emph[碰撞形状]进行碰撞检测和物理模拟（示例）。

在创建瓦片地图之前，您需要先创建瓦片图源。请参阅瓦片图源手册了解如何创建瓦片图源。

== 创建瓦片地图
<创建瓦片地图>
要创建新的瓦片地图：

- 在#emph[资源]浏览器中右键点击一个位置，然后选择新建… ▸ 瓦片地图）。

- 为文件命名。

- 新的瓦片地图会自动在瓦片地图编辑器中打开。

  #box(image("../docs/en/manuals/images/tilemap/tilemap.png"))

- 将#emph[瓦片图源]属性设置为您已准备好的瓦片图源文件。

要在瓦片地图上绘制瓦片：

+ 在#emph[大纲]视图中选择或创建一个#emph[图层]进行绘制。

+ 选择一个瓦片作为笔刷（按空格键显示瓦片调色板）或通过在调色板中点击并拖动选择几个瓦片来创建包含多个瓦片的矩形笔刷。

  #box(image("../docs/en/manuals/images/tilemap/palette.png"))

+ 使用选定的笔刷进行绘制。要擦除瓦片，可以选择一个空白瓦片作为笔刷使用，或选择橡皮擦（编辑 ▸ 选择橡皮擦）。

  #box(image("../docs/en/manuals/images/tilemap/paint_tiles.png"))

您可以直接从图层中拾取瓦片并将选择用作笔刷。按住Shift并点击瓦片可将其拾取为当前笔刷。按住Shift时，您还可以点击并拖动以选择一块瓦片作为更大的笔刷。此外，还可以通过按住Shift+Ctrl以类似方式剪切瓦片，或通过按住Shift+Alt擦除它们。

要顺时针旋转笔刷，请使用Z。使用X进行水平翻转，使用Y进行垂直翻转笔刷。

#box(image("../docs/en/manuals/images/tilemap/pick_tiles.png"))

== 将瓦片地图添加到游戏中
<将瓦片地图添加到游戏中>
要将瓦片地图添加到游戏中：

+ 创建一个游戏对象来容纳瓦片地图组件。游戏对象可以在文件中或直接在集合中创建。
+ 右键点击游戏对象的根节点，然后选择添加组件文件。
+ 选择瓦片地图文件。

#box(image("../docs/en/manuals/images/tilemap/use_tilemap.png"))

== 运行时操作
<运行时操作>
您可以通过多种不同的函数和属性在运行时操作瓦片地图（请参阅API文档了解用法）。

=== 从脚本更改瓦片
<从脚本更改瓦片>
您可以在游戏运行时动态读取和写入瓦片地图的内容。为此，请使用`tilemap.get_tile()`和`tilemap.set_tile()`函数：

```lua
local tile = tilemap.get_tile("/level#map", "ground", x, y)

if tile == 2 then
    -- 将草地瓦片（2）替换为危险的洞瓦片（编号4）。
    tilemap.set_tile("/level#map", "ground", x, y, 4)
end
```

== 瓦片地图属性
<瓦片地图属性>
除了#emph[Id]、#emph[Position]、#emph[Rotation]和#emph[Scale]属性外，还存在以下组件特定属性：

/ #emph[瓦片图源]: #block[
用于瓦片地图的瓦片图源资源。
]

/ #emph[材质]: #block[
用于渲染瓦片地图的材质。
]

/ #emph[混合模式]: #block[
渲染瓦片地图时使用的混合模式。
]

=== 混合模式
<混合模式>
:blend-modes

=== 更改属性
<更改属性>
瓦片地图有许多不同的属性，可以使用`go.get()`和`go.set()`进行操作：

/ `tile_source`: #block[
瓦片地图的瓦片图源（`hash`）。您可以使用瓦片图源资源属性和`go.set()`更改此属性。请参阅API参考中的示例。
]

/ `material`: #block[
瓦片地图的材质（`hash`）。您可以使用材质资源属性和`go.set()`更改此属性。请参阅API参考中的示例。
]

=== 材质常量
<材质常量>
{% include shared/material-constants.md component='tilemap' variable='tint' %}

/ `tint`: #block[
瓦片地图的颜色色调（`vector4`）。vector4用于表示色调，x、y、z和w分别对应红色、绿色、蓝色和alpha色调。
]

== 项目配置
<项目配置>
#emph[game.project]文件中有一些与瓦片地图相关的项目设置。

== 外部工具
<外部工具>
有一些外部地图/关卡编辑器可以直接导出到Defold瓦片地图：

=== Tiled
<tiled>
Tiled是一个知名且广泛使用的正交、等距和六边形地图编辑器。Tiled支持多种功能，可以直接导出到Defold。在Defold用户”goeshard”的这篇博客文章中了解更多关于如何导出瓦片地图数据和附加元数据的信息。

=== Tilesetter
<tilesetter>
Tilesetter可用于从简单的基础瓦片自动创建完整的瓦片集，它有一个地图编辑器，可以直接导出到Defold。
