local template = assert(rf2.loadScript(rf2.radio.template))()
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
local profileSwitcher = assert(rf2.loadScript("PAGES/helpers/profileSwitcher.lua"))()

fields[#fields + 1] = { t = "目前 PID 設定檔",         x = x,          y = inc.y(lineSpacing), sp = x + sp * 1.17, data = { value = nil, min = 0, max = 5, table = { [0] = "1", "2", "3", "4", "5", "6" } }, preEdit = profileSwitcher.startPidEditing, postEdit = profileSwitcher.endPidEditing }

inc.y(lineSpacing * 0.25)
fields[#fields + 1] = { t = "I-term 釋放類型",         x = x,          y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 2, vals = { 17 }, table = { [0] = "OFF", "RP", "RPY" } }
fields[#fields + 1] = { t = "橫滾截止點",              x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 1, max = 100, vals = { 18 } }
fields[#fields + 1] = { t = "俯仰截止點",              x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 1, max = 100, vals = { 19 } }
fields[#fields + 1] = { t = "航向截止點",              x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 1, max = 100, vals = { 20 } }
-- TODO? toggle 'I-term limits', off = 1000

inc.y(lineSpacing * 0.25)
labels[#labels + 1] = { t = "主旋翼",                  x = x,          y = inc.y(lineSpacing) }
fields[#fields + 1] = { t = "集體螺距俯仰增益",        x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 250, vals = { 28 } }
labels[#labels + 1] = { t = "交叉耦合",                x = x + indent, y = inc.y(lineSpacing), bold = false }
fields[#fields + 1] = { t = "交叉耦合增益",            x = x + indent*2, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 250, vals = { 34 } }
fields[#fields + 1] = { t = "交叉耦合速率[%]",         x = x + indent*2, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 200, vals = { 35 } }
fields[#fields + 1] = { t = "交叉耦合截止頻率",        x = x + indent*2, y = inc.y(lineSpacing), sp = x + sp, min = 1, max = 250, vals = { 36 } }

inc.y(lineSpacing * 0.25)
labels[#labels + 1] = { t = "航向",                    x = x,          y = inc.y(lineSpacing) }
fields[#fields + 1] = { t = "順時針煞車增益",          x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 25, max = 250, vals = { 21 } }
fields[#fields + 1] = { t = "逆時針煞車增益",          x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 25, max = 250, vals = { 22 } }
fields[#fields + 1] = { t = "航向預補償截止頻率",      x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 250, vals = { 23 } }
fields[#fields + 1] = { t = "循環前饋增益",            x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 250, vals = { 24 } }
fields[#fields + 1] = { t = "集體前饋增益",            x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 250, vals = { 25 } }
fields[#fields + 1] = { t = "集體瞬時前饋增益",        x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 250, vals = { 26 } }
fields[#fields + 1] = { t = "集體瞬時前饋衰減時間",    x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 250, vals = { 27 } }

inc.y(lineSpacing * 0.25)
labels[#labels + 1] = { t = "教練模式",                x = x,          y = inc.y(lineSpacing) }
fields[#fields + 1] = { t = "回正增益",                x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 25, max = 255, vals = { 32 } }
fields[#fields + 1] = { t = "最大角度",                x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 10, max = 80, vals = { 33 } }
labels[#labels + 1] = { t = "自穩模式",                x = x,          y = inc.y(lineSpacing) }
fields[#fields + 1] = { t = "回正增益",                x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 200, vals = { 29 } }
fields[#fields + 1] = { t = "最大角度",                x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 10, max = 90, vals = { 30 } }
labels[#labels + 1] = { t = "半自穩模式",              x = x,          y = inc.y(lineSpacing) }
fields[#fields + 1] = { t = "回正增益",                x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 200, vals = { 31 } }

inc.y(lineSpacing * 0.25)
fields[#fields + 1] = { t = "Piro 補償",               x = x,          y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 1, vals = { 7 }, table = { [0] = "OFF", "ON" } }
labels[#labels + 1] = { t = "Ground 誤差衰減",         x = x,          y = inc.y(lineSpacing) }
fields[#fields + 1] = { t = "時間",                    x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 250, vals = { 2 }, scale = 10 }
labels[#labels + 1] = { t = "循環誤差衰減",            x = x,          y = inc.y(lineSpacing) }
fields[#fields + 1] = { t = "時間",                    x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 250, vals = { 3 }, scale = 10 }
fields[#fields + 1] = { t = "限制",                    x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 250, vals = { 5 } }
labels[#labels + 1] = { t = "偏航誤差衰減",            x = x,          y = inc.y(lineSpacing) }
fields[#fields + 1] = { t = "時間",                    x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 250, vals = { 4 }, scale = 10 }
fields[#fields + 1] = { t = "限制",                    x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 250, vals = { 6 } }
labels[#labels + 1] = { t = "誤差限制",                x = x,          y = inc.y(lineSpacing) }
fields[#fields + 1] = { t = "橫滾",                    x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 180, vals = { 8 } }
fields[#fields + 1] = { t = "俯仰",                    x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 180, vals = { 9 } }
fields[#fields + 1] = { t = "航向",                    x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 180, vals = { 10 } }
labels[#labels + 1] = { t = "HSI 偏移限制",            x = x,          y = inc.y(lineSpacing) }
fields[#fields + 1] = { t = "橫滾",                    x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 180, vals = { 37 } }
fields[#fields + 1] = { t = "俯仰",                    x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 180, vals = { 38 } }

inc.y(lineSpacing * 0.25)
labels[#labels + 1] = { t = "PID 控制器頻寬",          x = x,          y = inc.y(lineSpacing) }
fields[#fields + 1] = { t = "橫滾頻寬[Hz]",            x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 250, vals = { 11 } }
fields[#fields + 1] = { t = "俯仰頻寬[Hz]",            x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 250, vals = { 12 } }
fields[#fields + 1] = { t = "航向頻寬[Hz]",            x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 250, vals = { 13 } }
fields[#fields + 1] = { t = "橫滾 D 截止[Hz]",         x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 250, vals = { 14 } }
fields[#fields + 1] = { t = "俯仰 D 截止[Hz]",         x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 250, vals = { 15 } }
fields[#fields + 1] = { t = "航向 D 截止[Hz]",         x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 250, vals = { 16 } }
fields[#fields + 1] = { t = "橫滾 B 截止[Hz]",         x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 250, vals = { 39 } }
fields[#fields + 1] = { t = "俯仰 B 截止[Hz]",         x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 250, vals = { 40 } }
fields[#fields + 1] = { t = "航向 B 截止[Hz]",         x = x + indent, y = inc.y(lineSpacing), sp = x + sp, min = 0, max = 250, vals = { 41 } }

return {
    read        = 94, -- MSP_PID_PROFILE
    write       = 95, -- MSP_SET_PID_PROFILE
    title       = "飛行參數 - 其他",
    reboot      = false,
    eepromWrite = true,
    minBytes    = 41,
    labels      = labels,
    fields      = fields,
    --simulatorResponse = { 3, 25, 250, 0, 12, 0, 1, 30, 30, 45, 50, 50, 100, 15, 15, 20, 2, 10, 10, 15, 100, 100, 5, 0, 30, 0, 25, 0, 40, 55, 40, 75, 20, 25, 0, 15, 45, 45, 15, 15, 20 },
    profileSwitcher = profileSwitcher,

    postLoad = function(self)
        self.profileSwitcher.getStatus(self)
    end,

    timer = function(self)
        self.profileSwitcher.checkStatus(self)
    end,
}
