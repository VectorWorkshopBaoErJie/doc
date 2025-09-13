= Android 开发
<android-开发>
Android 设备允许你自由运行自己的应用程序。构建游戏版本并将其复制到 Android 设备上非常容易。本手册解释了为 Android 打包游戏所涉及的步骤。在开发过程中，通过开发应用运行游戏通常是首选，因为它允许你直接将内容和代码热重载到设备上。

== Android 和 Google Play 签名流程
<android-和-google-play-签名流程>
Android 要求所有 APK 在安装到设备上或更新之前都必须使用证书进行数字签名。如果你使用 Android App Bundles，只需在上传到 Play Console 之前对你的应用包进行签名，Play App Signing会处理其余部分。但是，你也可以手动为应用签名，以便上传到 Google Play、其他应用商店以及在任何商店之外分发。

当你从 Defold 编辑器或命令行工具创建 Android 应用包时，你可以提供一个密钥库（包含你的证书和密钥）和密钥库密码，这些将在签名你的应用程序时使用。如果你不提供，Defold 会生成一个调试密钥库并在签名应用程序包时使用它。

#block[
你#strong[绝对不应该]将使用调试密钥库签名的应用程序上传到 Google Play。始终使用你自己创建的专用密钥库。

]
== 创建密钥库
<创建密钥库>
#block[
Defold 中的 Android 签名流程在版本 1.2.173 中发生了变化，从使用独立的密钥和证书改为使用密钥库。更多信息请参阅此论坛帖子。

]
你可以使用 Android Studio或从终端/命令提示符创建密钥库：

```bash
keytool -genkey -v -noprompt -dname "CN=John Smith, OU=Area 51, O=US Air Force, L=Unknown, ST=Nevada, C=US" -keystore mykeystore.keystore -storepass 5Up3r_53cR3t -alias myAlias -keyalg RSA -validity 9125
```

这将创建一个名为 `mykeystore.keystore` 的密钥库文件，其中包含一个密钥和证书。对密钥和证书的访问将受到密码 `5Up3r_53cR3t` 的保护。密钥和证书将在 25 年（9125 天）内有效。生成的密钥和证书将通过别名 `myAlias` 进行标识。

#block[
确保将密钥库和相关密码存储在安全的地方。如果你自己签名并将应用程序上传到 Google Play，而密钥库或密钥库密码丢失，你将无法在 Google Play 上更新应用程序。你可以通过使用 Google Play App Signing 并让 Google 为你签名应用程序来避免这种情况。

]
== 创建 Android 应用包
<创建-android-应用包>
编辑器允许你轻松地为游戏创建独立的应用包。在打包之前，你可以在 #emph[game.project] 项目设置文件 中指定要使用的图标、设置版本代码等。

要从菜单中选择打包，请选择 Project ▸ Bundle… ▸ Android Application…。

如果你希望编辑器自动创建随机调试证书，请将 #emph[Keystore] 和 #emph[Keystore password] 字段留空：

#box(image("../docs/en/manuals/images/android/sign_bundle.png"))

如果你想使用特定的密钥库为你的包签名，请指定 #emph[Keystore] 和 #emph[Keystore password]。#emph[Keystore] 预期具有 `.keystore` 文件扩展名，而密码预期存储在具有 `.txt` 扩展名的文本文件中。如果密钥库中的密钥使用与密钥库本身不同的密码，也可以指定 #emph[Key password]：

#box(image("../docs/en/manuals/images/android/sign_bundle2.png"))

Defold 支持创建 APK 和 AAB 文件。从 Bundle Format 下拉菜单中选择 APK 或 AAB。

配置好应用包设置后，按 Create Bundle。然后系统会提示你指定在计算机上创建包的位置。

#box(image("../docs/en/manuals/images/android/apk_file.png"))

:Build Variants

=== 安装 Android 应用包
<安装-android-应用包>
==== 安装 APK
<安装-apk>
一个 #emph[`.apk`] 文件可以使用 `adb` 工具复制到你的设备上，或者通过 Google Play 开发者控制台 复制到 Google Play。

:Android ADB

```
$ adb install Defold\ examples.apk
4826 KB/s (18774344 bytes in 3.798s)
  pkg: /data/local/tmp/my_app.apk
Success
```

==== 使用编辑器安装 APK
<使用编辑器安装-apk>
你可以使用编辑器打包对话框中的”在连接的设备上安装”和”启动已安装的应用”复选框来安装和启动 #emph[`.apk`] 文件：

#box(image("../docs/en/manuals/images/android/install_and_launch.png"))

要使此功能正常工作，你需要安装 ADB 并在连接的设备上启用 #emph[USB 调试]。如果编辑器无法检测到 ADB 命令行工具的安装位置，你需要在首选项中指定它。

==== 安装 AAB
<安装-aab>
一个 #emph[.aab] 文件可以通过 Google Play 开发者控制台 上传到 Google Play。也可以使用 #emph[.aab] 文件制作 #emph[.apk] 以便使用 `bundletool` 在本地安装。

== 权限
<权限>
Defold 引擎需要许多不同的权限才能使所有引擎功能正常工作。权限在 `AndroidManifest.xml` 中定义，在 #emph[game.project] 项目设置文件 中指定。你可以在官方文档中阅读更多关于 Android 权限的信息。默认清单中请求以下权限：

=== android.permission.INTERNET 和 android.permission.ACCESS\_NETWORK\_STATE (保护级别: normal)
<android.permission.internet-和-android.permission.access_network_state-保护级别-normal>
允许应用程序打开网络套接字并访问网络信息。这些权限是访问互联网所必需的。（Android 官方文档）和（Android 官方文档）。

=== android.permission.WAKE\_LOCK (保护级别: normal)
<android.permission.wake_lock-保护级别-normal>
允许使用 PowerManager WakeLocks 来防止处理器休眠或屏幕变暗。在接收推送通知时暂时防止设备休眠需要此权限。（Android 官方文档）

== 使用 AndroidX
<使用-androidx>
AndroidX 是对原始 Android 支持库重大改进，该支持库已不再维护。AndroidX 包通过提供功能对等和新库完全取代了支持库。资源门户 中的大多数 Android 扩展都支持 AndroidX。如果你不想使用 AndroidX，可以通过在应用程序清单中勾选 `Use Android Support Lib` 来明确禁用它，转而使用旧的 Android 支持库。

#box(image("../docs/en/manuals/images/android/enable_supportlibrary.png"))

== 常见问题
<常见问题>
:Android 问答
