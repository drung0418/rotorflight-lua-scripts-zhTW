local template = assert(rf2.loadScript(rf2.radio.template))()
local margin = template.margin
local indent = template.indent
local lineSpacing = template.lineSpacing
local tableSpacing = template.tableSpacing
local sp = template.listSpacing.field
local yMinLim = rf2.radio.yMinLimit
local x = margin
local y = yMinLim - lineSpacing
local function incY(val) y = y + val return y end
local labels = {}
local fields = {}
local filterConfig = rf2.useApi("mspFilterConfig").getDefaults()

labels[#labels + 1] = { t = "陀螺儀低通濾波器 1",           x = x,          y = incY(lineSpacing) }
fields[#fields + 1] = { t = "濾波器類型",              x = x + indent, y = incY(lineSpacing), sp = x + sp, data = filterConfig.gyro_lpf1_type,           id = "gyroLowpassType" }
fields[#fields + 1] = { t = "截止頻率",                   x = x + indent, y = incY(lineSpacing), sp = x + sp, data = filterConfig.gyro_lpf1_static_hz,      id = "gyroLowpassFrequency" }
labels[#labels + 1] = { t = "陀螺儀低通濾波器 1 動態",   x = x,          y = incY(lineSpacing) }
fields[#fields + 1] = { t = "最小截止頻率",               x = x + indent, y = incY(lineSpacing), sp = x + sp, data = filterConfig.gyro_lpf1_dyn_min_hz,     id = "gyroLowpassDynMinFrequency" }
fields[#fields + 1] = { t = "最大截止頻率",               x = x + indent, y = incY(lineSpacing), sp = x + sp, data = filterConfig.gyro_lpf1_dyn_max_hz,     id = "gyroLowpassDynMaxFrequency" }
labels[#labels + 1] = { t = "陀螺儀低通濾波器 2",           x = x,          y = incY(lineSpacing) }
fields[#fields + 1] = { t = "濾波器類型",              x = x + indent, y = incY(lineSpacing), sp = x + sp, data = filterConfig.gyro_lpf2_type,           id = "gyroLowpass2Type" }
fields[#fields + 1] = { t = "截止頻率",                   x = x + indent, y = incY(lineSpacing), sp = x + sp, data = filterConfig.gyro_lpf2_static_hz,      id = "gyroLowpass2Frequency" }

incY(lineSpacing * 0.25)
labels[#labels + 1] = { t = "陀螺儀陷波濾波器 1",             x = x,          y = incY(lineSpacing) }
fields[#fields + 1] = { t = "中心頻率",                   x = x + indent, y = incY(lineSpacing), sp = x + sp, data = filterConfig.gyro_soft_notch_hz_1,     id = "gyroNotch1Frequency" }
fields[#fields + 1] = { t = "截止頻率",                   x = x + indent, y = incY(lineSpacing), sp = x + sp, data = filterConfig.gyro_soft_notch_cutoff_1, id = "gyroNotch1Cutoff" }
labels[#labels + 1] = { t = "陀螺儀陷波濾波器 2",             x = x,          y = incY(lineSpacing) }
fields[#fields + 1] = { t = "中心頻率",                   x = x + indent, y = incY(lineSpacing), sp = x + sp, data = filterConfig.gyro_soft_notch_hz_2,     id = "gyroNotch2Frequency" }
fields[#fields + 1] = { t = "截止頻率",                   x = x + indent, y = incY(lineSpacing), sp = x + sp, data = filterConfig.gyro_soft_notch_cutoff_2, id = "gyroNotch2Cutoff" }

incY(lineSpacing * 0.25)
labels[#labels + 1] = { t = "動態陷波濾波器",    x = x,          y = incY(lineSpacing) }
-- TODO: enable/disable dynamic notch filters by setting/clearing feature DYN_NOTCH (see MSP_FEATURE_CONFIG)
fields[#fields + 1] = { t = "數量",                    x = x + indent, y = incY(lineSpacing), sp = x + sp, data = filterConfig.dyn_notch_count }
fields[#fields + 1] = { t = "Q 值",                        x = x + indent, y = incY(lineSpacing), sp = x + sp, data = filterConfig.dyn_notch_q,              id = "gyroDynamicNotchQ" }
fields[#fields + 1] = { t = "最小頻率",            x = x + indent, y = incY(lineSpacing), sp = x + sp, data = filterConfig.dyn_notch_min_hz,         id = "gyroDynamicNotchMinHz" }
fields[#fields + 1] = { t = "最大頻率",            x = x + indent, y = incY(lineSpacing), sp = x + sp, data = filterConfig.dyn_notch_max_hz,         id = "gyroDynamicNotchMaxHz"}
-- TODO: preset and min_hz for API >= 12.08

local function receivedFilterConfig(page, _)
    rf2.lcdNeedsInvalidate = true
    page.isReady = true
end

return {
    read = function(self)
        rf2.useApi("mspFilterConfig").read(receivedFilterConfig, self, filterConfig)
    end,
    write = function(self)
        rf2.useApi("mspFilterConfig").write(filterConfig)
        rf2.settingsSaved()
    end,
    eepromWrite = true,
    reboot      = true,
    title       = "濾波器",
    labels      = labels,
    fields      = fields,
}
