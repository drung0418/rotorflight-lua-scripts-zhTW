local template = assert(rf2.loadScript(rf2.radio.template))()
local mspGovernorConfig = assert(rf2.loadScript("MSP/mspGovernorConfig.lua"))()
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
local governorConfig = {}

x = margin
y = yMinLim - tableSpacing.header

fields[1] = { t = "模式",                 x = x, y = inc.y(lineSpacing), sp = x + sp, id = "govMode" }
fields[2] = { t = "接管油門[%]",          x = x, y = inc.y(lineSpacing), sp = x + sp, id = "govHandoverThrottle" }
fields[3] = { t = "一階緩啟動時間",       x = x, y = inc.y(lineSpacing), sp = x + sp, id = "govStartupTime" }
fields[4] = { t = "二階緩啟動時間",       x = x, y = inc.y(lineSpacing), sp = x + sp, id = "govSpoolupTime" }
fields[5] = { t = "追蹤時間",             x = x, y = inc.y(lineSpacing), sp = x + sp, id = "govTrackingTime" }
fields[6] = { t = "重啟時間",             x = x, y = inc.y(lineSpacing), sp = x + sp, id = "govRecoveryTime" }
fields[7] = { t = "熄火重啟保護時間",     x = x, y = inc.y(lineSpacing), sp = x + sp, id = "govAutoBailoutTime" }
fields[8] = { t = "熄火重啟超時",         x = x, y = inc.y(lineSpacing), sp = x + sp, id = "govAutoTimeout" }
fields[9] = { t = "熄火降落最小進入時間", x = x, y = inc.y(lineSpacing), sp = x + sp, id = "govAutoMinEntryTime" }
fields[10] = { t = "零油門超時",          x = x, y = inc.y(lineSpacing), sp = x + sp, id = "govZeroThrottleTimeout" }
fields[11] = { t = "主旋翼轉速訊號超時",  x = x, y = inc.y(lineSpacing), sp = x + sp, id = "govLostHeadspeedTimeout" }
fields[12] = { t = "主旋翼轉速濾波器截止",x = x, y = inc.y(lineSpacing), sp = x + sp, id = "govHeadspeedFilterHz" }
fields[13] = { t = "電池電壓濾波器截止",  x = x, y = inc.y(lineSpacing), sp = x + sp, id = "govVoltageFilterHz" }
fields[14] = { t = "TTA控制頻寬",         x = x, y = inc.y(lineSpacing), sp = x + sp, id = "govTTAFilterHz" }
fields[15] = { t = "預補償頻寬",          x = x, y = inc.y(lineSpacing), sp = x + sp, id = "govFFFilterHz" }

local function setValues()
    fields[1].data = governorConfig.gov_mode
    fields[2].data = governorConfig.gov_handover_throttle
    fields[3].data = governorConfig.gov_startup_time
    fields[4].data = governorConfig.gov_spoolup_time
    fields[5].data = governorConfig.gov_tracking_time
    fields[6].data = governorConfig.gov_recovery_time
    fields[7].data = governorConfig.gov_autorotation_bailout_time
    fields[8].data = governorConfig.gov_autorotation_timeout
    fields[9].data = governorConfig.gov_autorotation_min_entry_time
    fields[10].data = governorConfig.gov_zero_throttle_timeout
    fields[11].data = governorConfig.gov_lost_headspeed_timeout
    fields[12].data = governorConfig.gov_rpm_filter
    fields[13].data = governorConfig.gov_pwr_filter
    fields[14].data = governorConfig.gov_tta_filter
    fields[15].data = governorConfig.gov_ff_filter
end

local function receivedGovernorConfig(page, config)
    governorConfig = config
    setValues()
    rf2.lcdNeedsInvalidate = true
    page.isReady = true
end

return {
    read = function(self)
        mspGovernorConfig.getGovernorConfig(receivedGovernorConfig, self)
    end,
    write = function(self)
        mspGovernorConfig.setGovernorConfig(governorConfig)
        rf2.settingsSaved()
    end,
    title       = "定速器",
    reboot      = true,
    eepromWrite = true,
    labels      = labels,
    fields      = fields
}
