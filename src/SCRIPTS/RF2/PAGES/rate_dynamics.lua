local template = assert(rf2.loadScript(rf2.radio.template))()
local mspSetProfile = assert(rf2.loadScript("MSP/mspSetProfile.lua"))()
local mspStatus = assert(rf2.loadScript("MSP/mspStatus.lua"))()
local margin = template.margin
local indent = template.indent
local lineSpacing = template.lineSpacing
local tableSpacing = template.tableSpacing
local sp = template.listSpacing.field
template = nil
local yMinLim = rf2.radio.yMinLimit
local x = margin
local y = yMinLim - lineSpacing
local function incY(val) y = y + val return y end
local labels = {}
local fields = {}
local rateSwitcher = assert(rf2.loadScript("PAGES/helpers/rateSwitcher.lua"))()
local rcTuning = rf2.useApi("mspRcTuning").getDefaults()
collectgarbage()
local editing = false
local profileAdjustmentTS = nil

local tableStartY = yMinLim - lineSpacing
y = tableStartY
labels = {}
fields = {}

fields[#fields + 1] = { t = "Current rate profile", x = x, y = incY(lineSpacing), sp = x + sp * 1.17, data = { value = nil, min = 0, max = 5, table = { [0] = "1", "2", "3", "4", "5", "6" } }, preEdit = rateSwitcher.startPidEditing, postEdit = rateSwitcher.endPidEditing }
incY(lineSpacing * 0.5)

local responseTime = "回應時間[ms]"
local maxAcceleration = "最大加速度"
local setpointBoostGain = "設定點增壓增益"
local setpointBoostCutoff = "設定點增壓截止"

labels[#labels + 1] = { t = "橫滾動態",       x = x,          y = incY(lineSpacing) }
fields[#fields + 1] = { t = responseTime,          x = x + indent, y = incY(lineSpacing), sp = x + sp, data = rcTuning.roll_response_time }
fields[#fields + 1] = { t = maxAcceleration,       x = x + indent, y = incY(lineSpacing), sp = x + sp, data = rcTuning.roll_accel_limit }
if rf2.apiVersion >= 12.08 then
    fields[#fields + 1] = { t = setpointBoostGain,     x = x + indent, y = incY(lineSpacing), sp = x + sp, data = rcTuning.roll_setpoint_boost_gain }
    fields[#fields + 1] = { t = setpointBoostCutoff,   x = x + indent, y = incY(lineSpacing), sp = x + sp, data = rcTuning.roll_setpoint_boost_cutoff }
end

labels[#labels + 1] = { t = "俯仰動態",      x = x,          y = incY(lineSpacing) }
fields[#fields + 1] = { t = responseTime,          x = x + indent, y = incY(lineSpacing), sp = x + sp, data = rcTuning.pitch_response_time }
fields[#fields + 1] = { t = maxAcceleration,       x = x + indent, y = incY(lineSpacing), sp = x + sp, data = rcTuning.pitch_accel_limit }
if rf2.apiVersion >= 12.08 then
    fields[#fields + 1] = { t = setpointBoostGain,     x = x + indent, y = incY(lineSpacing), sp = x + sp, data = rcTuning.pitch_setpoint_boost_gain }
    fields[#fields + 1] = { t = setpointBoostCutoff,   x = x + indent, y = incY(lineSpacing), sp = x + sp, data = rcTuning.pitch_setpoint_boost_cutoff }
end

labels[#labels + 1] = { t = "航向動態",        x = x,          y = incY(lineSpacing) }
fields[#fields + 1] = { t = responseTime,          x = x + indent, y = incY(lineSpacing), sp = x + sp, data = rcTuning.yaw_response_time }
fields[#fields + 1] = { t = maxAcceleration,       x = x + indent, y = incY(lineSpacing), sp = x + sp, data = rcTuning.yaw_accel_limit }
if rf2.apiVersion >= 12.08 then
    fields[#fields + 1] = { t = setpointBoostGain,     x = x + indent, y = incY(lineSpacing), sp = x + sp, data = rcTuning.yaw_setpoint_boost_gain }
    fields[#fields + 1] = { t = setpointBoostCutoff,   x = x + indent, y = incY(lineSpacing), sp = x + sp, data = rcTuning.yaw_setpoint_boost_cutoff }
end

labels[#labels + 1] = { t = "集體螺距動態", x = x,          y = incY(lineSpacing) }
fields[#fields + 1] = { t = responseTime,          x = x + indent, y = incY(lineSpacing), sp = x + sp, data = rcTuning.collective_response_time }
fields[#fields + 1] = { t = maxAcceleration,       x = x + indent, y = incY(lineSpacing), sp = x + sp, data = rcTuning.collective_accel_limit }
if rf2.apiVersion >= 12.08 then
    fields[#fields + 1] = { t = setpointBoostGain,     x = x + indent, y = incY(lineSpacing), sp = x + sp, data = rcTuning.collective_setpoint_boost_gain }
    fields[#fields + 1] = { t = setpointBoostCutoff,   x = x + indent, y = incY(lineSpacing), sp = x + sp, data = rcTuning.collective_setpoint_boost_cutoff }
end

if rf2.apiVersion >= 12.08 then
    incY(lineSpacing * 0.5)
    labels[#labels + 1] = { t = "動態",             x = x,          y = incY(lineSpacing) }
    fields[#fields + 1] = { t = "增益上限",        x = x + indent, y = incY(lineSpacing), sp = x + sp, data = rcTuning.yaw_dynamic_ceiling_gain }
    fields[#fields + 1] = { t = "死區增益",       x = x + indent, y = incY(lineSpacing), sp = x + sp, data = rcTuning.yaw_dynamic_deadband_gain }
    fields[#fields + 1] = { t = "死區濾波器",     x = x + indent, y = incY(lineSpacing), sp = x + sp, data = rcTuning.yaw_dynamic_deadband_filter }
end

local function receivedRcTuning(page)
    rf2.lcdNeedsInvalidate = true
    page.isReady = true
end

return {
    read = function(self)
        rf2.useApi("mspRcTuning").read(receivedRcTuning, self, rcTuning)
    end,
    write = function(self)
        rf2.useApi("mspRcTuning").write(rcTuning)
        rf2.settingsSaved()
    end,
    title       = "速率 - 動態",
    reboot      = false,
    eepromWrite = true,
    labels      = labels,
    fields      = fields,
    rateSwitcher = rateSwitcher,

    timer = function(self)
        self.rateSwitcher.checkStatus(self)
    end
}
