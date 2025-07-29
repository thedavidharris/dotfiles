require "string"

-- =============================================================================
-- HAMMERSPOON CONFIGURATION
-- =============================================================================
-- This config provides productivity features that complement Rectangle window manager
-- Key bindings summary:
-- • Cmd+Alt+1/3/4: Quick app launchers (VSCode/Ghostty/Finder)
-- • Cmd+Alt+Tab: Visual app chooser with icons
-- • Cmd+Shift+V: Clipboard history (last 20 items)
-- • Cmd+Alt+T: Smart terminal (context-aware Ghostty)
-- • Cmd+Alt+A: Cycle audio devices
-- • Cmd+Alt+Shift+D: Mouse highlighter
-- • Cmd+Alt+Shift+F: Reveal file in Finder (VSCode aware)
-- • Cmd+Alt+Shift+G: Git status notification
-- • Cmd+Alt+Shift+R: Toggle screen recording
-- • Menu bar: Caffeine (☕/😴) to prevent sleep
-- =============================================================================

-- Hello World test function
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
    hs.alert.show("Hello World!")
end)

-- =============================================================================
-- SPOON MANAGEMENT
-- =============================================================================
-- SpoonInstall manages additional Hammerspoon plugins (Spoons)
hs.loadSpoon("SpoonInstall")
Install=spoon.SpoonInstall

-- ModalMgr: Required for advanced modal keybinding management
Install:andUse("ModalMgr")
hs.loadSpoon("ModalMgr")

-- Additional Spoons for enhanced functionality
if not hspoon_list then
    hspoon_list = {
        "ClipShow",    -- Enhanced clipboard management
        "HCalendar",   -- Calendar integration
        "HSaria2",     -- Download manager integration
        "SpeedMenu"    -- Network speed monitoring
    }
end

-- Load all configured Spoons
for _, v in pairs(hspoon_list) do
    Install:andUse(v)
    hs.loadSpoon(v)
end

-- =============================================================================
-- APPLICATION WATCHERS
-- =============================================================================

-- Finder enhancement: Auto-bring all windows to front when Finder is activated
-- This prevents having to manually bring background Finder windows forward
function applicationWatcher(appName, eventType, appObject)
    if (eventType == hs.application.watcher.activated) then
        if (appName == "Finder") then
            appObject:selectMenuItem({"Window", "Bring All to Front"})
        end
    end
end
appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()

-- =============================================================================
-- NETWORK MONITORING
-- =============================================================================

-- WiFi network change detection with custom home network alerts
-- Shows notifications when joining/leaving your home network
wifiWatcher = nil
homeSSID = "Harris"  -- Change this to your home network name
lastSSID = hs.wifi.currentNetwork()

function ssidChangedCallback()
    newSSID = hs.wifi.currentNetwork()

    if newSSID == homeSSID and lastSSID ~= homeSSID then
        hs.alert.show("Joined Home WiFi")
    elseif newSSID ~= homeSSID and lastSSID == homeSSID then
        hs.alert.show("Disconnected from Home Wifi")
    end

    lastSSID = newSSID
end

wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
wifiWatcher:start()


-- =============================================================================
-- MOUSE UTILITIES
-- =============================================================================

-- Mouse highlighter: Creates a red circle around mouse cursor for presentations
-- Useful for screen sharing or finding cursor on large displays
-- Hotkey: Cmd+Alt+Shift+D
mouseCircle = nil
mouseCircleTimer = nil

function mouseHighlight()
    -- Clean up existing highlight if present
    if mouseCircle then
        mouseCircle:delete()
        if mouseCircleTimer then
            mouseCircleTimer:stop()
        end
    end

    -- Create a large red circle around current mouse position
    mousepoint = hs.mouse.absolutePosition()
    mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x-40, mousepoint.y-40, 80, 80))
    mouseCircle:setStrokeColor({["red"]=1,["blue"]=0,["green"]=0,["alpha"]=1})
    mouseCircle:setFill(false)
    mouseCircle:setStrokeWidth(5)
    mouseCircle:show()

    -- Auto-remove circle after 2 seconds
    mouseCircleTimer = hs.timer.doAfter(2, function()
      mouseCircle:delete()
      mouseCircle = nil
    end)
end
hs.hotkey.bind({"cmd","alt","shift"}, "D", mouseHighlight)

-- =============================================================================
-- POWER MANAGEMENT & BLUETOOTH
-- =============================================================================

-- URL event handler for external app integrations
hs.urlevent.bind("someAlert", function(eventName, params)
    hs.alert.show("Received someAlert")
end)

-- Automatic Bluetooth toggle: Saves battery by turning off Bluetooth when sleeping
-- Requires 'blueutil' installed via: brew install blueutil
function checkBluetoothResult(rc, stdout, stderr)
    if rc ~= 0 then
        print(string.format("Unexpected result executing blueutil: rc=%d stderr=%s stdout=%s", rc, stderr, stdout))
    end
end

function bluetooth(power)
    print("Setting bluetooth to " .. power)
    local t = hs.task.new("/opt/homebrew/bin/blueutil", checkBluetoothResult, {"--power", power})
    t:start()
