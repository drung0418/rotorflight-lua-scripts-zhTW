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
local profileSwitcher = assert(rf2.loadScript("PAGES/helpers/profileSwitcher.lua"))()
local governorProfile = rf2.useApi("mspGovernorProfile").getDefaults()

fields[#fields + 1] = { t = "目前 PID 設定檔", x = x, y = incY(lineSpacing), sp = x + sp * 1.17, data = { value = nil, min = 0, max = 5, table = { [0] = "1", "2", "3", "4", "5", "6" } }, preEdit = profileSwitcher.startPidEditing, postEdit = profileSwitcher.endPidEditing }

incY(lineSpacing * 0.25)
fields[#fields + 1] = { t = "最高轉速[rpm]",      x = x, y = incY(lineSpacing), sp = x + sp, data = governorProfile.headspeed,            id = "govHeadspeed"}
fields[#fields + 1] = { t = "最大油門[%]",        x = x, y = incY(lineSpacing), sp = x + sp, data = governorProfile.max_throttle,         id = "govMaxThrottle" }
if rf2.apiVersion >= 12.07 then
    fields[#fields + 1] = { t = "最小油門[%]",    x = x, y = incY(lineSpacing), sp = x + sp, data = governorProfile.min_throttle,         id = "govMinThrottle" }
end
fields[#fields + 1] = { t = "主 PID 增益",     x = x, y = incY(lineSpacing), sp = x + sp, data = governorProfile.gain,                 id = "govMasterGain" }
fields[#fields + 1] = { t = "P-增益",              x = x, y = incY(lineSpacing), sp = x + sp, data = governorProfile.p_gain,               id = "govPGain" }
fields[#fields + 1] = { t = "I-增益",              x = x, y = incY(lineSpacing), sp = x + sp, data = governorProfile.i_gain,               id = "govIGain" }
fields[#fields + 1] = { t = "D-增益",              x = x, y = incY(lineSpacing), sp = x + sp, data = governorProfile.d_gain,               id = "govDGain" }
fields[#fields + 1] = { t = "FF-增益",             x = x, y = incY(lineSpacing), sp = x + sp, data = governorProfile.f_gain,               id = "govFGain" }
fields[#fields + 1] = { t = "航向預補償",        x = x, y = incY(lineSpacing), sp = x + sp, data = governorProfile.yaw_ff_weight,        id = "govYawPrecomp" }
fields[#fields + 1] = { t = "循環螺距預補償",     x = x, y = incY(lineSpacing), sp = x + sp, data = governorProfile.cyclic_ff_weight,     id = "govCyclicPrecomp" }
fields[#fields + 1] = { t = "集體螺距預補償",       x = x, y = incY(lineSpacing), sp = x + sp, data = governorProfile.collective_ff_weight, id = "govCollectivePrecomp" }
fields[#fields + 1] = { t = "TTA 增益",            x = x, y = incY(lineSpacing), sp = x + sp, data = governorProfile.tta_gain,             id = "govTTAGain" }
fields[#fields + 1] = { t = "TTA 增益上限",           x = x, y = incY(lineSpacing), sp = x + sp, data = governorProfile.tta_limit,            id = "govTTALimit" }

local function receivedGovernorProfile(page, _)
    rf2.lcdNeedsInvalidate = true
    page.isReady = true
end

return {
    read = function(self)
        rf2.useApi("mspGovernorProfile").read(receivedGovernorProfile, self, governorProfile)
    end,
    write = function(self)
        rf2.useApi("mspGovernorProfile").write(governorProfile)
        rf2.settingsSaved()
    end,
    title       = "飛行參數 - 定速器",
    reboot      = false,
    eepromWrite = true,
    labels      = labels,
    fields      = fields,
    profileSwitcher = profileSwitcher,

    timer = function(self)
        self.profileSwitcher.checkStatus(self)
    end,
}
