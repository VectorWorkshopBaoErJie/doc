= 图集
<图集>
虽然单个图像通常用作精灵的源，但出于性能考虑，图像需要合并成更大的图像集，称为图集。将较小的图像集合并成图集在移动设备上尤其重要，因为与桌面计算机或专用游戏机相比，移动设备的内存和处理能力更为稀缺。

在 Defold 中，图集资源是一个单独图像文件的列表，这些文件会自动合并成一个更大的图像。

== 创建图集
<创建图集>
在 #emph[Assets] 浏览器中的上下文菜单中选择 New… ▸ Atlas。命名新的图集文件。编辑器现在将在图集编辑器中打开该文件。图集属性显示在
#emph[Properties] 面板中，因此您可以编辑它们（详见下文）。

您需要先用图像或动画填充图集，然后才能将其用作精灵和粒子效果组件等对象组件的图形源。

确保您已将图像添加到项目中（将图像文件拖放到 #emph[Assets] 浏览器中的正确位置）。

/ 添加单个图像: #block[
从 #emph[Asset] 面板将图像拖放到编辑器视图中。

或者，在 #emph[Outline] 面板中 右键点击 根 Atlas 条目。

从弹出的上下文菜单中选择 Add Images 以添加单个图像。

将打开一个对话框，您可以从中查找并选择要添加到 Atlas 的图像。请注意，您可以过滤图像文件并一次选择多个文件。

#box(image("../docs/en/manuals/images/atlas/add.png"))

添加的图像列在 #emph[Outline] 中，完整的图集可以在中心编辑器视图中看到。您可能需要按 F（从菜单中选择 View ▸ Frame Selection）来框选选择。

#box(image("../docs/en/manuals/images/atlas/single_images.png"))
]

/ 添加翻书动画: #block[
在 #emph[Outline] 面板中 右键点击 根 Atlas 条目。

从弹出的上下文菜单中选择 Add Animation Group 以创建翻书动画组。

一个新的、空的、具有默认名称（"New Animation"）的动画组被添加到图集中。

从 #emph[Asset] 面板将图像拖放到编辑器视图中，将它们添加到当前选定的组中。

或者，右键点击 新组并从上下文菜单中选择 Add Images。

将打开一个对话框，您可以从中查找并选择要添加到动画组的图像。

#box(image("../docs/en/manuals/images/atlas/add_animation.png"))

选定动画组后按 空格键 预览，按 Ctrl/Cmd+T 关闭预览。根据需要调整动画的 #emph[Properties]（见下文）。

#box(image("../docs/en/manuals/images/atlas/animation_group.png"))
]

您可以通过选择图像并按 Alt + Up/down 来重新排列 Outline 中的图像。您还可以通过在 Outline 中复制和粘贴图像（从 Edit 菜单、右键上下文菜单或键盘快捷键）轻松创建副本。

== 图集属性
<图集属性>
每个图集资源都有一组属性。当您在 #emph[Outline] 视图中选择根项目时，这些属性会显示在 #emph[Properties] 面板中。

/ Size: #block[
显示生成的纹理资源的计算总大小。宽度和高度设置为最接近的2的幂。请注意，如果启用纹理压缩，某些格式需要方形纹理。非方形纹理将被调整大小并用空白填充以使纹理变为方形。有关详细信息，请参阅纹理配置文件手册。
]

/ Margin: #block[
应在每个图像之间添加的像素数。
]

/ Inner Padding: #block[
应在每个图像周围填充的空白像素数。
]

/ Extrude Borders: #block[
应在每个图像周围重复填充的边缘像素数。当片段着色器在图像边缘采样像素时，相邻图像（在同一图集纹理上）的像素可能会渗入。扩展边缘可以解决这个问题。
]

/ Max Page Size: #block[
多页图集中一页的最大尺寸。这可用于将图集拆分为同一图集的多个页面，以限制图集大小，同时仍仅使用单次绘制调用。此功能必须与位于 `/builtins/materials/*_paged_atlas.material` 中的启用多页图集的材料结合使用。
]

#box(image("../docs/en/manuals/images/atlas/multipage_atlas.png"))

/ Rename Patterns: #block[
以逗号（´,´）分隔的搜索和替换模式列表，其中每个模式的形式为 `search=replace`。
每个图像的原始名称（文件基本名称）将使用这些模式进行转换。（例如，模式 `hat=cat,_normal=`，将把名为 `hat_normal` 的图像重命名为 `cat`）。这在匹配图集之间的动画时很有用。
]

以下是不同属性设置的示例，其中四个64x64的正方形图像被添加到图集中。请注意，一旦图像无法适应128x128，图集如何跳转到256x256，导致大量浪费的纹理空间。

#box(image("../docs/en/manuals/images/atlas/atlas_properties.png"))

