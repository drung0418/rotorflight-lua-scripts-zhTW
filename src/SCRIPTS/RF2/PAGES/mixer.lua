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
local mixerConfig = rf2.useApi("mspMixer").getDefaults()
local mixerOverride = false

local function onClickOverride(field, page)
    if not mixerOverride then
        mixerOverride = true
        field.t = "[Disable Mixer Passthrough]"
    else
        mixerOverride = false
        field.t = "[Enable Mixer Passthrough]"
    end

    local mspMixer = rf2.useApi("mspMixer")
    for i = 1, 4 do
        if mixerOverride then
            mspMixer.enableOverride(i)
        else
            mspMixer.disableOverride(i)
        end
    end
end

labels[#labels + 1] = { t = "十字盤",               x = x,          y = incY(lineSpacing) }
fields[#fields + 1] = { t = "幾何校正",           x = x + indent, y = incY(lineSpacing), sp = x + sp, data = mixerConfig.swash_geo_correction,  id = "mixerCollectiveGeoCorrection" }
fields[#fields + 1] = { t = "總螺距限制",        x = x + indent, y = incY(lineSpacing), sp = x + sp, data = mixerConfig.swash_pitch_limit,     id = "mixerTotalPitchLimit" }
fields[#fields + 1] = { t = "相位角度",              x = x + indent, y = incY(lineSpacing), sp = x + sp, data = mixerConfig.swash_phase,           id = "mixerSwashPhase" }
if rf2.apiVersion >= 12.08 then
    fields[#fields + 1] = { t = "正集體螺距傾斜校正",   x = x + indent, y = incY(lineSpacing), sp = x + sp, data = mixerConfig.collective_tilt_correction_pos }
    fields[#fields + 1] = { t = "負集體螺距傾斜校正",   x = x + indent, y = incY(lineSpacing), sp = x + sp, data = mixerConfig.collective_tilt_correction_neg }
end
fields[#fields + 1] = { t = "TTA 預補償",              x = x + indent, y = incY(lineSpacing), sp = x + sp, data = mixerConfig.swash_tta_precomp }

incY(lineSpacing * 0.25)
labels[#labels + 1] = { t = "十字盤微調",    x = x,          y = incY(lineSpacing) }
fields[#fields + 1] = { t = "橫滾微調[%]",                x = x + indent, y = incY(lineSpacing), sp = x + sp, data = mixerConfig.swash_trim_roll,       id = "mixerSwashRollTrim" }
fields[#fields + 1] = { t = "俯仰微調[%]",               x = x + indent, y = incY(lineSpacing), sp = x + sp, data = mixerConfig.swash_trim_pitch,      id = "mixerSwashPitchTrim" }
fields[#fields + 1] = { t = "集體微調[%]",               x = x + indent, y = incY(lineSpacing), sp = x + sp, data = mixerConfig.swash_trim_collective, id = "mixerSwashCollectiveTrim" }

incY(lineSpacing * 0.25)
labels[#labels + 1] = { t = "尾馬達",           x = x,          y = incY(lineSpacing) }
fields[#fields + 1] = { t = "怠速油門[%]",        x = x + indent, y = incY(lineSpacing), sp = x + sp, data = mixerConfig.tail_motor_idle,       id = "mixerTailMotorIdle" }
fields[#fields + 1] = { t = "中心點微調",              x = x + indent, y = incY(lineSpacing), sp = x + sp, data = mixerConfig.tail_center_trim,      id = "mixerTailRotorCenterTrim" }

if rf2.apiVersion >= 12.08 then
    incY(lineSpacing * 0.5)

    fields[#fields + 1] = { t = "[Enable Mixer Passthrough]", x = x,    y = incY(lineSpacing), preEdit = onClickOverride }
end

local function receivedMixerConfig(page, _)
    rf2.lcdNeedsInvalidate = true
    page.isReady = true
end

return {
    read = function(self)
        rf2.useApi("mspMixer").read(receivedMixerConfig, self, mixerConfig)
    end,
    write = function(self)
        rf2.useApi("mspMixer").write(mixerConfig)
        rf2.settingsSaved()
    end,
    eepromWrite = true,
    reboot      = false,
    title       = "混控",
    labels      = labels,
    fields      = fields
}
