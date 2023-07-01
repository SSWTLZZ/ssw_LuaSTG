---以LuaSTG自带的渲染img的函数的参数来渲染纹理
---by SSWTLZZ

---@alias ssw.FourPoint "{color1, color2, color3, color4}" | "（u, v均为归一化值）{{u1, v1, color1}, {u2, v2, color2}, {u3, v3, color3}, {u4, v4, color4}}"

local function rotate_pos(x, y, rot)
    return x * cos(rot) - y * sin(rot), y * cos(rot) + x * sin(rot)
end

local __t1, __t2, __t3, __t4 = {}, {}, {}, {}
local __hs, __vs
local __x, __y
ssw = {}
local default_t = { { 0, 0, Color(255, 255, 255, 255) }, { 1, 0, Color(255, 255, 255, 255) },
    { 1, 1, Color(255, 255, 255, 255) }, { 0, 1, Color(255, 255, 255, 255) } }
local _t_s = {}
---以Render的参数来绘制纹理
---@param blend lstg.BlendMode 混合模式
---@param t ssw.FourPoint|lstg.Color 四点参数表或者颜色
---@param tex string 纹理名
---@param x number x坐标
---@param y number y坐标
---@param rot? number 角度
---@param hscale? number 横比
---@param vscale? number 纵比
---@param z? number z坐标
local function Render(blend, t, tex, x, y, rot, hscale, vscale, z)
    blend = blend or ''
    rot = rot or 0
    hscale = hscale or 1
    vscale = vscale or hscale
    z = z or 0.5
    t = t or default_t
    _t_s[tex] = _t_s[tex] or { GetTextureSize(tex) }

    if type(t) == "userdata" then
        __x, __y = rotate_pos(-_t_s[tex][1] / 2 * hscale, _t_s[tex][2] / 2 * vscale, rot)
        __t1 = { __x + x, __y + y, z, 0, 0, t }
        __x, __y = rotate_pos(_t_s[tex][1] / 2 * hscale, _t_s[tex][2] / 2 * vscale, rot)
        __t2 = { __x + x, __y + y, z, _t_s[tex][1], 0, t }
        __x, __y = rotate_pos(_t_s[tex][1] / 2 * hscale, -_t_s[tex][2] / 2 * vscale, rot)
        __t3 = { __x + x, __y + y, z, _t_s[tex][1], _t_s[tex][2], t }
        __x, __y = rotate_pos(-_t_s[tex][1] / 2 * hscale, -_t_s[tex][2] / 2 * vscale, rot)
        __t4 = { __x + x, __y + y, z, 0, _t_s[tex][2], t }
    elseif type(t) == "table" then
        if t[1] and type(t[1]) == "table" then
            __x, __y = rotate_pos(-_t_s[tex][1] / 2 * hscale, _t_s[tex][2] / 2 * vscale, rot)
            __t1 = { __x + x, __y + y, z, t[1][1] * _t_s[tex][1], t[1][2] * _t_s[tex][2], t[1][3] }
            __x, __y = rotate_pos(_t_s[tex][1] / 2 * hscale, _t_s[tex][2] / 2 * vscale, rot)
            __t2 = { __x + x, __y + y, z, t[2][1] * _t_s[tex][1], t[2][2] * _t_s[tex][2], t[2][3] }
            __x, __y = rotate_pos(_t_s[tex][1] / 2 * hscale, -_t_s[tex][2] / 2 * vscale, rot)
            __t3 = { __x + x, __y + y, z, t[3][1] * _t_s[tex][1], t[3][2] * _t_s[tex][2], t[3][3] }
            __x, __y = rotate_pos(-_t_s[tex][1] / 2 * hscale, -_t_s[tex][2] / 2 * vscale, rot)
            __t4 = { __x + x, __y + y, z, t[4][1] * _t_s[tex][1], t[4][2] * _t_s[tex][2], t[4][3] }
        else
            __x, __y = rotate_pos(-_t_s[tex][1] / 2 * hscale, _t_s[tex][2] / 2 * vscale, rot)
            __t1 = { __x + x, __y + y, z, 0, 0, t[1] }
            __x, __y = rotate_pos(_t_s[tex][1] / 2 * hscale, _t_s[tex][2] / 2 * vscale, rot)
            __t2 = { __x + x, __y + y, z, _t_s[tex][1], 0, t[2] }
            __x, __y = rotate_pos(_t_s[tex][1] / 2 * hscale, -_t_s[tex][2] / 2 * vscale, rot)
            __t3 = { __x + x, __y + y, z, _t_s[tex][1], _t_s[tex][2], t[3] }
            __x, __y = rotate_pos(-_t_s[tex][1] / 2 * hscale, -_t_s[tex][2] / 2 * vscale, rot)
            __t4 = { __x + x, __y + y, z, 0, _t_s[tex][2], t[4] }
        end
    end
    RenderTexture(tex, blend, __t1, __t2, __t3, __t4)
