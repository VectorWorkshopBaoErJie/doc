= 属性
<属性>
Defold 为游戏对象、组件和 GUI 节点暴露了可读取、设置和制作动画的属性。存在以下类型的属性：

- 系统定义的游戏对象变换（位置、旋转和缩放）和组件特定属性（例如精灵的像素大小或碰撞对象的质量）
- 在 Lua 脚本中定义的用户定义脚本组件属性（详见脚本属性文档）
- GUI 节点属性
- 在着色器和材质文件中定义的着色器常量（详见材质文档）

当您将鼠标悬停在数值属性的输入字段上时，会显示一个拖动手柄。您可以通过向右/左或向上/下拖动手柄来增加/减少其值。

根据属性所在的位置，您可以通过通用函数或特定于属性的函数来访问它。许多属性可以自动制作动画。通过内置系统制作属性动画比您自己操作属性（在 `update()` 函数内部）更受推荐，这既出于性能考虑，也为了方便。

类型为 `vector3`、`vector4` 或 `quaternion` 的复合属性也暴露其子组件（`x`、`y`、`z` 和 `w`）。您可以通过在名称后加点（`.`）和组件名称来单独寻址这些组件。例如，要设置游戏对象位置的 x 组件：

```lua
-- 将 "game_object" 的 x 位置设置为 10。
go.set("game_object", "position.x", 10)
```

`go.get()`、`go.set()` 和 `go.animate()` 函数将引用作为第一个参数，将属性标识符作为第二个参数。引用标识游戏对象或组件，可以是字符串、哈希或 URL。URL 在寻址手册中有详细解释。属性标识符是命名属性的字符串或哈希：

```lua
-- 设置精灵组件的 x 缩放
local url = msg.url("#sprite")
local prop = hash("scale.x")
go.set(url, prop, 2.0)
```

对于 GUI 节点，节点标识符作为第一个参数提供给特定于属性的函数：

```lua
-- 获取按钮的颜色
local node = gui.get_node("button")
local color = gui.get_color(node)
```

== 游戏对象和组件属性
<游戏对象和组件属性>
所有游戏对象和一些组件类型都具有可在运行时读取和操作的属性。使用 `go.get()` 读取这些值，并使用 `go.set()` 写入它们。根据属性值类型，您可以使用 `go.animate()` 为这些值制作动画。一小部分属性是只读的。

/ #raw(lang:"mark", "get"): #block[
可以使用 `go.get()` 读取。
]

/ #raw(lang:"mark", "get+set"): #block[
可以使用 `go.get()` 读取并使用 `go.set()` 写入。数值可以使用 `go.animate()` 制作动画。
]

#emph[游戏对象属性]