end

-- Sleep/wake event handler for Bluetooth automation
function f(event)
    if event == hs.caffeinate.watcher.systemWillSleep then
        bluetooth("off")  -- Turn off Bluetooth when going to sleep
    elseif event == hs.caffeinate.watcher.screensDidWake then
        bluetooth("on")   -- Turn on Bluetooth when waking up
    end
end

watcher = hs.caffeinate.watcher.new(f)
watcher:start()

-- =============================================================================
-- APPLICATION MANAGEMENT
-- =============================================================================

-- Helper function to get application bundle IDs
function appID(app)
    return hs.application.infoForBundlePath(app)['CFBundleIdentifier']
end

-- Pre-defined app bundle IDs for quick access
chromeBrowser = appID('/Applications/Google Chrome.app')
safari = appID('/Applications/Safari.app')
ghostty = appID('/Applications/Ghostty.app')

-- Enhanced visual app switcher with icons and bundle ID display
-- Hotkey: Cmd+Alt+Tab (alternative to built-in app switcher)
local chooser = hs.chooser.new(function(choice)
    if choice then
        hs.application.launchOrFocusByBundleID(choice.bundleID)
    end
end)

function appChooser()
    local apps = {}
    for _, app in pairs(hs.application.runningApplications()) do
        if app:title() ~= "" and app:bundleID() then
            table.insert(apps, {
                text = app:title(),
                subText = app:bundleID(),
                bundleID = app:bundleID(),
                image = hs.image.imageFromAppBundle(app:bundleID())
            })
        end
    end
    chooser:choices(apps)
    chooser:show()
end

hs.hotkey.bind({"cmd", "alt"}, "Tab", appChooser)

-- =============================================================================
-- CLIPBOARD MANAGEMENT
-- =============================================================================

-- Advanced clipboard history: Tracks last 20 copied items for easy access
-- Hotkey: Cmd+Shift+V to show clipboard history chooser
local clipboardHistory = {}
local maxClipboardItems = 20

function addToClipboard(content)
    -- Remove duplicates by checking if content already exists
    for i, item in ipairs(clipboardHistory) do
        if item == content then
            table.remove(clipboardHistory, i)
            break
        end
    end

    -- Add new content to the front of the list
    table.insert(clipboardHistory, 1, content)

    -- Maintain maximum history size
    if #clipboardHistory > maxClipboardItems then
        table.remove(clipboardHistory, maxClipboardItems + 1)
    end
end

-- Watch for clipboard changes and automatically add to history
clipboardWatcher = hs.pasteboard.watcher.new(function()
    local content = hs.pasteboard.getContents()
    if content and content ~= "" then
        addToClipboard(content)
    end
end):start()

-- Clipboard chooser interface: Select and paste from history
local clipChooser = hs.chooser.new(function(choice)
    if choice then
        hs.pasteboard.setContents(choice.text)
        hs.eventtap.keyStroke({"cmd"}, "v")  -- Auto-paste selected item
    end
end)

function showClipboard()
    local choices = {}
    for i, item in ipairs(clipboardHistory) do
        table.insert(choices, {
            text = item,
            subText = "Clipboard item " .. i
        })
    end
    clipChooser:choices(choices)
    clipChooser:show()
end

hs.hotkey.bind({"cmd", "shift"}, "V", showClipboard)

-- =============================================================================
-- QUICK APPLICATION LAUNCHERS
-- =============================================================================

-- Fast app launching: Faster than Spotlight for frequently used applications
function launchOrFocus(bundleID)
    hs.application.launchOrFocusByBundleID(bundleID)
end

-- Quick access to key development applications
-- Cmd+Alt+1: VSCode (primary code editor)
-- Cmd+Alt+3: Ghostty (terminal)
-- Cmd+Alt+4: Finder (file management)
hs.hotkey.bind({"cmd", "alt"}, "1", function() launchOrFocus("com.microsoft.VSCode") end)
hs.hotkey.bind({"cmd", "alt"}, "3", function() launchOrFocus(ghostty) end)
hs.hotkey.bind({"cmd", "alt"}, "4", function() launchOrFocus("com.apple.finder") end)

-- =============================================================================
-- SYSTEM UTILITIES
-- =============================================================================

-- Caffeine replacement: Prevent system sleep with menu bar toggle
-- Click the menu bar icon (☕ awake / 😴 sleepy) to toggle
local caffeine = hs.menubar.new()
local isAwake = false

function setCaffeineDisplay()
    if isAwake then
        caffeine:setTitle("☕")
        caffeine:setTooltip("Awake - Click to sleep")
        hs.caffeinate.set("displayIdle", true, true)  -- Prevent display sleep
    else
        caffeine:setTitle("😴")
        caffeine:setTooltip("Sleepy - Click to wake")
        hs.caffeinate.set("displayIdle", false, true)  -- Allow display sleep
    end
end

function toggleCaffeine()
    isAwake = not isAwake
    setCaffeineDisplay()
end

if caffeine then
    caffeine:setClickCallback(toggleCaffeine)
    setCaffeineDisplay()
end

