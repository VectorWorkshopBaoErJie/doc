= Google Play Instant
<google-play-instant>
Google Play Instant 可以让 Android 6.0+ 的设备运行无需安装的原生应用。

#box(image("../docs/en/manuals/images/gpi/gpi-try-now.png"))

== 发布流程
<发布流程>
如果想让游戏作为 Google Play Instant 发布，需要修改项目配置：

+ 自定义 `AndroidManifest.xml` 文件加入 `<manifest>` 属性：

```lua
xmlns:dist="http://schemas.android.com/apk/distribution"
android:targetSandboxVersion="2"
```

后面紧跟描述项：

```lua
<dist:module dist:instant="true" />
```

结果 AndroidManifest.xml 类似这样：

```lua
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
        package="{{android.package}}"
        android:versionCode="{{android.version_code}}"
        android:versionName="{{project.version}}"
        android:installLocation="auto"
        xmlns:dist="http://schemas.android.com/apk/distribution"
        android:targetSandboxVersion="2">
      <dist:module dist:instant="true" />
```

#block[
#set enum(numbering: "1.", start: 2)
+ 在 "game.project" 文件里添加 Google Instant Apps 扩展。加入 "https:\/\/github.com/defold/extension-instantapp/archive/master.zip" 地址依赖或者指定 特定版本 的依赖。
]

#box(image("../docs/en/manuals/images/gpi/game_project.png"))

#block[
#set enum(numbering: "1.", start: 3)
+ 下载库文件：Project-\>Fetch Libraries
+ 打包 `aab`：Project-\>Bundle-\>Android Application
+ 上传 `aab` 至 Google Play Console 作为 Android Instant App 发布
]

=== 版本号
<版本号>
注意 关于版本号的建议：Instant 游戏版本号要小于可安装游戏的版本号。

#box(image("../docs/en/manuals/images/gpi/version_code.png"))

=== android:targetSandboxVersion="2"
<androidtargetsandboxversion2>
如果在可安装主游戏里设置 `android:targetSandboxVersion="2"` 就可以像 instant 游戏一样访问数据（比如存取同一个文件）。但是这样一来主游戏程序就可能会受到一些限制。详情请见 官方文档。
::: sidenote
游戏一旦安装，它的目标沙箱值只能增加。要想降级，只能把游戏删除再覆盖安装 manifest 属性里目标沙箱值较小的版本。
:::
即使在可安装游戏和 instant 游戏里的 `android:targetSandboxVersion` 设置了不同的值，仍然可以使用 `instantapp.set_cookie()` 和 `instantapp.get_cookie()` 来进行游戏版本间通信。

== API 使用
<api-使用>
Google Play Instant 扩展使用 `instantapp.*` 命名空间封装了 Java PackageManagerCompat 方法 API 供 Lua 使用。

如果你要制作跨平台游戏最好在使用前检查 `instantapp` 模块是否存在，因为它只存在于安卓游戏包中：

```lua
if instantapp then
  -- 调用 instantapp 方法
end
```

例如:

```lua
if instantapp and instantapp.is_instant_app() then
  -- 如果它是 instant 游戏就存档然后显示提示信息
  local cookie_size = instantapp.get_cookie_max_size()
  if cookie_size > 0 then
    instantapp.set_cookie(bytes_of_save_data)
  end
  instantapp.show_install_prompt()
else
  -- 其他一般游戏的逻辑代码
end
```

关于在 Defold 里使用 Google Instant API 的详细信息请见 API 文档。

== 限制
<限制>
遵循 Google Play Instant Technical Requirements `apk` 大小不得大于 15 MB。游戏大小优化详见 这里。

== 测试
<测试>
#box(image("../docs/en/manuals/images/gpi/start_instant.png"))

+ 下载 Android SDK 工具：

- macOS: https:\/\/dl.google.com/android/repository/tools\_r25.2.3-macosx.zip
- Windows: https:\/\/dl.google.com/android/repository/tools\_r25.2.3-windows.zip
- Linux: https:\/\/dl.google.com/android/repository/tools\_r25.2.3-linux.zip

#block[
#set enum(numbering: "1.", start: 2)
+ 解压拷贝 `tools` 文件夹到 `android-sdk` 文件夹。
+ 安卓编译工具：
]

```console
./android-sdk/tools/bin/sdkmanager --verbose "build-tools25.0.3"
```

#block[
#set enum(numbering: "1.", start: 4)
+ 安装 `extra-google-instantapps` 工具：
]

```console
sh ./android-sdk/tools/android update sdk --no-ui --all --filter extra-google-instantapps
```

#block[
#set enum(numbering: "1.", start: 5)
+ 在设备上作为 Instant 游戏加载 `apk` 文件：
]

```console
android-sdk/extras/google/instantapps/ia run path_to_your_game.apk
```

前4步可以合并为一个脚本：

```console
mkdir ~/android
cd ~/android
mkdir android-sdk
# Supported: macosx,linux,windows
PLATFORM=macosx
TOOL_VERSION=25.2.3
wget https://dl.google.com/android/repository/tools_r$TOOL_VERSION-$PLATFORM.zip
tar xvf tools_r$TOOL_VERSION-$PLATFORM.zip
mv tools android-sdk/tools
./android-sdk/tools/bin/sdkmanager --verbose "build-tools25.0.3"
sh ./android-sdk/tools/android update sdk --no-ui --all --filter extra-google-instantapps
```

设备调试详情请见 调试教程。
