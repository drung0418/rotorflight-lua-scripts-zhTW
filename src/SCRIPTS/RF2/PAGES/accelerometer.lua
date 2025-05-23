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
local mspAccTrim = "mspAccTrim"
local data = rf2.useApi(mspAccTrim).getDefaults()

labels[#labels + 1] = { t = "速度計微調", x = x,          y = incY(lineSpacing) }
fields[#fields + 1] = { t = "橫滾",               x = x + indent, y = incY(lineSpacing), sp = x + sp, data = data.roll_trim }
fields[#fields + 1] = { t = "俯仰",              x = x + indent, y = incY(lineSpacing), sp = x + sp, data = data.pitch_trim }

local function receivedData(page, data)
    rf2.lcdNeedsInvalidate = true
    page.isReady = true
end

return {
    read = function(self)
        rf2.useApi(mspAccTrim).read(receivedData, self, data)
    end,
    write = function(self)
        rf2.useApi(mspAccTrim).write(data)
        rf2.settingsSaved()
    end,
    eepromWrite = true,
    reboot      = false,
    title       = "加速度計",
    labels      = labels,
    fields      = fields
}
