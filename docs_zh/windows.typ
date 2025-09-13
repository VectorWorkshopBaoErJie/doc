= Windows 开发
<windows-开发>
为 Windows 平台开发 Defold 应用程序是一个简单直接的过程，几乎不需要考虑任何特殊因素。

== 项目设置
<项目设置>
Windows 特定的应用程序配置在 #emph[game.project] 设置文件的 Windows 部分 中完成。

== 应用图标
<应用图标>
Windows 游戏使用的应用程序图标必须是 .ico 格式。您可以使用在线工具（如 ICOConvert 或 AConvert）轻松地从 .png 文件创建 .ico 文件。上传图像并至少使用以下图标尺寸：16x16、24x24、32x32、48x48、256x256。

来源：Microsoft - Windows 应用图标构建

=== 使用 ImageMagick 软件套件在本地创建 .ico 文件
<使用-imagemagick-软件套件在本地创建-.ico-文件>
ImageMagick 是一个免费的开源软件套件，用于编辑和处理数字图像。

+ 安装 ImageMagick

- Linux：使用 `apt` 安装

```
sudo apt install imagemagick
```

- Windows：从 #link("https://imagemagick.org/script/download.php#windows") 下载
- macOS：使用 `brew` 安装：

```
brew install imagemagick
```

#block[
#set enum(numbering: "1.", start: 2)
+ 准备您的 PNG 图标。
+ 使用 convert 工具将 PNG 转换为 ICO：
]

```bash
magick icon_256x256px.png -compress None -define icon:auto-resize=256,128,96,64,48,32,24,16 favicon.ico
```

== 常见问题
<常见问题>
:Windows 常见问题
