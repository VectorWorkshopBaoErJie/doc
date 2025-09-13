= GUI 方块节点
<gui-方块节点>
方块节点是一个填充了颜色、纹理或动画的矩形。

== 添加方块节点
<添加方块节点>
添加方块节点可以在 #emph[Outline] 中 右键点击 然后选择 Add ▸ Box, 或者按 A 然后选择 Box.

你可以使用已添加到GUI中的图集或瓦片图源的图像和动画。通过右键点击#emph[Outline]中的#emph[Textures]文件夹图标并选择Add ▸ Textures…来添加纹理。然后设置方块节点的#emph[Texture]属性：

#box(image("../docs/en/manuals/images/gui-box/create.png"))

注意方块节点的颜色会对图形进行染色。染色颜色会与图像数据相乘，这意味着如果将颜色设置为白色（默认值），则不会应用染色效果。

#box(image("../docs/en/manuals/images/gui-box/tinted.png"))

即使没有分配纹理，或者将alpha设置为`0`，或者将大小设置为`0, 0, 0`，方块节点也始终会被渲染。方块节点应该始终分配纹理，以便渲染器能够正确地进行批处理并减少绘制调用次数。

== 播放动画
<播放动画>
方块节点可以播放图集或瓦片图源中的动画。有关详细信息，请参阅逐帧动画手册。

:Slice-9