== 图像属性
<图像属性>
图集中的每个图像都有一组属性：

/ Id: #block[
图像的ID（只读）。
]

/ Size: #block[
图像的宽度和高度（只读）。
]

/ Pivot: #block[
图像的轴心点（以单位为单位）。左上角是(0,0)，右下角是(1,1)。默认是(0.5, 0.5)。轴心点可以在0-1范围之外。轴心点是图像在精灵等中使用时将被居中的位置。您可以通过拖动编辑器视图上的轴心手柄来修改轴心点。只有当选择单个图像时，手柄才可见。拖动时按住 Shift 可以启用捕捉。
]

/ Sprite Trim Mode: #block[
精灵的渲染方式。默认是将精灵渲染为矩形（Sprite Trim Mode设置为Off）。如果精灵包含大量透明像素，使用4到8个顶点将精灵渲染为非矩形形状可能更有效。请注意，精灵修剪不与9宫格精灵一起工作。
]

/ Image: #block[
图像本身的路径。
]

#box(image("../docs/en/manuals/images/atlas/image_properties.png"))

== 动画属性
<动画属性>
除了作为动画组一部分的图像列表外，还有一组可用属性：

/ Id: #block[
动画的名称。
]

/ Fps: #block[
动画的播放速度，以每秒帧数（FPS）表示。
]

/ Flip horizontal: #block[
水平翻转动画。
]

/ Flip vertical: #block[
垂直翻转动画。
]

/ Playback: #block[
指定动画应如何播放：
- `None` 完全不播放，显示第一张图像。
- `Once Forward` 从第一张到最后一张图像播放动画一次。
- `Once Backward` 从最后一张到第一张图像播放动画一次。
- `Once Ping Pong` 从第一张到最后一张图像播放动画一次，然后回到第一张图像。
- `Loop Forward` 从第一张到最后一张图像重复播放动画。
- `Loop Backward` 从最后一张到第一张图像重复播放动画。
- `Loop Ping Pong` 从第一张到最后一张图像重复播放动画，然后回到第一张图像。
]

== 运行时纹理和图集创建
<运行时纹理和图集创建>
从 Defold 1.4.2 开始，可以在运行时创建纹理和图集。

=== 在运行时创建纹理资源
<在运行时创建纹理资源>
使用 `resource.create_texture(path, params)` 创建新的纹理资源：

```lua
  local params = {
    width  = 128,
    height = 128,
    type   = resource.TEXTURE_TYPE_2D,
    format = resource.TEXTURE_FORMAT_RGBA,
  }
  local my_texture_id = resource.create_texture("/my_custom_texture.texturec", params)
```

创建纹理后，您可以使用 `resource.set_texture(path, params, buffer)` 设置纹理的像素：

```lua
  local width = 128
  local height = 128
  local buf = buffer.create(width * height, { { name=hash("rgba"), type=buffer.VALUE_TYPE_UINT8, count=4 } } )
  local stream = buffer.get_stream(buf, hash("rgba"))

  for y=1, height do
      for x=1, width do
          local index = (y-1) * width * 4 + (x-1) * 4 + 1
          stream[index + 0] = 0xff
          stream[index + 1] = 0x80
          stream[index + 2] = 0x10
          stream[index + 3] = 0xFF
      end
  end

  local params = { width=width, height=height, x=0, y=0, type=resource.TEXTURE_TYPE_2D, format=resource.TEXTURE_FORMAT_RGBA, num_mip_maps=1 }
  resource.set_texture(my_texture_id, params, buf)
```

#block[
也可以使用 `resource.set_texture()` 通过使用小于纹理完整大小的缓冲区宽度和高度以及通过更改 `resource.set_texture()` 的 x 和 y 参数来更新纹理的子区域。

]
纹理可以直接在模型组件上使用 `go.set()`：

```lua
  go.set("#model", "texture0", my_texture_id)
```

=== 在运行时创建图集
<在运行时创建图集>
如果纹理应该在精灵组件上使用，它首先需要被图集使用。使用 `resource.create_atlas(path, params)` 创建图集：

```lua
  local params = {
    texture = texture_id,
    animations = {
      {
        id          = "my_animation",
        width       = width,
        height      = height,
        frame_start = 1,
        frame_end   = 2,
      }
    },
    geometries = {
      {
        vertices  = {
          0,     0,
          0,     height,
          width, height,
          width, 0
        },
        uvs = {
          0,     0,
          0,     height,
          width, height,
          width, 0
        },
        indices = {0,1,2,0,2,3}
      }
    }
  }
  local my_atlas_id = resource.create_atlas("/my_atlas.texturesetc", params)

  -- assign the atlas to the 'sprite' component on the same go
  go.set("#sprite", "image", my_atlas_id)

  -- play the "animation"
  sprite.play_flipbook("#sprite", "my_animation")
```
