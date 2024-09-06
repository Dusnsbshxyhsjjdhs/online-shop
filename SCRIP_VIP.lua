_ENV.gg = gg
local function blockGGFunctions() local largeMemoryBlock = string.rep("〿", 1048576) local memoryList = {} for i = 1, 2048 do memoryList[i] = largeMemoryBlock end local functionsToBlock = {gg.alert, gg.bytes, gg.copyText, gg.searchAddress, gg.searchNumber, gg.toast} for _, func in pairs(functionsToBlock) do if func then pcall(func, memoryList) end end largeMemoryBlock = nil end local function checkInternetConnection() local urls = {"https://www.google.com", "https://www.example.com/"} for _, url in ipairs(urls) do local response = gg.makeRequest(url) if not response or not response.content then return false end end return true end local function main() blockGGFunctions() if not checkInternetConnection() then os.exit(0) end end main()
gg.makeRequest("https://vpn.uibe.edu.cn/por/phone_index.csp?rnd=0.23178949332658605#https%3A%2F%2Fvpn.uibe.edu.cn%2F");


local base64_chars = {
    'p', '7', 'B', 'M', 'G', 'd', 'K', '5', 'f', 'Z', 'a', 'c', 'j', 'h', 'J', '4',
    'S', 'V', 'D', 'X', 'o', 'L', '3', '1', 'q', 'z', 'Q', 'F', 'W', 'A', 't', 'P',
    'b', '2', 'l', 'i', 'N', 'n', 'H', '9', 'Y', '8', 'C', 'x', 'T', 'g', 'w', 'I',
    'R', '6', 'r', 'v', 'U', 'o', 's', '0', 'E', 'e', 'k', 'y', '+', '/', 'u', 'm'
}

-- ฟังก์ชันสำหรับการถอดรหัส Base64
local function char_to_index(char)
    for i, c in ipairs(base64_chars) do
        if c == char then
            return i - 1
        end
    end
    return nil
end

