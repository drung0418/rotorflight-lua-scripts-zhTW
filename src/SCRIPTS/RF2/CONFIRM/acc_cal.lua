local template = assert(rf2.loadScript(rf2.radio.template))()
local margin = template.margin
local indent = template.indent
local lineSpacing = template.lineSpacing
local tableSpacing = template.tableSpacing
local sp = template.listSpacing.field
local yMinLim = rf2.radio.yMinLimit
local x = margin
local y = yMinLim - lineSpacing
local inc = { x = function(val) x = x + val return x end, y = function(val) y = y + val return y end }
local labels = {}
local fields = {}

labels[#labels + 1] = { t = "保持機體水平",                 x = x, y = inc.y(lineSpacing) }
labels[#labels + 1] = { t = "穩定後按",                     x = x, y = inc.y(lineSpacing) }
labels[#labels + 1] = { t = "[ENTER] 進行校準, or",         x = x, y = inc.y(lineSpacing) }
labels[#labels + 1] = { t = "[EXIT] 取消",                  x = x, y = inc.y(lineSpacing) }
fields[#fields + 1] = { x = x, y = inc.y(lineSpacing), value = "", readOnly = true }

return {
    title  = "加速度計校準",
    labels = labels,
    fields = fields,
    init   = assert(rf2.loadScript("acc_cal.lua"))(),
}
