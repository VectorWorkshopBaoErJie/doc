= 碰撞形状
<碰撞形状>
碰撞组件可以使用多个基本形状或单个复杂形状。

=== 基本形状
<基本形状>
基本形状有 #emph[盒形]、#emph[球形] 和 #emph[胶囊形]。您可以通过右键单击碰撞对象并选择Add Shape来添加基本形状：

#box(image("../docs/en/manuals/images/physics/add_shape.png"))

== 盒形
<盒形>
盒形具有位置、旋转和尺寸（宽度、高度和深度）：

#box(image("../docs/en/manuals/images/physics/box.png"))

== 球形
<球形>
球形具有位置、旋转和直径：

#box(image("../docs/en/manuals/images/physics/sphere.png"))

== 胶囊形
<胶囊形>
胶囊形具有位置、旋转、直径和高度：

#box(image("../docs/en/manuals/images/physics/capsule.png"))

#block[
胶囊形仅在启用3D物理时受支持（在#emph[game.project]文件的物理部分配置）。

]
=== 复杂形状
<复杂形状>
复杂形状可以由瓦片地图组件创建或由凸包形状创建。

== 瓦片地图碰撞形状
<瓦片地图碰撞形状>
Defold包含一项功能，允许您轻松为瓦片地图使用的瓦片源生成物理形状。瓦片源手册解释了如何向瓦片源添加碰撞组以及将瓦片分配给碰撞组（示例）。

要向瓦片地图添加碰撞：

+ 通过右键单击游戏对象并选择Add Component File将瓦片地图添加到游戏对象。选择瓦片地图文件。
+ 通过右键单击游戏对象并选择Add Component ▸ Collision Object向游戏对象添加碰撞对象组件。
+ 不要向组件添加形状，而是将#emph[Collision Shape]属性设置为#emph[瓦片地图]文件。
+ 像往常一样设置碰撞对象组件的#emph[属性]。

#box(image("../docs/en/manuals/images/physics/collision_tilemap.png"))

#block[
请注意，这里的#emph[Group]属性#strong[不]使用，因为碰撞组已在瓦片地图的瓦片源中定义。

]
== 凸包形状
<凸包形状>
Defold包含一项功能，允许您从三个或更多点创建凸包形状。

+ 使用外部编辑器创建凸包形状文件（文件扩展名`.convexshape`）。
+ 使用文本编辑器或外部工具手动编辑文件（见下文）
+ 不要向碰撞对象组件添加形状，而是将#emph[Collision Shape]属性设置为#emph[凸包形状]文件。

=== 文件格式
<文件格式>
凸包文件格式使用与其他所有Defold文件相同的数据格式，即protobuf文本格式。凸包形状定义了包的点。在2D物理中，点应以逆时针顺序提供。在3D物理模式中使用抽象点云。2D示例：

```
shape_type: TYPE_HULL
data: 200.000
data: 100.000
data: 0.0
data: 400.000
data: 100.000
data: 0.0
data: 400.000
data: 300.000
data: 0.0
data: 200.000
data: 300.000
data: 0.0
```

上面的示例定义了一个矩形的四个角：

```
 200x300   400x300
    4---------3
    |         |
    |         |
    |         |
    |         |
    1---------2
 200x100   400x100
```

== 外部工具
<外部工具>
有几种不同的外部工具可用于创建碰撞形状：

- CodeAndWeb的Physics Editor可用于创建带有精灵和匹配碰撞形状的游戏对象。
- Defold Polygon Editor可用于创建凸包形状。
- Physics Body Editor可用于创建凸包形状。

= 缩放碰撞形状
<缩放碰撞形状>
碰撞对象及其形状继承游戏对象的缩放比例。要禁用此行为，请取消选中#emph[game.project]文件物理部分中的Allow Dynamic Transforms复选框。请注意，仅支持均匀缩放，如果缩放不均匀，将使用最小的缩放值。

= 调整碰撞形状大小
<调整碰撞形状大小>
可以在运行时使用`physics.set_shape()`调整碰撞对象的形状大小。示例：

```lua
-- 设置胶囊形状数据
local capsule_data = {
  type = physics.SHAPE_TYPE_CAPSULE,
  diameter = 10,
  height = 20,
}
physics.set_shape("#collisionobject", "my_capsule_shape", capsule_data)

-- 设置球形数据
local sphere_data = {
  type = physics.SHAPE_TYPE_SPHERE,
  diameter = 10,
}
physics.set_shape("#collisionobject", "my_sphere_shape", sphere_data)

-- 设置盒形数据
local box_data = {
  type = physics.SHAPE_TYPE_BOX,
  dimensions = vmath.vector3(10, 10, 5),
}
physics.set_shape("#collisionobject", "my_box_shape", box_data)
```

#block[
碰撞对象上必须已存在具有指定ID的正确类型的形状。

]
= 旋转碰撞形状
<旋转碰撞形状>
== 在3D物理中旋转碰撞形状
<在3d物理中旋转碰撞形状>
在3D物理中，碰撞形状可以围绕所有轴旋转。

== 在2D物理中旋转碰撞形状
<在2d物理中旋转碰撞形状>
在2D物理中，碰撞形状只能围绕z轴旋转。围绕x或y轴旋转将产生不正确的结果，应避免这样做，即使旋转180度以基本上沿x或y轴翻转形状也不行。要翻转物理形状，建议使用`physics.set_hlip(url, flip)`和`physics.set_vlip(url, flip)`。

= 调试
<调试>
您可以启用物理调试以在运行时查看碰撞形状。
