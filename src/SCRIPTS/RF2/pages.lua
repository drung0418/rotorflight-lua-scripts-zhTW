local PageFiles = {}
local settings = assert(rf2.loadScript("PAGES/helpers/settingsHelper.lua"))().loadSettings()

-- Rotorflight pages.
PageFiles[#PageFiles + 1] = { title = "狀態", script = "status.lua" }
PageFiles[#PageFiles + 1] = { title = "速率", script = "rates.lua" }
PageFiles[#PageFiles + 1] = { title = "飛行參數 - PIDs", script = "pids.lua" }
PageFiles[#PageFiles + 1] = { title = "飛行參數 - 其他", script = "profile.lua" }
PageFiles[#PageFiles + 1] = { title = "飛行參數 - 救機", script = "profile_rescue.lua" }
PageFiles[#PageFiles + 1] = { title = "飛行參數 - 定速器", script = "profile_governor.lua" }
PageFiles[#PageFiles + 1] = { title = "舵機", script = "servos.lua" }
PageFiles[#PageFiles + 1] = { title = "混控", script = "mixer.lua" }
PageFiles[#PageFiles + 1] = { title = "濾波器", script = "filters.lua" }
PageFiles[#PageFiles + 1] = { title = "定速器", script = "governor.lua" }
PageFiles[#PageFiles + 1] = { title = "加速度計", script = "accelerometer.lua" }
--PageFiles[#PageFiles + 1] = { title = "複製飛行參數", script = "copy_profiles.lua" }

if rf2.apiVersion >= 12.07 then
    if settings.showModelOnTx == 1 then
        PageFiles[#PageFiles + 1] = { title = "Model on TX", script = "model.lua" }
    end
    if settings.showExperimental == 1 then
        PageFiles[#PageFiles + 1] = { title = "Experimental (danger!)", script = "experimental.lua" }
    end
    if settings.showFlyRotor == 1 then
        PageFiles[#PageFiles + 1] = { title = "ESC - FlyRotor", script = "esc_flyrotor.lua" }
    end
    if settings.showPlatinumV5 == 1 then
        PageFiles[#PageFiles + 1] = { title = "ESC - HW Platinum V5", script = "esc_hwpl5.lua" }
    end
    if settings.showTribunus == 1 then
        PageFiles[#PageFiles + 1] = { title = "ESC - Scorpion Tribunus", script = "esc_scorp.lua" }
    end
    if settings.showYge == 1 then
        PageFiles[#PageFiles + 1] = { title = "ESC - YGE", script = "esc_yge.lua" }
    end

    PageFiles[#PageFiles + 1] = { title = "設定", script = "settings.lua" }
end

return PageFiles
