local mspApiVersion = rf2.useApi("mspApiVersion")
local returnTable = { f = nil, t = "" }
local apiVersion
local lastRunTS

local function init()
    if getRSSI() == 0 and not rf2.runningInSimulator then
        returnTable.t = "等待連接"
        return false
    end

    if not apiVersion and (not lastRunTS or lastRunTS + 2 < rf2.clock()) then
        returnTable.t = "Waiting for API version"
        mspApiVersion.getApiVersion(function(_, version) apiVersion = version end)
        lastRunTS = rf2.clock()
    end

    rf2.mspQueue:processQueue()

    if rf2.mspQueue:isProcessed() and apiVersion then
        local apiVersionAsString = string.format("%.2f", apiVersion)
        if apiVersion < 12.06 then
            returnTable.t = "此版Lua腳本\n無法支援\n選定的模型\nAPI版本"..apiVersionAsString.."."
        else
            -- received correct API version, proceed
            rf2.apiVersion = apiVersion
            collectgarbage()
            return true
        end
    end

    return false
end

returnTable.f = init

return returnTable
