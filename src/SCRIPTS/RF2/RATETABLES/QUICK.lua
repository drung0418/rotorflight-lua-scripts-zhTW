﻿return {
    labels = { "", "", "橫滾", "俯仰", "航向", "集體", "RC", "速率", "最大", "速率", "", "Expo" },
    fields = {
        { min = 1, max = 255, scale = 100 },
        { min = 1, max = 255, scale = 100 },
        { min = 1, max = 255, scale = 100 },
        { min = 0, max = 255, scale = 100 },
        { min = 0, max = 100, scale = 0.1 },
        { min = 0, max = 100, scale = 0.1 },
        { min = 0, max = 100, scale = 0.1 },
        { min = 0, max = 100, scale = 0.208 },
        { min = 0, max = 100, scale = 100 },
        { min = 0, max = 100, scale = 100 },
        { min = 0, max = 100, scale = 100 },
        { min = 0, max = 100, scale = 100 }
    },
    defaults = { 1.8, 1.8, 1.8, 2.5, 360, 360, 360, 500, 0, 0, 0, 0 }
}