-- Do Not Disturb toggle (placeholder - requires macOS integration)
function enableDND()
    hs.osascript.applescript([[
        tell application "System Events"
            tell process "Control Center"
                if not (it exists) then return
            end tell
        end tell
    ]])
    hs.alert.show("Do Not Disturb Enabled")
end

-- Audio device cycling: Switch between all available output devices
-- Hotkey: Cmd+Alt+A
function cycleAudioDevices()
    local current = hs.audiodevice.defaultOutputDevice()
    local devices = hs.audiodevice.allOutputDevices()

    local currentIndex = 1
    for i, device in ipairs(devices) do
        if device:uid() == current:uid() then
            currentIndex = i
            break
        end
    end

    local nextIndex = (currentIndex % #devices) + 1
    local nextDevice = devices[nextIndex]

    nextDevice:setDefaultOutputDevice()
    hs.alert.show("Audio: " .. nextDevice:name())
end

hs.hotkey.bind({"cmd", "alt"}, "A", cycleAudioDevices)

-- =============================================================================
-- DEVELOPER TOOLS
-- =============================================================================

-- Smart file reveal: Context-aware file revelation in Finder
-- Hotkey: Cmd+Alt+Shift+F
-- • In VSCode: Reveals current active file in Finder
-- • Elsewhere: Opens current working directory
hs.hotkey.bind({"cmd", "alt", "shift"}, "F", function()
    local app = hs.application.frontmostApplication()
    if app:name() == "Code" then
        -- VSCode integration: Use command palette to reveal current file
        hs.eventtap.keyStroke({"cmd", "shift"}, "p")
        hs.timer.doAfter(0.1, function()
            hs.pasteboard.setContents("File: Reveal Active File in Finder")
            hs.eventtap.keyStroke({"cmd"}, "v")
            hs.eventtap.keyStroke({}, "return")
        end)
    else
        -- Fallback: Open current directory in Finder
        hs.execute("open .")
    end
end)

-- Git status notifications: Show git working tree status in notification
-- Hotkey: Cmd+Alt+Shift+G
-- • Clean repo: Shows alert
-- • Dirty repo: Shows notification with file changes
function showGitStatus()
    local cwd = hs.fs.currentDir()
    local handle = io.popen("cd " .. cwd .. " && git status --porcelain 2>/dev/null")
    if handle then
        local result = handle:read("*a")
        handle:close()

        if result and result ~= "" then
            local lines = {}
            for line in result:gmatch("[^\r\n]+") do
                table.insert(lines, line)
            end
            hs.notify.new({
                title = "Git Status",
                informativeText = table.concat(lines, "\n"),
                hasActionButton = false
            }):send()
        else
            hs.alert.show("Git: Working tree clean")
        end
    end
end

hs.hotkey.bind({"cmd", "alt", "shift"}, "G", showGitStatus)

-- Smart terminal launcher: Context-aware Ghostty terminal opening
-- Hotkey: Cmd+Alt+T
-- • From Finder: Opens Ghostty in current Finder directory
-- • From elsewhere: Opens Ghostty in default location
hs.hotkey.bind({"cmd", "alt"}, "T", function()
    local frontApp = hs.application.frontmostApplication()
    if frontApp:name() == "Finder" then
        -- Finder integration: Get current directory and open Ghostty there
        hs.osascript.applescript([[
            tell application "Finder"
                set currentFolder to (folder of the front window as alias)
            end tell
            tell application "Ghostty"
                activate
                -- Ghostty will open in the current directory automatically
            end tell
        ]])
        -- Send cd command to navigate to Finder's current location
        hs.timer.doAfter(0.2, function()
            local path = hs.osascript.applescript([[
                tell application "Finder"
                    return POSIX path of (folder of the front window as alias)
                end tell
            ]])
            if path then
                path = path:gsub("\n", "") -- Remove newline
                hs.eventtap.keyStroke({}, "escape") -- Clear any existing input
                hs.pasteboard.setContents("cd " .. path:gsub(" ", "\\ "))
                hs.eventtap.keyStroke({"cmd"}, "v")
                hs.eventtap.keyStroke({}, "return")
            end
        end)
    else
        -- Default: Just launch Ghostty
        launchOrFocus(ghostty)
    end
end)

-- Screen recording toggle: Start/stop screen recording with notifications
-- Hotkey: Cmd+Alt+Shift+R
-- • Records to ~/Desktop with timestamp filename
-- • Shows start/stop alerts
local isRecording = false
function toggleScreenRecording()
    if isRecording then
        hs.execute("killall screencapture")
        hs.alert.show("Recording stopped")
        isRecording = false
    else
        local filename = os.date("~/Desktop/Recording_%Y%m%d_%H%M%S.mov")
        hs.execute("screencapture -v " .. filename .. " &")
        hs.alert.show("Recording started")
        isRecording = true
    end
end

hs.hotkey.bind({"cmd", "alt", "shift"}, "R", toggleScreenRecording)


-- =============================================================================
-- CONFIGURATION MANAGEMENT
-- =============================================================================

-- Auto-reload configuration: Automatically reloads Hammerspoon when config changes
-- Watches ~/.hammerspoon/ directory for .lua file changes
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")
