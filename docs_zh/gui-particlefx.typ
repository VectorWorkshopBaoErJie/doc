= GUI ParticleFX节点
<gui-particlefx节点>
粒子特效节点用于在GUI屏幕空间中播放粒子特效系统。

== 添加ParticleFX节点
<添加particlefx节点>
通过在#emph[Outline]中右键点击并选择Add ▸ ParticleFX，或按A并选择ParticleFX来添加新的粒子节点。

您可以使用已添加到GUI中的粒子特效作为效果的源。通过在#emph[Outline]中的#emph[Particle FX]文件夹图标上右键点击并选择Add ▸ Particle FX…来添加粒子特效。然后在节点上设置#emph[Particlefx]属性：

#box(image("../docs/en/manuals/images/gui-particlefx/create.png"))

== 控制效果
<控制效果>
您可以通过脚本控制节点来启动和停止效果：

```lua
-- 启动粒子特效
local particles_node = gui.get_node("particlefx")
gui.play_particlefx(particles_node)
```

```lua
-- 停止粒子特效
local particles_node = gui.get_node("particlefx")
gui.stop_particlefx(particles_node)
```

有关粒子特效工作原理的详细信息，请参阅粒子特效手册。