end

ssw.Render = Render

---在矩形区域内绘制纹理
---@param blend lstg.BlendMode 混合模式
---@param t ssw.FourPoint|lstg.Color 四点参数表或者颜色
---@param tex string 纹理名
---@param left number
---@param right number
---@param bottom number
---@param top number
local function RenderRect(blend, t, tex, left, right, bottom, top)
    blend = blend or ''
    t = t or default_t
    _t_s[tex] = _t_s[tex] or { GetTextureSize(tex) }
    if type(t) == "userdata" then
        __t1 = { left, top, 0.5, 0, 0, t }
        __t2 = { right, top, 0.5, _t_s[tex][1], 0, t }
        __t3 = { right, bottom, 0.5, _t_s[tex][1], _t_s[tex][2], t }
        __t4 = { left, bottom, 0.5, 0, _t_s[tex][2], t }
    elseif type(t) == "table" then
        if t[1] and type(t[1]) == "table" then
            __t1 = { left, top, 0.5, t[1][1] * _t_s[tex][1], t[1][2] * _t_s[tex][2], t[1][3] }
            __t2 = { right, top, 0.5, t[2][1] * _t_s[tex][1], t[2][2] * _t_s[tex][2], t[2][3] }
            __t3 = { right, bottom, 0.5, t[3][1] * _t_s[tex][1], t[3][2] * _t_s[tex][2], t[3][3] }
            __t4 = { left, bottom, 0.5, t[4][1] * _t_s[tex][1], t[4][2] * _t_s[tex][2], t[4][3] }
        else
            __t1 = { left, top, 0.5, 0, 0, t[1] }
            __t2 = { right, top, 0.5, _t_s[tex][1], 0, t[2] }
            __t3 = { right, bottom, 0.5, _t_s[tex][1], _t_s[tex][2], t[3] }
            __t4 = { left, bottom, 0.5, 0, _t_s[tex][2], t[4] }
        end
    end
    RenderTexture(tex, blend, __t1, __t2, __t3, __t4)
end

ssw.RenderRect = RenderRect

--- 指定 4 个顶点位置绘制纹理（有必要吗）
---@param blend lstg.BlendMode 混合模式
---@param t ssw.FourPoint|lstg.Color 四点参数表或者颜色
---@param tex string 纹理名
---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param x3 number
---@param y3 number
---@param z3 number
---@param x4 number
---@param y4 number
---@param z4 number
local function Render4V(blend, t, tex, x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4)
    blend = blend or ''
    t = t or default_t
    _t_s[tex] = _t_s[tex] or { GetTextureSize(tex) }
    if type(t) == "userdata" then
        __t1 = { x1, y1, z1, 0, 0, t }
        __t2 = { x2, y2, z2, _t_s[tex][1], 0, t }
        __t3 = { x3, y3, z3, _t_s[tex][1], _t_s[tex][2], t }
        __t4 = { x4, y4, z4, 0, _t_s[tex][2], t }
    elseif type(t) == "table" then
        if t[1] and type(t[1]) == "table" then
            __t1 = { x1, y1, z1, t[1][1] * _t_s[tex][1], t[1][2] * _t_s[tex][2], t[1][3] }
            __t2 = { x2, y2, z2, t[2][1] * _t_s[tex][1], t[2][2] * _t_s[tex][2], t[2][3] }
            __t3 = { x3, y3, z3, t[3][1] * _t_s[tex][1], t[3][2] * _t_s[tex][2], t[3][3] }
            __t4 = { x4, y4, z4, t[4][1] * _t_s[tex][1], t[4][2] * _t_s[tex][2], t[4][3] }
        else
            __t1 = { x1, y1, z1, 0, 0, t[1] }
            __t2 = { x2, y2, z2, _t_s[tex][1], 0, t[2] }
            __t3 = { x3, y3, z3, _t_s[tex][1], _t_s[tex][2], t[3] }
            __t4 = { x4, y4, z4, 0, _t_s[tex][2], t[4] }
        end
    end
end

ssw.Render4V = Render4V