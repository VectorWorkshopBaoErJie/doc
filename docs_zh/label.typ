= Label
<label>
#emph[Label] 组件在游戏空间中渲染一段文本。默认情况下，它会与所有精灵和图块图形一起排序和绘制。该组件有一组属性，用于控制文本的渲染方式。Defold的GUI支持文本，但在游戏世界中放置GUI元素可能比较棘手。Labels使这一过程变得更加简单。

== 创建 label
<创建-label>
要创建一个 Label 组件, 在游戏对象上 右键点击 选择 Add Component ▸ Label.

#box(image("../docs/en/manuals/images/label/add_label.png"))

(如果你想从同一模板实例化多个label，也可以创建一个新的label组件文件：在#emph[Assets]浏览器中的文件夹上右键点击并选择New… ▸ Label，然后将该文件作为组件添加到任何游戏对象)

#box(image("../docs/en/manuals/images/label/label.png"))

将#emph[Font]属性设置为您想要使用的字体，并确保将#emph[Material]属性设置为与字体类型相匹配的材质：

#box(image("../docs/en/manuals/images/label/font_material.png"))

== Label 属性
<label-属性>
除了#emph[Id]、#emph[Position]、#emph[Rotation]和#emph[Scale]属性外，还存在以下组件特有属性：

/ #emph[Text]: #block[
标签的文本内容。
]

/ #emph[Size]: #block[
文本边界框的大小。如果设置了#emph[Line Break]，宽度将指定文本应在何处换行。
]

/ #emph[Color]: #block[
文本的颜色.
]

/ #emph[Outline]: #block[
轮廓的颜色。
]

/ #emph[Shadow]: #block[
阴影的颜色。
]

#block[
请注意，默认材质出于性能原因禁用了阴影渲染。

]
/ #emph[Leading]: #block[
行间距的缩放数值。0值表示没有行间距。默认为1。
]

/ #emph[Tracking]: #block[
字间距的缩放数值。默认为0。
]

/ #emph[Pivot]: #block[
文本的轴心点。使用此属性来更改文本对齐方式（见下文）。
]

/ #emph[Blend Mode]: #block[
渲染标签时使用的混合模式。
]

/ #emph[Line Break]: #block[
文本对齐遵循轴心点设置，设置此属性允许文本流到多行。组件的宽度决定文本换行的位置。请注意，文本中必须有空格才能换行。
]

/ #emph[Font]: #block[
用于此标签的字体资源。
]

/ #emph[Material]: #block[
用于渲染此标签的材质。确保选择为您使用的字体类型（位图、距离场或BMFont）创建的材质。
]

=== 混合模式
<混合模式>
:blend-modes

=== 轴心点和对齐
<轴心点和对齐>
通过设置#emph[Pivot]属性，您可以更改文本的对齐模式。

/ #emph[Center]: #block[
如果轴心点设置为`Center`、`North`或`South`，则文本居中对齐。
]

/ #emph[Left]: #block[
如果轴心点设置为任何`West`模式，则文本左对齐。
]

/ #emph[Right]: #block[
如果轴心点设置为任何`East`模式，则文本右对齐。
]

#box(image("../docs/en/manuals/images/label/align.png"))

== 运行时操作
<运行时操作>
您可以在运行时通过获取和设置标签文本以及其他各种属性来操作标签。

/ `color`: #block[
标签颜色（`vector4`）
]

/ `outline`: #block[
标签轮廓颜色（`vector4`）
]

/ `shadow`: #block[
标签阴影颜色（`vector4`）
]

/ `scale`: #block[
标签缩放，可以是用于均匀缩放的`number`，或者是用于沿各轴单独缩放的`vector3`。
]

/ `size`: #block[
标签大小（`vector3`）
]

```lua
function init(self)
    -- 设置与此脚本在同一游戏对象中的"my_label"组件的文本。
    label.set_text("#my_label", "新文本")
end
```

```lua
function init(self)
    -- 设置与此脚本在同一游戏对象中的"my_label"组件的颜色。
    -- 颜色是存储在vector4中的RGBA值。
    local grey = vmath.vector4(0.5, 0.5, 0.5, 1.0)
    go.set("#my_label", "color", grey)

    -- ...通过将其alpha设置为0来移除轮廓...
    go.set("#my_label", "outline.w", 0)

    -- ...沿x轴将其缩放2倍。
    local scale_x = go.get("#my_label", "scale.x")
    go.set("#my_label", "scale.x", scale_x * 2)
end
```

== 项目配置
<项目配置>
#emph[game.project]文件中有一些与标签相关的项目设置。
