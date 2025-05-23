local template = assert(rf2.loadScript(rf2.radio.template))()
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
local profileSwitcher = assert(rf2.loadScript("PAGES/helpers/profileSwitcher.lua"))()
local pidProfile = rf2.useApi("mspPidProfile").getDefaults()
collectgarbage()

fields[#fields + 1] = { t = "目前 PID 設定檔",     x = x,          y = incY(lineSpacing), sp = x + sp * 1.17, data = { value = nil, min = 0, max = 5, table = { [0] = "1", "2", "3", "4", "5", "6" } }, preEdit = profileSwitcher.startPidEditing, postEdit = profileSwitcher.endPidEditing }

incY(lineSpacing * 0.25)
labels[#labels + 1] = { t = "主旋翼",              x = x,            y = incY(lineSpacing) }
fields[#fields + 1] = { t = "集體螺距俯仰增益",      x = x + indent,   y = incY(lineSpacing), sp = x + sp, data = pidProfile.pitch_collective_ff_gain }
labels[#labels + 1] = { t = "交叉耦合",          x = x + indent,   y = incY(lineSpacing), bold = false }
fields[#fields + 1] = { t = "增益",                    x = x + indent*2, y = incY(lineSpacing), sp = x + sp, data = pidProfile.cyclic_cross_coupling_gain }
fields[#fields + 1] = { t = "比率",                   x = x + indent*2, y = incY(lineSpacing), sp = x + sp, data = pidProfile.cyclic_cross_coupling_ratio }
fields[#fields + 1] = { t = "截止",                  x = x + indent*2, y = incY(lineSpacing), sp = x + sp, data = pidProfile.cyclic_cross_coupling_cutoff }

incY(lineSpacing * 0.25)
labels[#labels + 1] = { t = "尾旋翼",              x = x,          y = incY(lineSpacing) }
fields[#fields + 1] = { t = "順時針剎車增益",            x = x + indent, y = incY(lineSpacing), sp = x + sp, data = pidProfile.yaw_cw_stop_gain }
fields[#fields + 1] = { t = "逆時針剎車增益",           x = x + indent, y = incY(lineSpacing), sp = x + sp, data = pidProfile.yaw_ccw_stop_gain }
fields[#fields + 1] = { t = "預補償截止",          x = x + indent, y = incY(lineSpacing), sp = x + sp, data = pidProfile.yaw_precomp_cutoff }
fields[#fields + 1] = { t = "循環前饋增益",          x = x + indent, y = incY(lineSpacing), sp = x + sp, data = pidProfile.yaw_cyclic_ff_gain }
fields[#fields + 1] = { t = "集體前饋增益",            x = x + indent, y = incY(lineSpacing), sp = x + sp, data = pidProfile.yaw_collective_ff_gain }
if rf2.apiVersion >= 12.08 then
    fields[#fields + 1] = { t = "慣性預補償增益",        x = x + indent, y = incY(lineSpacing), sp = x + sp, data = pidProfile.yaw_inertia_precomp_gain }
    fields[#fields + 1] = { t = "慣性預補償截止",      x = x + indent, y = incY(lineSpacing), sp = x + sp, data = pidProfile.yaw_inertia_precomp_cutoff }
else
    fields[#fields + 1] = { t = "集體螺距瞬時前饋增益",    x = x + indent, y = incY(lineSpacing), sp = x + sp, data = pidProfile.yaw_collective_dynamic_gain }
    fields[#fields + 1] = { t = "集體螺距瞬時前饋衰減",   x = x + indent, y = incY(lineSpacing), sp = x + sp, data = pidProfile.yaw_collective_dynamic_decay }
end

incY(lineSpacing * 0.25)
labels[#labels + 1] = { t = "教練模式",            x = x,          y = incY(lineSpacing) }
fields[#fields + 1] = { t = "回正增益",           x = x + indent, y = incY(lineSpacing), sp = x + sp, data = pidProfile.trainer_gain }
fields[#fields + 1] = { t = "最大角度",           x = x + indent, y = incY(lineSpacing), sp = x + sp, data = pidProfile.trainer_angle_limit }
labels[#labels + 1] = { t = "自穩模式",              x = x,          y = incY(lineSpacing) }
fields[#fields + 1] = { t = "回正增益",           x = x + indent, y = incY(lineSpacing), sp = x + sp, data = pidProfile.angle_level_strength }
fields[#fields + 1] = { t = "最大角度",           x = x + indent, y = incY(lineSpacing), sp = x + sp, data = pidProfile.angle_level_limit }
labels[#labels + 1] = { t = "半自穩模式",            x = x,          y = incY(lineSpacing) }
fields[#fields + 1] = { t = "回正增益",           x = x + indent, y = incY(lineSpacing), sp = x + sp, data = pidProfile.horizon_level_strength }

local function receivedPidProfile(page, _)
    rf2.lcdNeedsInvalidate = true
    page.isReady = true
end

return {
    read = function(self)
        rf2.useApi("mspPidProfile").read(receivedPidProfile, self, pidProfile)
    end,
    write = function(self)
        rf2.useApi("mspPidProfile").write(pidProfile)
        rf2.settingsSaved()
    end,
    title       = "飛行參數 - 其他",
    reboot      = false,
    eepromWrite = true,
    labels      = labels,
    fields      = fields,
    profileSwitcher = profileSwitcher,

    timer = function(self)
        self.profileSwitcher.checkStatus(self)
    end,
}