#figure(
  align(center)[#table(
    columns: (12.66%, 48.1%, 18.99%, 20.25%),
    align: (auto,auto,auto,auto,),
    table.header([属性], [描述], [类型], [],),
    table.hline(),
    [#emph[position]], [游戏对象的本地位置。], [`vector3`], [#raw(lang:"mark", "get+set")],
    [#emph[rotation]], [游戏对象的本地旋转，以四元数表示。], [`quaternion`], [#raw(lang:"mark", "get+set")],
    [#emph[euler]], [游戏对象的本地旋转，欧拉角。], [`vector3`], [#raw(lang:"mark", "get+set")],
    [#emph[scale]], [游戏对象的本地非均匀缩放，表示为向量，其中每个组件包含沿每个轴的乘数。要在 x 和 y 方向上将大小加倍，请提供 vmath.vector3(2.0, 2.0, 0)], [`vector3`], [#raw(lang:"mark", "get+set")],
    [#emph[scale.xy]], [游戏对象的本地非均匀缩放，表示为向量，其中每个组件包含沿 X 和 Y 轴的乘数。], [`vector3`], [#raw(lang:"mark", "get+set")],
  )]
  , kind: table
  )

#block[
还存在用于处理游戏对象变换的特定函数；它们是 `go.get_position()`、`go.set_position()`、`go.get_rotation()`、`go.set_rotation()`、`go.get_scale()`、`go.set_scale()` 和 `go.set_scale_xy()`。

]
#emph[精灵组件属性]

#figure(
  align(center)[#table(
    columns: (12.66%, 48.1%, 18.99%, 20.25%),
    align: (auto,auto,auto,auto,),
    table.header([属性], [描述], [类型], [],),
    table.hline(),
    [#emph[size]], [精灵的未缩放大小------从源图集获取的大小。], [`vector3`], [#raw(lang:"mark", "get")],
    [#emph[image]], [精灵的纹理路径哈希。], [`hash`], [#raw(lang:"mark", "get")],
    [#emph[scale]], [精灵的非均匀缩放。], [`vector3`], [#raw(lang:"mark", "get+set")],
    [#emph[scale.xy]], [精灵沿 X 和 Y 轴的非均匀缩放。], [`vector3`], [#raw(lang:"mark", "get+set")],
    [#emph[material]], [精灵使用的材质。], [`hash`], [#raw(lang:"mark", "get+set")],
    [#emph[cursor]], [播放光标的位置（介于 0--1 之间）。], [`number`], [#raw(lang:"mark", "get+set")],
    [#emph[playback\_rate]], [翻页动画的帧率。], [`number`], [#raw(lang:"mark", "get+set")],
  )]
  , kind: table
  )

#emph[碰撞对象组件属性]

#figure(
  align(center)[#table(
    columns: (12.66%, 48.1%, 18.99%, 20.25%),
    align: (auto,auto,auto,auto,),
    table.header([属性], [描述], [类型], [],),
    table.hline(),
    [#emph[mass]], [碰撞对象的质量。], [`number`], [#raw(lang:"mark", "get")],
    [#emph[linear\_velocity]], [碰撞对象的当前线性速度。], [`vector3`], [#raw(lang:"mark", "get")],
    [#emph[angular\_velocity]], [碰撞对象的当前角速度。], [`vector3`], [#raw(lang:"mark", "get")],
    [#emph[linear\_damping]], [碰撞对象的线性阻尼。], [`vector3`], [#raw(lang:"mark", "get+set")],
    [#emph[angular\_damping]], [碰撞对象的角阻尼。], [`vector3`], [#raw(lang:"mark", "get+set")],
  )]
  , kind: table
  )

#emph[模型（3D）组件属性]

#figure(
  align(center)[#table(
    columns: (12.66%, 48.1%, 18.99%, 20.25%),
    align: (auto,auto,auto,auto,),
    table.header([属性], [描述], [类型], [],),
    table.hline(),
    [#emph[animation]], [当前动画。], [`hash`], [#raw(lang:"mark", "get")],
    [#emph[texture0]], [模型的纹理路径哈希。], [`hash`], [#raw(lang:"mark", "get")],
    [#emph[cursor]], [播放光标的位置（介于 0--1 之间）。], [`number`], [#raw(lang:"mark", "get+set")],
    [#emph[playback\_rate]], [动画的播放速率。动画播放速率的乘数。], [`number`], [#raw(lang:"mark", "get+set")],
    [#emph[material]], [模型使用的材质。], [`hash`], [#raw(lang:"mark", "get+set")],
  )]
  , kind: table
  )

#emph[标签组件属性]

#figure(
  align(center)[#table(
    columns: (12.66%, 48.1%, 18.99%, 20.25%),
    align: (auto,auto,auto,auto,),
    table.header([属性], [描述], [类型], [],),
    table.hline(),
    [#emph[scale]], [标签的缩放。], [`vector3`], [#raw(lang:"mark", "get+set")],
    [#emph[scale.xy]], [标签沿 X 和 Y 轴的缩放。], [`vector3`], [#raw(lang:"mark", "get+set")],
    [#emph[color]], [标签的颜色。], [`vector4`], [#raw(lang:"mark", "get+set")],
    [#emph[outline]], [标签的轮廓颜色。], [`vector4`], [#raw(lang:"mark", "get+set")],
    [#emph[shadow]], [标签的阴影颜色。], [`vector4`], [#raw(lang:"mark", "get+set")],
    [#emph[size]], [标签的大小。如果启用了换行，大小将约束文本。], [`vector3`], [#raw(lang:"mark", "get+set")],
    [#emph[material]], [标签使用的材质。], [`hash`], [#raw(lang:"mark", "get+set")],
    [#emph[font]], [标签使用的字体。], [`hash`], [#raw(lang:"mark", "get+set")],
  )]
  , kind: table
  )

== GUI 节点属性
<gui-节点属性>
GUI 节点也包含属性，但它们是通过特殊的 getter 和 setter 函数读取和写入的。对于每个属性，存在一个 get 和一个 set 函数。还定义了一组常量，用于在制作动画时作为对属性的引用。如果您需要引用单独的属性组件，您必须使用属性的字符串名称或字符串名称的哈希。

- `position`（或 `gui.PROP_POSITION`）
- `rotation`（或 `gui.PROP_ROTATION`）
- `scale`（或 `gui.PROP_SCALE`）
- `color`（或 `gui.PROP_COLOR`）
- `outline`（或 `gui.PROP_OUTLINE`）
- `shadow`（或 `gui.PROP_SHADOW`）
- `size`（或 `gui.PROP_SIZE`）
- `fill_angle`（或 `gui.PROP_FILL_ANGLE`）
- `inner_radius`（或 `gui.PROP_INNER_RADIUS`）
- `slice9`（或 `gui.PROP_SLICE9`）

请注意，所有颜色值都编码在 vector4 中，其中组件对应于 RGBA 值：

/ `x`: #block[
红色颜色组件
]

/ `y`: #block[
绿色颜色组件
]

/ `z`: #block[
蓝色颜色组件
]

/ `w`: #block[
Alpha 组件
]

#emph[GUI 节点属性]

#figure(
  align(center)[#table(
    columns: (12.66%, 48.1%, 18.99%, 20.25%),
    align: (auto,auto,auto,auto,),
    table.header([属性], [描述], [类型], [],),
    table.hline(),
    [#emph[color]], [节点的面颜色。], [`vector4`], [`gui.get_color()` `gui.set_color()`],
    [#emph[outline]], [节点的轮廓颜色。], [`vector4`], [`gui.get_outline()` `gui.set_outline()`],
    [#emph[position]], [节点的位置。], [`vector3`], [`gui.get_position()` `gui.set_position()`],
    [#emph[rotation]], [节点的旋转，表示为欧拉角------围绕每个轴旋转的度数。], [`vector3`], [`gui.get_rotation()` `gui.set_rotation()`],
    [#emph[scale]], [节点的缩放，表示为沿每个轴的乘数。], [`vector3`], [`gui.get_scale()` `gui.set_scale()`],
    [#emph[shadow]], [节点的阴影颜色。], [`vector4`], [`gui.get_shadow()` `gui.set_shadow()`],
    [#emph[size]], [节点的未缩放大小。], [`vector3`], [`gui.get_size()` `gui.set_size()`],
    [#emph[fill\_angle]], [饼节点的填充角度，表示为逆时针度数。], [`number`], [`gui.get_fill_angle()` `gui.set_fill_angle()`],
    [#emph[inner\_radius]], [饼节点的内半径。], [`number`], [`gui.get_inner_radius()` `gui.set_inner_radius()`],
    [#emph[slice9]], [九宫格节点的边缘距离。], [`vector4`], [`gui.get_slice9()` `gui.set_slice9()`],
  )]
  , kind: table
  )
