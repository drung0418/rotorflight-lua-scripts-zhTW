﻿local template = assert(rf2.loadScript(rf2.radio.template))()
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

local gyroFilterType = { [0] = "關閉", "1ST", "2ND" }

labels[#labels + 1] = { t = "陀螺儀低通濾波器 1",       x = x,          y = inc.y(lineSpacing) }
fields[#fields + 1] = { t = "濾波器類型",               x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = #gyroFilterType, vals = { 2 }, table = gyroFilterType,  id = "gyroLowpassType" }
fields[#fields + 1] = { t = "截止頻率",                 x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 4000, vals = { 3, 4 },    id = "gyroLowpassFrequency" }
labels[#labels + 1] = { t = "陀螺儀低通濾波器 1 動態",  x = x,          y = inc.y(lineSpacing) }
fields[#fields + 1] = { t = "最小截止頻率",             x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 1000, vals = { 16, 17 },  id = "gyroLowpassDynMinFrequency" }
fields[#fields + 1] = { t = "最大截止頻率",             x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 1000, vals = { 18, 19 },  id = "gyroLowpassDynMaxFrequency" }
labels[#labels + 1] = { t = "陀螺儀低通濾波器 2",       x = x,          y = inc.y(lineSpacing) }
fields[#fields + 1] = { t = "濾波器類型",               x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = #gyroFilterType, vals = { 5 }, table = gyroFilterType,  id = "gyroLowpass2Type" }
fields[#fields + 1] = { t = "截止頻率",                 x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 4000, vals = { 6, 7 },    id = "gyroLowpass2Frequency" }

inc.y(lineSpacing * 0.25)
labels[#labels + 1] = { t = "陀螺儀陷波濾波器 1",       x = x,          y = inc.y(lineSpacing) }
fields[#fields + 1] = { t = "中心頻率",                 x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 4000, vals = { 8, 9 },    id = "gyroNotch1Frequency" }
fields[#fields + 1] = { t = "截止頻率",                 x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 4000, vals = { 10, 11 },  id = "gyroNotch1Cutoff" }
labels[#labels + 1] = { t = "陀螺儀陷波濾波器 2",       x = x,          y = inc.y(lineSpacing) }
fields[#fields + 1] = { t = "中心頻率",                 x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 4000, vals = { 12, 13 },  id = "gyroNotch2Frequency" }
fields[#fields + 1] = { t = "截止頻率",                 x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 4000, vals = { 14, 15 },  id = "gyroNotch2Cutoff" }

inc.y(lineSpacing * 0.25)
labels[#labels + 1] = { t = "陀螺儀動態陷波濾波器",     x = x,          y = inc.y(lineSpacing) }
-- TODO: enable/disable dynamic notch filters by setting/clearing feature DYN_NOTCH (see MSP_FEATURE_CONFIG)
fields[#fields + 1] = { t = "數量",                     x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 8, vals = { 20 } }
fields[#fields + 1] = { t = "Q 因子",                   x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 10, max = 100, vals = { 21 }, scale = 10, id = "gyroDynamicNotchQ" }
fields[#fields + 1] = { t = "最小頻率",                 x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 10, max = 200, vals = { 22, 23 },  id = "gyroDynamicNotchMinHz" }
fields[#fields + 1] = { t = "最大頻率",                 x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 100, max = 500, vals = { 24, 25 }, id = "gyroDynamicNotchMaxHz"}

return {
    read        = 92, -- MSP_FILTER_CONFIG
    write       = 93, -- MSP_SET_FILTER_CONFIG
    eepromWrite = true,
    reboot      = true,
    title       = "濾波器",
    minBytes    = 25,
    labels      = labels,
    fields      = fields,
    simulatorResponse = { 0, 1, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 25, 25, 0, 245, 0 },
}
