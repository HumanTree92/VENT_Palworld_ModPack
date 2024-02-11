---
--- DekDirectoryScanner
--- Author: dekitarpg@gmail.com
--- Reason: This "mod" provides an all important helper function to allow
--- other mods (.pak file logic mods) to scan local directories for files.
---

--- Helper function to check if is windows os
local function isWindows()
    -- Check the directory separator character; backslash for Windows, forward slash for others
    return package.config:sub(1,1) == '\\'
end

-- Scan directory at {path} for all files
local function ScanDirectory(path)
    local paths = {} -- Table to collect paths
    local command
    if isWindows() then
        command = string.format('dir "%s" /b', path)
    else
        command = string.format('ls -1 "%s"', path)
    end
    local p = io.popen(command)
    for file in p:lines() do
        table.insert(paths, file) -- Collect each file path
    end
    p:close()
    return paths -- Return the array of paths
end

-- "For each" like function that operates on each path
local function ForEachFileInDir(path, callback)
    local files = ScanDirectory(path) -- Get the array of paths
    for _, file in ipairs(files) do
        callback(file) -- Call the callback for each path
    end
end

-- Register the custom event to scan for config files
RegisterCustomEvent("DekScanDirectory", function(ParamContext, ScanPathParam, OutArrayParam)
    -- Ensure path is of type FString
    -- Ensure OutArrayParam is of type TArray
    local ScanPath = ScanPathParam:get()
    local OutArray = OutArrayParam:get()
    if ScanPath:type() ~= "FString" then error(string.format("DekScanDirectory Param #1 (ScanPath) must be FString but was %s", ScanPath:type())) end
    if OutArray:type() ~= "TArray" then error(string.format("DekScanDirectory OutParam #1 (OutArrayParam) must be TArray but was %s", OutArray:type())) end
    local ScannedFiles = ScanDirectory(ScanPath:ToString());
    --- update OutArrayParam to list the scanned file paths
    OutArrayParam:get():ForEach(function(i, v)
        if ScannedFiles[i] then v:set(ScannedFiles[i]) end
    end)
end)

