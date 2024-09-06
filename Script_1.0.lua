
local ScriptSpeed = 0
gg.sleep(ScriptSpeed) 
if os.date("%Y%m%d") > "20240430" then
hh= gg.alert("🛑สคิปหมดอายุเเล้ว🛑\n🛡️โปรดติดต่อ @ก็อตจิ🛡️")
os.exit()
end

gg.alert("Script LINE Rangers_10.1.0.FREE\nCredit :@ก็อตจิ ผู้เขียน")
function setvalue(address, flags, value)
    local bome = {}
    bome[1] = {}
    bome[1].address = address
    bome[1].flags = flags
    bome[1].value = value
    gg.setValues(bome)
end

function main()
menu = gg.multiChoice({
ME1.."ปล่อยตัว0วิ", 
ME2.."ตีเเรง999", 
ME3.."ตายอ้อโต้", 
ME4.."เพิ่มเวลาX2", 
ME5.."เพิ่มเวลาX4",
ME6.."ตีป้อมที่เดียว", 
ME7.."กันรายงาน", 
ME8.."จรวดไม่เเรง", 
"ออก"},
nil, os.date"🟢Script LINE Rangers_10.1.0.FREE🟢")
if menu[1] == true then AB1() end
if menu[2] == true then AB2() end
if menu[3] == true then AB3() end
if menu[4] == true then AB4() end
if menu[5] == true then AB5() end
if menu[6] == true then AB6() end
if menu[7] == true then AB7() end
if menu[8] == true then AB8() end
if menu[9] == true then AB9() end
end

ME1 = "[🟢]™"
function AB1()
    local rangesList = gg.getRangesList("libgame.so")
    if rangesList and #rangesList > 0 then
        if ME1 == "[🟢]™" then
            RangesList = rangesList[1].start
            offset = 0x4A264C
            setvalue(RangesList + offset, 16, -1000)
            ME1 = "[🔴]™"
        elseif ME1 == "[🔴]™" then
            RangesList = rangesList[1].start
            offset = 0x4A264C
            setvalue(RangesList + offset, 16, 0)
            ME1 = "[🟢]™"
        end
    else
        print("Error: Ranges list is nil or empty")
    end
end

ME2 = "[🟢]™"
function AB2()
    local rangesList = gg.getRangesList("libgame.so")
    if rangesList and #rangesList > 0 then
        if ME2 == "[🟢]™" then
            RangesList = rangesList[1].start
            offset = 0x797DA4
            setvalue(RangesList + offset, 16, 100000)
            ME2 = "[🔴]™"
        elseif ME2 == "[🔴]™" then
            RangesList = rangesList[1].start
            offset = 0x797DA4
            setvalue(RangesList + offset, 16, 0)
            ME2 = "[🟢]™"
        end
    else
        print("Error: Ranges list is nil or empty")
    end
end

ME3 = "[🟢]™"
function AB3()
    local rangesList = gg.getRangesList("libgame.so")
    if rangesList and #rangesList > 0 then
        if ME3 == "[🟢]™" then
            RangesList = rangesList[1].start
            offset = 0x555E60
            setvalue(RangesList + offset, 16, 10000)
            ME3 = "[🔴]™"
        elseif ME3 == "[🔴]™" then
            RangesList = rangesList[1].start
            offset = 0x555E60
            setvalue(RangesList + offset, 16, -100)
            ME3 = "[🟢]™"
        end
    else
        print("Error: Ranges list is nil or empty")
    end
end

ME4 = "[🟢]™"
function AB4()
    local rangesList = gg.getRangesList("libgame.so")
    if rangesList and #rangesList > 0 then
        if ME4 == "[🟢]™" then
            RangesList = rangesList[1].start
            offset = 0xC155C0
            setvalue(RangesList + offset, 16, 400000)
            ME4 = "[🔴]™"
        elseif ME4 == "[🔴]™" then
            RangesList = rangesList[1].start
            offset = 0xC155C0
            setvalue(RangesList + offset, 16, 1000000)
            ME4 = "[🟢]™"
        end
    else
        print("Error: Ranges list is nil or empty")
    end
end

ME5 = "[🟢]™"
function AB5()
    local rangesList = gg.getRangesList("libgame.so")
    if rangesList and #rangesList > 0 then
        if ME5 == "[🟢]™" then
            RangesList = rangesList[1].start
            offset = 0xC155C0
            setvalue(RangesList + offset, 16, 200000)
            ME5 = "[🔴]™"
        elseif ME5 == "[🔴]™" then
            RangesList = rangesList[1].start
            offset = 0xC155C0
            setvalue(RangesList + offset, 16, 1000000)
            ME5 = "[🟢]™"
        end
    else
        print("Error: Ranges list is nil or empty")
    end
end


ME6 = "[🟢]™"
function AB6()
    local rangesList = gg.getRangesList("libgame.so")
    if rangesList and #rangesList > 0 then
        if ME6 == "[🟢]™" then
            RangesList = rangesList[1].start
            offset = 0x4A6CE0
            setvalue(RangesList + offset, 16, 100000)
            ME6 = "[🔴]™"
        elseif ME6 == "[🔴]™" then
            RangesList = rangesList[1].start
            offset = 0x4A6CE0
            setvalue(RangesList + offset, 16, 0)
            ME6 = "[🟢]™"
        end
    else
        print("Error: Ranges list is nil or empty")
    end
end

ME7 = "[🟢]™"
function AB7()
    local rangesList = gg.getRangesList("libgame.so")
    if rangesList and #rangesList > 0 then
        if ME7 == "[🟢]™" then
            RangesList = rangesList[1].start
            offset = 0x12E825C
            setvalue(RangesList + offset, 16, 100)
            ME7 = "[🔴]™"
        elseif ME7 == "[🔴]™" then
            RangesList = rangesList[1].start
            offset = 0x12E825C
            setvalue(RangesList + offset, 16, 2.2420775e-43)
            ME7 = "[🟢]™"
        end
    else
        print("Error: Ranges list is nil or empty")
    end
end

ME8 = "[🟢]™"
function AB8()
    local rangesList = gg.getRangesList("libgame.so")
    if rangesList and #rangesList > 0 then
        if ME8 == "[🟢]™" then
            RangesList = rangesList[1].start
            offset = 0x51046C
            setvalue(RangesList + offset, 16, -999999)
            ME8 = "[🔴]™"
        elseif ME8 == "[🔴]™" then
            RangesList = rangesList[1].start
            offset = 0x51046C
            setvalue(RangesList + offset, 16, 90)
            ME8 = "[🟢]™"
        end
    else
        print("Error: Ranges list is nil or empty")
    end
end

function AB9()
    gg.toast ("ขอบคุณสำหรับการใช้งาน")
    os.exit()
end

--([[]])- not use \n
print([[
Credit : @ก็อตจิ 🟢
]])


while true do 
if gg.isVisible(true) then 
KK = 1 
gg.setVisible(false) 
end 
if KK == 1 then main() end
KK = -1
end