return {
    labels = { "", "", "橫滾", "俯仰", "航向", "集體", (LCD_W < 320) and "中心" or "中心", "靈敏度", "最大", "速率", "", "Expo" },
    fields = {
        { min = 1, max = 200, scale = 0.1 },
        { min = 1, max = 200, scale = 0.1 },
        { min = 1, max = 200, scale = 0.1 },
        { min = 0, max = 100, scale = 4 },
        { min = 0, max = 200, scale = 0.1 },
        { min = 0, max = 200, scale = 0.1 },
        { min = 0, max = 200, scale = 0.1 },
        { min = 0, max = 100, scale = 4 },
        { min = 0, max = 100, scale = 100 },
        { min = 0, max = 100, scale = 100 },
        { min = 0, max = 100, scale = 100 },
        { min = 0, max = 100, scale = 100 }
    },
    defaults = { 360, 360, 360, 12, 360, 360, 360, 12, 0, 0, 0, 0 }
}
