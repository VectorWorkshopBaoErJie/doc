= 解决运动学碰撞
<解决运动学碰撞>
使用运动学碰撞对象需要您自己解决碰撞并作为反应移动对象。一个简单的分离两个碰撞对象的实现看起来像这样：

```lua
function on_message(self, message_id, message, sender)
  -- 处理碰撞
  if message_id == hash("contact_point_response") then
    local newpos = go.get_position() + message.normal * message.distance
    go.set_position(newpos)
  end
end
```

此代码将使您的运动学对象与其穿透的其他物理对象分离，但分离通常会过冲，在许多情况下您会看到抖动。为了更好地理解这个问题，考虑以下情况，其中玩家角色与两个对象 #emph[A] 和 #emph[B] 发生碰撞：

#box(image("../docs/en/manuals/images/physics/collision_multi.png"))

物理引擎将在碰撞发生的帧中发送多个 `"contact_point_response"` 消息，一个用于对象 #emph[A]，一个用于对象 #emph[B]。如果您像上面的简单代码那样响应每个穿透移动角色，结果分离将是：

- 根据 #emph[A] 的穿透距离将角色移出（黑色箭头）
- 根据 #emph[B] 的穿透距离将角色移出（黑色箭头）

这些顺序是任意的，但结果都是一样的：总分离是 #emph[各个穿透向量之和]：

#box(image("../docs/en/manuals/images/physics/separation_naive.png"))

为了正确地将角色与对象 #emph[A] 和 #emph[B] 分离，您需要处理每个接触点的穿透距离，并检查任何先前的分离是否已经完全或部分地解决了分离。

假设第一个接触点消息来自对象 #emph[A]，并且您通过 #emph[A] 的穿透向量将角色移出：

#box(image("../docs/en/manuals/images/physics/separation_step1.png"))

然后角色已经部分地与 #emph[B] 分离。执行与对象 #emph[B] 完全分离所需的最终补偿由上面的黑色箭头指示。补偿向量的长度可以通过将 #emph[A] 的穿透向量投影到 #emph[B] 的穿透向量上来计算：

#box(image("../docs/en/manuals/images/physics/projection.png"))

```
l = vmath.project(A, B) * vmath.length(B)
```

通过将 #emph[B] 的长度减少 #emph[l] 可以找到补偿向量。要为任意数量的穿透计算这个，您可以通过每个接触点，从一个零长度的校正向量开始，在向量中累积必要的校正：

+ 将当前校正投影到接触的穿透向量上。
+ 计算穿透向量中剩余的补偿（根据上述公式）。
+ 通过补偿向量移动对象。
+ 将补偿添加到累积的校正中。

完整的实现看起来像这样：

```lua
function init(self)
  -- 校正向量
  self.correction = vmath.vector3()
end

function update(self, dt)
  -- 重置校正
  self.correction = vmath.vector3()
end

function on_message(self, message_id, message, sender)
  -- 处理碰撞
  if message_id == hash("contact_point_response") then
    -- 获取移出碰撞所需的信息。我们可能会
    -- 得到多个接触点，必须通过为这一帧累积一个
    -- 校正向量来计算如何移出所有接触点：
    if message.distance > 0 then
      -- 首先，将累积的校正投影到
      -- 穿透向量上
      local proj = vmath.project(self.correction, message.normal * message.distance)
      if proj < 1 then
        -- 只关心不会过冲的投影。
        local comp = (message.distance - message.distance * proj) * message.normal
        -- 应用补偿
        go.set_position(go.get_position() + comp)
        -- 累积完成的校正
        self.correction = self.correction + comp
      end
    end
  end
end
```
