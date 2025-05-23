local template = assert(rf2.loadScript(rf2.radio.template))()
local mspServos = assert(rf2.loadScript("MSP/mspServos.lua"))()
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
local servoConfigs = {}
local selectedServoIndex = 0
local updateSelectedServoConfiguration = false
local overrideAllServos = false

local  function setValues(servoIndex)
    fields[1].data.value = servoIndex
    fields[2].data = servoConfigs[servoIndex].mid
    fields[3].data = servoConfigs[servoIndex].min
    fields[4].data = servoConfigs[servoIndex].max
    fields[5].data = servoConfigs[servoIndex].scaleNeg
    fields[6].data = servoConfigs[servoIndex].scalePos
    fields[7].data = servoConfigs[servoIndex].rate
    fields[8].data = servoConfigs[servoIndex].speed
end

-- Field event functions

local function onChangeServo(field, page)
    selectedServoIndex = field.data.value
    rf2.lastChangedServo = selectedServoIndex
    setValues(selectedServoIndex)
end

local function onPreEditCenter(field, page)
    mspServos.enableServoOverride(selectedServoIndex)
end

local function onChangeCenter(field, page)
    updateSelectedServoConfiguration = true
end

local function onPostEditCenter(field, page)
    mspServos.disableServoOverride(selectedServoIndex)
end

local function onClickOverride(field, page)
    --rf2.lcdNeedsInvalidate = true
    if not overrideAllServos then
        overrideAllServos = true
        field.t = "[Disable Override]"
    else
        overrideAllServos = false
        field.t = "[Override All Servos]"
    end

    for i = 0, #servoConfigs do
        if overrideAllServos then
            mspServos.enableServoOverride(i)
        else
            mspServos.disableServoOverride(i)
        end
    end
end

fields[1] = { t = "舵機",      x = x,          y = incY(lineSpacing), sp = x + sp, data = { min = 0, max = 7, table = { [0] = "ELEVATOR", "CYCL L", "CYCL R", "TAIL", "5", "6", "7", "8" } }, postEdit = onChangeServo }
fields[2] = { t = "中心點[us]",     x = x + indent, y = incY(lineSpacing), sp = x + sp, id = "servoMid", preEdit = onPreEditCenter, change = onChangeCenter, postEdit = onPostEditCenter }
fields[3] = { t = "最小值[us]",        x = x + indent, y = incY(lineSpacing), sp = x + sp, id = "servoMin" }
fields[4] = { t = "最大值[us]",        x = x + indent, y = incY(lineSpacing), sp = x + sp, id = "servoMax" }
fields[5] = { t = "負縮放",  x = x + indent, y = incY(lineSpacing), sp = x + sp, id = "servoScaleNeg" }
fields[6] = { t = "正縮放",  x = x + indent, y = incY(lineSpacing), sp = x + sp, id = "servoScalePos" }
fields[7] = { t = "頻率[Hz]",       x = x + indent, y = incY(lineSpacing), sp = x + sp, id = "servoRate" }
fields[8] = { t = "速度[ms]",      x = x + indent, y = incY(lineSpacing), sp = x + sp, id = "servoSpeed" }
incY(lineSpacing * 0.5)
fields[9] = { t = "[覆寫所有舵機]", x = x + indent * 2, y = incY(lineSpacing), preEdit = onClickOverride }

local function receivedServoConfigurations(page, configs)
    servoConfigs = configs
    selectedServoIndex = rf2.lastChangedServo or 0
    setValues(selectedServoIndex)
    page.fields[1].data.max = #configs
    rf2.lcdNeedsInvalidate = true
    page.isReady = true
end

return {
    read = function(self)
        mspServos.getServoConfigurations(receivedServoConfigurations, self)
    end,
    write = function(self)
        for servoIndex = 0, #servoConfigs do
            mspServos.setServoConfiguration(servoIndex, servoConfigs[servoIndex])
        end
        rf2.settingsSaved()
    end,
    timer = function(self)
        if updateSelectedServoConfiguration then
            mspServos.setServoConfiguration(selectedServoIndex, servoConfigs[selectedServoIndex])
            updateSelectedServoConfiguration = false
        end
    end,
    title       = "舵機",
    reboot      = false,
    eepromWrite = true,
    labels      = labels,
    fields      = fields
}