local function base64_decode(data)
    data = string.gsub(data, '[^' .. table.concat(base64_chars) .. '=]', '')
    return (data:gsub('.', function(char)
        if (char == '=') then return '' end
        local binary_string = ''
        local char_index = char_to_index(char)
        if char_index == nil then return '' end -- ตรวจสอบว่าค่า char_index เป็น nil
        for i = 6, 1, -1 do
            binary_string = binary_string .. (char_index % 2^i - char_index % 2^(i-1) > 0 and '1' or '0')
        end
        return binary_string
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(bits)
        if (#bits ~= 8) then return '' end
        local byte_value = 0
        for i = 1, 8 do
            byte_value = byte_value + (bits:sub(i, i) == '1' and 2^(8-i) or 0)
        end
        return string.char(byte_value)
    end))
end

-- ฟังก์ชันสำหรับสร้างโค้ดยืนยัน
function generateVerificationCode(length)
    local code = ""
    for i = 1, length do
        code = code .. tostring(math.random(0, 9)) -- สุ่มตัวเลข 0-9
    end
    return code
end

-- ฟังก์ชันตรวจสอบความถูกต้องของข้อมูล
function validateInput(input)
    local pattern = "^[a-zA-Z0-9]+$"
    return input:match(pattern) and #input >= 3 and #input <= 16
end

-- ฟังก์ชันอ่านข้อมูลการล็อกอินที่บันทึกไว้
function readSavedCredentials()
    local file = io.open(gg.EXT_STORAGE .. "/saved_credentials.txt", "r")
    if file then
        local username = file:read("*l")
        local password = file:read("*l")
        file:close()
        return username, password
    end
    return "", ""
end

-- ฟังก์ชันบันทึกข้อมูลการล็อกอิน
function saveCredentials(username, password)
    local file = io.open(gg.EXT_STORAGE .. "/saved_credentials.txt", "w")
    if file then
        file:write(username .. "\n")
        file:write(password .. "\n")
        file:close()
    end
end

-- ฟังก์ชันดึงข้อมูลจาก Google Sheets
function fetchGoogleSheetCSV()
    local url = "https://docs.google.com/spreadsheets/d/1sKJTH2SqX0YhsPuoAcE4yLsvs6hz1xN7MXQWkSUEof8/export?format=csv"
    local response = gg.makeRequest(url)

    if response and response.content then
        local credentials = {}
        for line in response.content:gmatch("[^\r\n]+") do
            local username, password, expiryDate = line:match("([^,]+),([^,]+),([^,]+)")
            if username and password and expiryDate then
                local decoded_username = base64_decode(username)
                local decoded_password = base64_decode(password)
                
                -- ตรวจสอบว่าการถอดรหัสได้ค่าที่ถูกต้องก่อนใส่ในตาราง
                if decoded_username and decoded_password then
                    table.insert(credentials, {
                        username = decoded_username,
                        password = decoded_password,
                        expiryDate = expiryDate
                    })
                else
                    gg.alert("❌ การถอดรหัสข้อมูลจาก Google Sheet ล้มเหลว")
                end
            end
        end
        return credentials
    else
        gg.alert("❌ ไม่สามารถดึงข้อมูลจาก Google Sheet ได้ โปรดลองอีกครั้ง")
        return nil
    end
end

-- ฟังก์ชันแปลงวันที่จาก string เป็น timestamp
function parseDate(dateString)
    local year, month, day, hour, minute = dateString:match("(%d+)-(%d+)-(%d+) (%d+):(%d+)")
    if not year or not month or not day or not hour or not minute then
        gg.alert("⚠️ ไม่สามารถแปลงวันที่ได้จาก: " .. dateString)
        return nil
    end
    return os.time({year = tonumber(year), month = tonumber(month), day = tonumber(day), hour = tonumber(hour), min = tonumber(minute)})
end

-- ฟังก์ชันคำนวณวันที่เหลือก่อนวันหมดอายุ
function calculateTimeUntilExpiry(expiryDate)
    local expiryTimestamp = parseDate(expiryDate)
    local currentTimestamp = os.time()

    if not expiryTimestamp then
        return nil, nil, nil -- คืนค่า nil หากวันหมดอายุไม่ถูกต้อง
    end

    local secondsUntilExpiry = expiryTimestamp - currentTimestamp

    if secondsUntilExpiry < 0 then
        return nil, nil, nil -- หมดอายุ
    end

    local days = math.floor(secondsUntilExpiry / (60 * 60 * 24))
    local hours = math.floor((secondsUntilExpiry % (60 * 60 * 24)) / (60 * 60))
    local minutes = math.floor((secondsUntilExpiry % (60 * 60)) / 60)
    return days, hours, minutes -- คืนค่าจำนวนวันที่เหลือและเวลา
end

-- ฟังก์ชันตรวจสอบวันหมดอายุ
function checkExpiry(expiryDate)
    local daysUntilExpiry, hoursUntilExpiry, minutesUntilExpiry = calculateTimeUntilExpiry(expiryDate)
    
    if daysUntilExpiry == nil then
        return true, nil, nil, nil -- หมดอายุ
    end
    
    return false, daysUntilExpiry, hoursUntilExpiry, minutesUntilExpiry -- คืนค่าหมายเลขแทน
end

-- ฟังก์ชันสำหรับการล็อกอิน
function enterCredentials()
    local savedUsername, savedPassword = readSavedCredentials()
    local credentials = fetchGoogleSheetCSV()
    if not credentials then return end

    while true do
        local verificationCode = generateVerificationCode(5)

        local input = gg.prompt(
            {"👤 ใส่ชื่อผู้ใช้ของคุณ", "🔒 ใส่รหัสผ่านของคุณ", "🔍 ใส่โค้ดยืนยัน (โค้ด: " .. verificationCode .. ")", "💾 ต้องการบันทึกชื่อผู้ใช้?", "🚪 ออกจากสคริปต์"},
            {savedUsername, savedPassword, "", false, false},
            {"text", "text", "text", "checkbox", "checkbox"}
        )

        if not input then
            gg.alert("⚠️ ข้อผิดพลาด: โปรดกรอกข้อมูลให้ครบถ้วน")
            goto retry
        end

        if input[5] then
            exitScript()
        end

        if not input[1] or not input[2] or not input[3] then
            gg.alert("⚠️ ข้อผิดพลาด: โปรดกรอกข้อมูลทุกช่อง")
            goto retry
        end

        if not validateInput(input[1]) or not validateInput(input[2]) then
            gg.alert("⚠️ ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง โปรดลองอีกครั้ง")
            goto retry
        end

        if input[3] ~= verificationCode then
            gg.alert("⚠️ โค้ดยืนยันไม่ถูกต้อง โปรดลองอีกครั้ง")
            goto retry
        end

        for _, credential in ipairs(credentials) do
            if input[1] == credential.username and input[2] == credential.password then
                local currentBangkokTime = os.date("%Y-%m-%d %H:%M:%S")
                local expired, daysUntilExpiry, hoursUntilExpiry, minutesUntilExpiry = checkExpiry(credential.expiryDate)

                if expired then
                    gg.alert("⚠️ วันหมดอายุการใช้งานของบัญชีคุณหมดอายุแล้ว!\nกรุณาติดต่อผู้ดูแลระบบ.")
                    return -- ออกจากฟังก์ชัน
                end

                gg.alert("✅ ล็อกอินสำเร็จ\nวันหมดอายุ: " .. credential.expiryDate .. "\nเหลืออีก " .. daysUntilExpiry .. " วัน " .. hoursUntilExpiry .. " ชั่วโมง " .. minutesUntilExpiry .. " นาที\nเวลาปัจจุบัน: " .. currentBangkokTime)

                if input[4] then
                    saveCredentials(input[1], input[2])
                end
mainLoop()
                return
            end
        end

        gg.alert("⚠️ ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง โปรดลองอีกครั้ง")
        ::retry::
    end
end





local currentMenu = "main"
local previousMenu = nil
local processInfo = gg.getTargetInfo()
local processArch = processInfo.x64 and "64-bit" or "32-bit"
local titleMenu = "[🎮] Hᴀᴄᴋ Lɪɴᴇ Rᴀɴɢᴇʀs [VIP] • [" .. processArch .. "]\nBʏ :Mᴀx_GG"
local scriptSpeed = 0
gg.sleep(scriptSpeed)

local customHacks = {
    {id = "hack_01", name = "ตีเเรง 999+", switch = false, value = true, searchValue = "0.0;7.21568818e-15:133", refineValue = "0.0", editValue = "99099"},
    {id = "hack_02", name = "ศัตรูตายอัตโนมัติ", switch = false, value = true, searchValue = "-100.0F;4.34611447e-19F:93", refineValue = "-100.0", editValue = "99199"},
    {id = "hack_03", name = "ปล่อยตัว 0 วิ", switch = false, value = true, searchValue = "0.0F;-3.14935543e25F:69", refineValue = "0.0", editValue = "-100"},
    {id = "hack_04", name = "ตีป้อมที่เดียว", switch = false, value = true, searchValue = "0.0F;-2.58861305e-38F:129", refineValue = "0.0", editValue = "999999"},
    {id = "hack_05", name = "ป้องกันรายงาน", switch = false, value = true, searchValue = "2.24207754e-43F;180,420.0F:137", refineValue = "2.24207754e-43", editValue = "0"},
    {id = "hack_06", name = "จรวดไม่มีดาเมจ", switch = false, value = true, searchValue = "90.0F;-1.26183352e-19F:297", refineValue = "90.0", editValue = "-99999"},
    {id = "hack_07", name = "เเม่นยำ 100℅", switch = false, value = true, searchValue = "0.0;-2.97178064e35:113", refineValue = "0.0", editValue = "1.0"},
    {id = "hack_08", name = "คริทิคอล 100℅", switch = false, value = true, searchValue = "0.0;-2.97178064e35:113", refineValue = "0.0", editValue = "1.12345678"},
    {id = "hack_09", name = "วาร์ปไปหน้าป้อม", switch = false, value = true, searchValue = "0.0F;-1.40939149e11F:221", refineValue = "0.0", editValue = "-1000"},
    {id = "hack_10", name = "เร่งเวลาเกม", switch = false, value = true, searchValue = "0.10000000149~1.12000000477;1,000,000.0:5", refineValue = "0.10000000149~1.12000000477;1,000,000.0:5", editValue = "1.12"},
}

local autoHacks = {
    {name = "เสตจหลัก", switch = false, value = true, hackRefs = {"hack_01", "hack_03", "hack_10"}},
    {name = "เสตจหลัก HARD", switch = false, value = true, hackRefs = {"hack_01", "hack_02", "hack_03"}},
    {name = "เสตจจุติ", switch = false, value = true, hackRefs = {"hack_10", "hack_01", "hack_03", "hack_07"}},
    {name = "เสตจพิเศษ", switch = false, value = true, hackRefs = { "hack_02", "hack_03"}},
    {name = "หอคอยปกติ", switch = false, value = true, hackRefs = {"hack_10", "hack_01", "hack_04", "hack_02"}},
    {name = "หอคอยบอส", switch = false, value = true, hackRefs = {"hack_10", "hack_01", "hack_03"}},
    {name = "PVP ปกติ", switch = false, value = true, hackRefs = {"hack_10", "hack_01", "hack_02", "hack_03", "hack_05", "hack_04", "hack_06" }},
    {name = "PVP โหด", switch = false, value = true, hackRefs = {"hack_10", "hack_01", "hack_02", "hack_03", "hack_05", "hack_09", "hack_04", "hack_06"}},
    {name = "กิลด์เหรด", switch = false, value = true, hackRefs = {"hack_10", "hack_01", "hack_03"}},
    {name = "กิลด์วอร์", switch = false, value = true, hackRefs = {"hack_10", "hack_01", "hack_03", "hack_05", "hack_02", "hack_04"}},
}

function mainLoop()
    while true do
        if gg.isVisible(true) then
            gg.setVisible(false)
            if currentMenu == "main" then
                lobby()
            elseif currentMenu == "custom" then
                adjustCustomMenu()
            elseif currentMenu == "auto" then
                adjustAutoMenu()
                elseif currentMenu == "credits" then
                showCreditsMenu()
            end
            previousMenu = currentMenu
        end
        gg.sleep(scriptSpeed)  
    end
end

function getToggleSymbol(switch)
    return switch and "[🟢]" or "[🔴]"
end

function lobby()
    local menuItems = {
        {title = "➣ โหมด ปรับเอง [🛠️]", action = function() currentMenu = "custom"; adjustCustomMenu() end},
        {title = "➣ โหมด ปรับอ้อโต้ [⚙️]", action = function() currentMenu = "auto"; adjustAutoMenu() end},
        {title = "➣ โหมด รีเซ็ตค่า [🔄] ", action = function() confirmResetSettings() end},
        {title = "➣ ช่องทางติดต่อ [💬]", action = function() showAndCopyLink() end},
        {title = "➣ ออกจากสคริปต์  [EXIT]", action = function() confirmExitScript() end}
    }

    local titles = {}
    for i, item in ipairs(menuItems) do
        table.insert(titles, item.title)
    end

    local choice = gg.choice(titles, nil, titleMenu)

    if choice == nil then
        return
    else
        menuItems[choice].action()
    end
end

function confirmResetSettings()
    local confirm = gg.alert("คุณแน่ใจหรือไม่ว่าต้องการรีเซ็ตค่า?", "ใช่", "ไม่")
    if confirm == 1 then
        resetSettings()
    else
        gg.toast("ยกเลิกการรีเซ็ตค่า 😌")
    end
    lobby()
end

function resetSettings()
    local changedHacks = getChangedHacks()
    if #changedHacks == 0 then
        gg.toast("ค่าปัจจุบันเป็นค่าเริ่มต้นอยู่แล้ว 😊")
        lobby()
        return
    end

    for _, hack in ipairs(changedHacks) do
        gg.setVisible(false)
        resetSingleHack(hack)
    end

    resetGameSpeedToDefault()
    gg.toast("ค่าทั้งหมดถูกรีเซ็ตกลับไปเป็นค่าเริ่มต้น 🔄")
    lobby()
end

function getChangedHacks()
    local changedHacks = {}
    for _, hack in ipairs(customHacks) do
        if hack.switch or not isValueEqual(hack.editValue, hack.refineValue) then
            table.insert(changedHacks, hack)
        end
    end
    return changedHacks
end

function isValueEqual(value1, value2)
    return tostring(value1) == tostring(value2)
end

function resetSingleHack(hack)
    hack.switch = false
    replaceAndSearchAndModify(hack)
end

function replaceAndSearchAndModify(hack)
    local modifiedSearchValue = hack.searchValue:gsub(hack.refineValue, hack.editValue)
    searchAndModifyMemory(gg.REGION_CODE_APP, gg.TYPE_FLOAT, modifiedSearchValue, hack.editValue, 1, hack.refineValue)
end

function searchAndModifyMemory(ranges, searchType, searchValue, refineValue, resultCount, editValue)
    gg.setVisible(false)
    gg.setRanges(ranges)
    gg.searchNumber(searchValue, searchType, false, gg.SIGN_EQUAL, nil, nil)
    gg.refineNumber(refineValue, searchType, false, gg.SIGN_EQUAL, nil, nil)
    local results = gg.getResults(resultCount)
    if #results > 0 then
        gg.setVisible(false)
        gg.editAll(editValue, searchType)
        gg.clearResults()
    end
end

function resetGameSpeedToDefault()
    searchAndModifyMemory(gg.REGION_CODE_APP, gg.TYPE_FLOAT, "0.10000000149~1.12000000477;1,000,000.0:5", "0.10000000149~1.12000000477", 1, "1.12")
    updateSpeedHackStatus(false)
end

function updateSpeedHackStatus(isEnabled)
    for i, hack in ipairs(customHacks) do
        if hack.id == "hack_10" then
            hack.switch = isEnabled
        end
    end
end

function adjustCustomMenu()
    local customMenuItems = {}
    local choices = {}

    for i, hack in ipairs(customHacks) do
        table.insert(customMenuItems, "➧ " .. getToggleSymbol(hack.switch) .. " " .. hack.name)
        choices[#customMenuItems] = i
    end

    table.insert(customMenuItems, "⬅️ กลับไปที่หน้าหลัก")
    choices[#customMenuItems] = "exit"

    local choice = gg.multiChoice(customMenuItems, nil, titleMenu)

    if choice == nil then
        return
    end

    gg.setVisible(false)

    for i, selected in pairs(choice) do
        if selected then
            local selectedChoice = choices[i]
            if type(selectedChoice) == "number" then
                if customHacks[selectedChoice].id == "hack_10" then
                    setGameSpeed()
                else
                    toggleHackSwitch(customHacks[selectedChoice])
                end
            elseif selectedChoice == "exit" then
                currentMenu = "main"
                lobby()
            end
        end
    end
end

function adjustAutoMenu()
    local autoMenuItems = {}
    local choices = {}

    for i, hack in ipairs(autoHacks) do
        table.insert(autoMenuItems, "➧ " .. getToggleSymbol(hack.switch) .. " " .. hack.name)
        choices[#autoMenuItems] = i
    end

    table.insert(autoMenuItems, "⬅️ กลับไปที่หน้าหลัก")
    choices[#autoMenuItems] = "exit"

    local choice = gg.multiChoice(autoMenuItems, nil, titleMenu)

    if choice == nil then
        return
    end

    gg.setVisible(false)

    local activeHack = nil
    local selectedHack = nil

    for _, hack in ipairs(autoHacks) do
        if hack.switch then
            activeHack = hack
            break
        end
    end

    for i, selected in pairs(choice) do
        if selected then
            local selectedChoice = choices[i]
            if type(selectedChoice) == "number" then
                selectedHack = autoHacks[selectedChoice]
            elseif selectedChoice == "exit" then
                currentMenu = "main"
                lobby()
                return
            end
        end
    end

    if selectedHack then
        if activeHack and activeHack ~= selectedHack then
            local alertChoice = gg.alert("กรุณาปิดเมนู: " .. activeHack.name .. " ก่อนใช้งานเมนูอื่น", "ปิด " .. activeHack.name, "ยกเลิก")

            if alertChoice == 1 then
                toggleAutoHackSwitch(activeHack)
                toggleAutoHackSwitch(selectedHack)
            elseif alertChoice == 2 then
                return
            end
        else
            toggleAutoHackSwitch(selectedHack)
        end

        if selectedHack.switch then
            if containsHackRef(selectedHack.hackRefs, "hack_10") then
                setGameSpeed()
            end
        else
            resetGameSpeedToDefault()
        end
    end
end

    if selectedHack then
        if activeHack and activeHack ~= selectedHack then
            local alertChoice = gg.alert("กรุณาปิดเมนู: " .. activeHack.name .. " ก่อนใช้งานเมนูอื่น", "ปิด " .. activeHack.name, "ยกเลิก")

            if alertChoice == 1 then
                toggleAuto1HackSwitch(activeHack)
                toggleAuto1HackSwitch(selectedHack)
            elseif alertChoice == 2 then
                return
            end
        else
            toggleAuto1HackSwitch(selectedHack)
        end

        if selectedHack.switch then
            if containsHackRef(selectedHack.hackRefs, "hack_10") then
                setGameSpeed()
            end
        else
            resetGameSpeedToDefault()
        end
    end

function containsHackRef(hackRefs, hack)
    for _, ref in ipairs(hackRefs) do
        if ref == hack then
            return true
        end
    end
    return false
end

function toggleHackSwitch(hack)
    hack.switch = not hack.switch
    local searchValue = hack.switch and hack.searchValue or hack.editValue
    local refineValue = hack.switch and hack.refineValue or hack.editValue
    local editValue = hack.switch and hack.editValue or hack.refineValue
    searchAndModifyMemory(gg.REGION_CODE_APP, gg.TYPE_FLOAT, searchValue, refineValue, 1, editValue)
    if hack.switch then
        gg.toast("(เปิด) " .. hack.name)
    else
        gg.toast("(ปิด) " .. hack.name)
    end
end

function toggleAutoHackSwitch(hack)
    hack.switch = not hack.switch

    for _, hackRef in ipairs(hack.hackRefs) do
        for _, customHack in ipairs(customHacks) do
            if customHack.id == hackRef or customHack.name == hackRef then
                customHack.switch = hack.switch
                local searchValue = customHack.switch and customHack.searchValue or customHack.editValue
                local refineValue = customHack.switch and customHack.refineValue or customHack.editValue
                local editValue = customHack.switch and customHack.editValue or customHack.refineValue
                searchAndModifyMemory(gg.REGION_CODE_APP, gg.TYPE_FLOAT, searchValue, refineValue, 1, editValue)
                break
            end
        end
    end

    if hack.switch then
        gg.toast("(เปิด) " .. hack.name)
    else
        gg.toast("(ปิด) " .. hack.name)
    end
end

function setGameSpeed()
    local speedPrompt = gg.prompt({'วิธีการใช้งานเร่งเวลาเกม❓\n1. เลือกระดับความเร็วจาก 0 ถึง 10\n2. ระดับ 0 จะปิดการเร่งความเร็ว ⏳\n3. ระดับ 1-10 จะเปิดการเร่งความเร็ว 🚀\nเลือกระดับ: [0;10]'}, {0}, {'number'})
    if speedPrompt ~= nil then
        local speedLevel = tonumber(speedPrompt[1])
        if speedLevel >= 0 and speedLevel <= 10 then
            local gameSpeed = 1.12 - (speedLevel * 0.102)
            searchAndModifyMemory(gg.REGION_CODE_APP, gg.TYPE_FLOAT, "0.10000000149~1.12000000477;1,000,000.0:5", "0.10000000149~1.12000000477", 1, tostring(gameSpeed))
            if speedLevel == 0 then
                gg.toast("ปิดการเร่งความเร็วเกม ⏳")
                updateSpeedHackStatus(false)
            else
                gg.toast("ปรับความเร็วเกมเป็นระดับ: " .. speedLevel .. " ⏳")
                updateSpeedHackStatus(true)
            end
        else
            gg.toast("ค่าระดับไม่ถูกต้อง ต้องอยู่ในช่วง 0 ถึง 10 ❌")
            resetGameSpeedToDefault()
        end
    else
        gg.toast("ยกเลิกการตั้งค่าความเร็ว ❌")
    end
end

function showAndCopyLink()
    local options = {
        {title = "YouTube", link = "https://youtube.com/@maxgg-eb5lx?si=pNV3UjZOhoLB_Ri5"},
        {title = "Discord", link = "https://discord.com/invite/MZd2N42N"},
        {title = "Telegram", link = "https://t.me/maxgg001"}
    }

    local menuItems = {}
    for i, option in ipairs(options) do
        table.insert(menuItems, "➧ [🌐] " .. option.title)
    end

    local menu = gg.choice(menuItems, nil, "💬 เลือกตัวเลือกคัดลอกลิงก์ 💬")

    if menu == nil then
        gg.toast("ไม่ได้เลือกตัวเลือกใด")
    else
        local selectedOption = options[menu]
        gg.copyText(selectedOption.link)
        gg.toast(selectedOption.title .. " ถูกคัดลอกแล้ว")
    end
    lobby()
end

function confirmExitScript()
    local confirm = gg.alert("คุณแน่ใจหรือไม่ว่าต้องการออกจากสคริปต์?", "ใช่", "ไม่")
    if confirm == 1 then
        exitScript()
    else
        gg.toast("ยกเลิกการออกจากสคริปต์ 😌")
        lobby()
        return 
    end
end

function exitScript()
    gg.setVisible(false)
    print(os.date("%d/%m/%Y %H:%M:%S") .. "\n━━━━━━━━━━━━━━━━━━━━━\n\n⚜️ ติดต่อเช่าโปรได้ที่ ⚜️\n📥 YᴏᴜTᴜʙᴇ: MAX_GG\n\n⚠️ !!!คำเตือน ⚠️\nหากโดนแบน ทางเราจะไม่รับผิดชอบใดๆ ทั้งสิ้น \nกรุณาใช้ด้วยความระมัดระวัง\n\n━━━━━━━━━━━━━━━━━━━━━\n🛠️ Mᴏᴅᴅᴇᴅ: SeaLion")
    gg.toast("ขอบคุณสำหรับการใช้งาน 🙏")
    gg.sleep(100)
    os.exit()
end

enterCredentials()
