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
local governorConfig = rf2.useApi("mspGovernorConfig").getDefaults()

x = margin
y = yMinLim - tableSpacing.header

fields[#fields + 1] = { t = "模式",                 x = x, y = incY(lineSpacing), sp = x + sp, data = governorConfig.gov_mode,                      id = "govMode" }
fields[#fields + 1] = { t = "接管油門[%]",    x = x, y = incY(lineSpacing), sp = x + sp, data = governorConfig.gov_handover_throttle,         id = "govHandoverThrottle" }
fields[#fields + 1] = { t = "緩啟動時間",         x = x, y = incY(lineSpacing), sp = x + sp, data = governorConfig.gov_startup_time,              id = "govStartupTime" }
fields[#fields + 1] = { t = "緩提速時間",         x = x, y = incY(lineSpacing), sp = x + sp, data = governorConfig.gov_spoolup_time,              id = "govSpoolupTime" }
if rf2.apiVersion >= 12.08 then
    fields[#fields + 1] = { t = "緩提速最小油門", x = x, y = incY(lineSpacing), sp = x + sp, data = governorConfig.gov_spoolup_min_throttle,    id = "govSpoolupMinimumThrottle" }
end
fields[#fields + 1] = { t = "追蹤時間",        x = x, y = incY(lineSpacing), sp = x + sp, data = governorConfig.gov_tracking_time,             id = "govTrackingTime" }
fields[#fields + 1] = { t = "重啟時間",        x = x, y = incY(lineSpacing), sp = x + sp, data = governorConfig.gov_recovery_time,             id = "govRecoveryTime" }
fields[#fields + 1] = { t = "熄火降落保護時間",      x = x, y = incY(lineSpacing), sp = x + sp, data = governorConfig.gov_autorotation_bailout_time, id = "govAutoBailoutTime" }
fields[#fields + 1] = { t = "熄火降落逾時",           x = x, y = incY(lineSpacing), sp = x + sp, data = governorConfig.gov_autorotation_timeout,      id = "govAutoTimeout" }
fields[#fields + 1] = { t = "熄火降落最小進入時間",    x = x, y = incY(lineSpacing), sp = x + sp, data = governorConfig.gov_autorotation_min_entry_time, id = "govAutoMinEntryTime" }
fields[#fields + 1] = { t = "零油門逾時",     x = x, y = incY(lineSpacing), sp = x + sp, data = governorConfig.gov_zero_throttle_timeout,     id = "govZeroThrottleTimeout" }
fields[#fields + 1] = { t = "主旋翼轉速訊號逾時",    x = x, y = incY(lineSpacing), sp = x + sp, data = governorConfig.gov_lost_headspeed_timeout,    id = "govLostHeadspeedTimeout" }
fields[#fields + 1] = { t = "主旋翼轉速濾波器截止",     x = x, y = incY(lineSpacing), sp = x + sp, data = governorConfig.gov_rpm_filter,                id = "govHeadspeedFilterHz" }
fields[#fields + 1] = { t = "電池電壓濾波器截止",  x = x, y = incY(lineSpacing), sp = x + sp, data = governorConfig.gov_pwr_filter,                id = "govVoltageFilterHz" }
fields[#fields + 1] = { t = "TTA 控制頻寬",        x = x, y = incY(lineSpacing), sp = x + sp, data = governorConfig.gov_tta_filter,                id = "govTTAFilterHz" }
fields[#fields + 1] = { t = "預補償頻寬",    x = x, y = incY(lineSpacing), sp = x + sp, data = governorConfig.gov_ff_filter,                 id = "govFFFilterHz" }

local function receivedGovernorConfig(page, _)
    rf2.lcdNeedsInvalidate = true
    page.isReady = true
end

return {
    read = function(self)
        rf2.useApi("mspGovernorConfig").read(receivedGovernorConfig, self, governorConfig)
    end,
    write = function(self)
        rf2.useApi("mspGovernorConfig").write(governorConfig)
        rf2.settingsSaved()
    end,
    title       = "定速器",
    reboot      = true,
    eepromWrite = true,
    labels      = labels,
    fields      = fields
}
