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
fields[#fields + 1] = { t = "自旋補償",       x = x,          y = incY(lineSpacing), sp = x + sp, data = pidProfile.error_rotation }
fields[#fields + 1] = { t = "I-term 釋放類型",       x = x,          y = incY(lineSpacing), sp = x + sp, data = pidProfile.iterm_relax_type }
fields[#fields + 1] = { t = "橫滾截止點",          x = x + indent, y = incY(lineSpacing), sp = x + sp, data = pidProfile.iterm_relax_cutoff_roll }
fields[#fields + 1] = { t = "俯仰截止點",          x = x + indent, y = incY(lineSpacing), sp = x + sp, data = pidProfile.iterm_relax_cutoff_pitch }
fields[#fields + 1] = { t = "航向截止點",          x = x + indent, y = incY(lineSpacing), sp = x + sp, data = pidProfile.iterm_relax_cutoff_yaw }
labels[#labels + 1] = { t = "地面誤差衰減",      x = x,          y = incY(lineSpacing) }
fields[#fields + 1] = { t = "時間",                    x = x + indent, y = incY(lineSpacing), sp = x + sp, data = pidProfile.error_decay_time_ground }
labels[#labels + 1] = { t = "循環誤差衰減",      x = x,          y = incY(lineSpacing) }
fields[#fields + 1] = { t = "時間",                    x = x + indent, y = incY(lineSpacing), sp = x + sp, data = pidProfile.error_decay_time_cyclic }
fields[#fields + 1] = { t = "限制",                   x = x + indent, y = incY(lineSpacing), sp = x + sp, data = pidProfile.error_decay_limit_cyclic }
labels[#labels + 1] = { t = "航向誤差衰減",         x = x,          y = incY(lineSpacing) }
fields[#fields + 1] = { t = "時間",                    x = x + indent, y = incY(lineSpacing), sp = x + sp, data = pidProfile.error_decay_time_yaw }
fields[#fields + 1] = { t = "限制",                   x = x + indent, y = incY(lineSpacing), sp = x + sp, data = pidProfile.error_decay_limit_yaw }
labels[#labels + 1] = { t = "誤差限制",             x = x,          y = incY(lineSpacing) }
fields[#fields + 1] = { t = "橫滾",                    x = x + indent, y = incY(lineSpacing), sp = x + sp, data = pidProfile.error_limit_roll }
fields[#fields + 1] = { t = "俯仰",                   x = x + indent, y = incY(lineSpacing), sp = x + sp, data = pidProfile.error_limit_pitch }
fields[#fields + 1] = { t = "航向",                     x = x + indent, y = incY(lineSpacing), sp = x + sp, data = pidProfile.error_limit_yaw }
labels[#labels + 1] = { t = "HSI 偏移限制",        x = x,          y = incY(lineSpacing) }
fields[#fields + 1] = { t = "橫滾",                    x = x + indent, y = incY(lineSpacing), sp = x + sp, data = pidProfile.offset_limit_roll }
fields[#fields + 1] = { t = "俯仰",                   x = x + indent, y = incY(lineSpacing), sp = x + sp, data = pidProfile.offset_limit_pitch }

incY(lineSpacing * 0.25)
labels[#labels + 1] = { t = "PID 控制器",          x = x,          y = incY(lineSpacing) }
fields[#fields + 1] = { t = "橫滾頻寬[Hz]",             x = x + indent, y = incY(lineSpacing), sp = x + sp, data = pidProfile.gyro_cutoff_roll }
fields[#fields + 1] = { t = "俯仰頻寬[Hz]",             x = x + indent, y = incY(lineSpacing), sp = x + sp, data = pidProfile.gyro_cutoff_pitch }
fields[#fields + 1] = { t = "航向頻寬[Hz]",             x = x + indent, y = incY(lineSpacing), sp = x + sp, data = pidProfile.gyro_cutoff_yaw }
fields[#fields + 1] = { t = "橫滾 D 截止[Hz]",         x = x + indent, y = incY(lineSpacing), sp = x + sp, data = pidProfile.dterm_cutoff_roll }
fields[#fields + 1] = { t = "俯仰 D 截止[Hz]",         x = x + indent, y = incY(lineSpacing), sp = x + sp, data = pidProfile.dterm_cutoff_pitch }
fields[#fields + 1] = { t = "航向 D 截止[Hz]",         x = x + indent, y = incY(lineSpacing), sp = x + sp, data = pidProfile.dterm_cutoff_yaw }
fields[#fields + 1] = { t = "橫滾 B 截止[Hz]",         x = x + indent, y = incY(lineSpacing), sp = x + sp, data = pidProfile.bterm_cutoff_roll }
fields[#fields + 1] = { t = "俯仰 B 截止[Hz]",         x = x + indent, y = incY(lineSpacing), sp = x + sp, data = pidProfile.bterm_cutoff_pitch }
fields[#fields + 1] = { t = "航向 B 截止[Hz]",         x = x + indent, y = incY(lineSpacing), sp = x + sp, data = pidProfile.bterm_cutoff_yaw }

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
    title       = "飛行參數 - PIDs 進階",
    reboot      = false,
    eepromWrite = true,
    labels      = labels,
    fields      = fields,
    profileSwitcher = profileSwitcher,

    timer = function(self)
        self.profileSwitcher.checkStatus(self)
    end,
}
