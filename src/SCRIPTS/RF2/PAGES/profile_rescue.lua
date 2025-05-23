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
local rescueProfile = rf2.useApi("mspRescueProfile").getDefaults()

fields[#fields + 1] = { t = "目前 PID 設定檔", x = x,          y = incY(lineSpacing), sp = x + sp * 1.17, data = { value = nil, min = 0, max = 5, table = { [0] = "1", "2", "3", "4", "5", "6" } }, preEdit = profileSwitcher.startPidEditing, postEdit = profileSwitcher.endPidEditing }

incY(lineSpacing * 0.25)
--fields[#fields + 1] = { t = "啟用救援",     x = x,          y = incY(lineSpacing), sp = x + sp, min = 0, max = 2,     vals = { 1 }, table = { [0] = "Off", "On", "Alt hold" } }
fields[#fields + 1] = { t = "啟用救援",       x = x,          y = incY(lineSpacing), sp = x + sp, min = 0, data = rescueProfile.mode }

incY(lineSpacing * 0.25)
labels[#labels + 1] = { t = "階段 1: 拉升",    x = x,          y = incY(lineSpacing) }
fields[#fields + 1] = { t = "拉升螺距[%]",  x = x + indent, y = incY(lineSpacing), sp = x + sp, data = rescueProfile.pull_up_collective,  id = "profilesRescuePullupCollective" }
fields[#fields + 1] = { t = "拉升時間[s]",        x = x + indent, y = incY(lineSpacing), sp = x + sp, data = rescueProfile.pull_up_time,        id = "profilesRescuePullupTime" }
fields[#fields + 1] = { t = "翻正至直立",     x = x + indent, y = incY(lineSpacing), sp = x + sp, data = rescueProfile.flip_mode,           id = "profilesRescueFlipMode" }
fields[#fields + 1] = { t = "翻正失敗時間[s]",      x = x + indent, y = incY(lineSpacing), sp = x + sp, data = rescueProfile.flip_time,           id = "profilesRescueFlipTime" }
fields[#fields + 1] = { t = "翻正增益",           x = x + indent, y = incY(lineSpacing), sp = x + sp, data = rescueProfile.flip_gain,           id = "profilesRescueFlipGain" }

incY(lineSpacing * 0.25)
labels[#labels + 1] = { t = "階段 2: 爬升",      x = x,          y = incY(lineSpacing) }
fields[#fields + 1] = { t = "爬升螺距[%]",    x = x + indent, y = incY(lineSpacing), sp = x + sp, data = rescueProfile.climb_collective,    id = "profilesRescueClimbCollective" }
fields[#fields + 1] = { t = "爬升時間[s]",          x = x + indent, y = incY(lineSpacing), sp = x + sp, data = rescueProfile.climb_time,          id = "profilesRescueClimbTime" }

incY(lineSpacing * 0.25)
labels[#labels + 1] = { t = "階段 3: 懸停",      x = x,          y = incY(lineSpacing) }
fields[#fields + 1] = { t = "懸停螺距[%]",    x = x + indent, y = incY(lineSpacing), sp = x + sp, data = rescueProfile.hover_collective,    id = "profilesRescueHoverCollective" }

incY(lineSpacing * 0.25)
fields[#fields + 1] = { t = "退出時間[s]",           x = x,          y = incY(lineSpacing), sp = x + sp, data = rescueProfile.exit_time,           id = "profilesRescueExitTime" }
fields[#fields + 1] = { t = "水平回正增益",       x = x,          y = incY(lineSpacing), sp = x + sp, data = rescueProfile.level_gain,          id = "profilesRescueLevelGain" }
fields[#fields + 1] = { t = "最大回正速率[°/s]",   x = x,          y = incY(lineSpacing), sp = x + sp, data = rescueProfile.max_setpoint_rate,   id = "profilesRescueMaxRate" }
fields[#fields + 1] = { t = "最大回正加速度[°/s]",  x = x,          y = incY(lineSpacing), sp = x + sp, data = rescueProfile.max_setpoint_accel,  id = "profilesRescueMaxAccel" }
--[[
labels[#labels + 1] = { t = "高度維持",       x = x,          y = incY(lineSpacing) }
fields[#fields + 1] = { t = "懸停高度[m]",      x = x + indent, y = incY(lineSpacing), sp = x + sp, data = rescueProfile.hover_altitude,      id = "profilesRescueHoverAltitude" }
fields[#fields + 1] = { t = "P-增益",              x = x + indent, y = incY(lineSpacing), sp = x + sp, data = rescueProfile.alt_p_gain,          id = "profilesRescueAltitudePGain" }
fields[#fields + 1] = { t = "I-增益",              x = x + indent, y = incY(lineSpacing), sp = x + sp, data = rescueProfile.alt_i_gain,          id = "profilesRescueAltitudeIGain" }
fields[#fields + 1] = { t = "D-增益",              x = x + indent, y = incY(lineSpacing), sp = x + sp, data = rescueProfile.alt_d_gain,          id = "profilesRescueAltitudeDGain" }
fields[#fields + 1] = { t = "最大集體螺距[%]",      x = x + indent, y = incY(lineSpacing), sp = x + sp, data = rescueProfile.max_collective,      id = "profilesRescueMaxCollective" }
--]]

local function receivedRescueProfile(page, _)
    rf2.lcdNeedsInvalidate = true
    page.isReady = true
end

return {
    read = function(self)
        rf2.useApi("mspRescueProfile").read(receivedRescueProfile, self, rescueProfile)
    end,
    write = function(self)
        rf2.useApi("mspRescueProfile").write(rescueProfile)
        rf2.settingsSaved()
    end,
    title       = "飛行參數 - 救機",
    reboot      = false,
    eepromWrite = true,
    labels      = labels,
    fields      = fields,
    profileSwitcher = profileSwitcher,

    timer = function(self)
        self.profileSwitcher.checkStatus(self)
    end
}
