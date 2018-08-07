------------------------------
--------mmeg Helper v0.2-------
-----------by Wololo----------
--------AnkuLua Script--------
------------------------------

localPath = scriptPath()

version = "0.3"
local scriptPath = scriptPath()
local dir = string.match(scriptPath, '^.*/')
package.path = package.path .. ';' .. dir .. '?.lua'
dofile(scriptPath.. "libs/untar.lua")

--** CONFIG **--
debugging = true
maxSearchSpeed = 4
clickDelayMax = 3
acc = 0.8

--** refills **--
refillCount = 0
refillCountPvP = 0


elapsedTimeT = Timer()
textColor = 0xf80000ff
savedBrightness = getBrightness()

--temp vars
idle = false
oOEnergy = false
oOPvpEnergy = false
toArena = false

--screen show variables
dungeonCount = 0
dungeonWinCount = 0
dungeonLoseCount = 0

arenaCount = 0
arenaWinCount = 0
arenaLoseCount = 0

--** glyphs **--
glyphGradeNum = 99
sellString = "."
gBlue = 0
gGreen = 0
gYellow = 0
gPurple = 0

--** REGIONS **--
screen = getAppUsableScreenSize()
screenCenterReg = Region(660, 450, 700, 150)
screenReg = Region(1, 1, screen:getX(), screen:getY())
onScreenResultReg = Region(math.floor(screen:getX()/3), 1, 850, 50)

homeBattleBtn_region = Region(655, 953, 271, 116)
homeArenaBtn_region = Region(1016, 278, 190, 173)
dragonMistIslandBtn_region = Region(115, 525, 233, 194)
glyphDungeonBtn_region = Region(832, 521, 241, 128)
benefitBtn_region = Region(374, 959, 250, 108)
stageSearchRegion = Region(0, 203, 1459, 609)
dungeonPlayBtn_region = Region(1507, 832, 237, 131)
dungeonStartBtn_region = Region(778, 730, 251, 138)
eleDungeonBtn_region = Region(440, 752, 273, 78)
tohBtn_region = Region(346, 289, 197, 131)
eleSearchRegion = Region(0, 924, 1453, 142)
eleAllEvent_region = Region(12, 81, 235, 245)
returnHomeBtn_region = Region(1815, 0, 108, 95)
returnHomeExit_region = Region(808, 266, 301, 112)

farmFastModeBtn_region = Region(613, 866, 149, 141)
farmAutoDisabledBtn_region = Region(191, 935, 205, 104)
farmReplayBtn_region = Region(830, 559, 153, 104)
farmVictory_region = Region(782, 84, 355, 153)
farm3xMode_region = Region(57, 949, 74, 70)
farmSearchLootReg = Region(527, 864, 823, 187)
farmGearBtn_region = Region(1786, 58, 119, 65)
farmDefeat_region = Region(744, 92, 431, 152)
farmSearchReplayReg = Region(581, 432, 773, 619)
farmGetMonContinueBtn_region = Region(832, 915, 240, 88)
farmFithStage_region = Region(54, 18, 115, 76)
farmThirdStage_region = Region(49, 15, 120, 89)
farmOutOfEnergyYesBtn_region = Region(983, 675, 192, 105)
farmBossClick = Region(1110, 374, 111, 76)
farmMiniBossClick = Region(1165, 374, 77, 53)
farmGiveupSearchRegion = Region(429, 298, 1055, 518)
glyphRegion = Region(331, 74, 1249, 951)
glyphResultReg = Region(1580, 74, 340, 951)
saveReg = Region(331, 74, 1880, 951)
shopBuyEnergyYesBtn_region = Region(993, 681, 190, 94)
farmOutOfEnergy_region = Region(720, 327, 460, 119)
shopEnergyBtn_region = Region(242, 217, 174, 100)
shopEnergyConfirmOkBtn_region = Region(900, 876, 115, 93)
farmSellGlyphOkBtn_region = Region(981, 688, 219, 90)

arenaStartBtn_region = Region(757, 777, 346, 118)
arenaStartBtn2_region = Region(785, 697, 306, 106)
arenaVictory_region = Region(791, 96, 314, 111)
arenaMilestoneLoot_region = Region(199, 100, 199, 148)
arenaLootBtn_region = Region(806, 927, 299, 116)
shopArenaEnergyBtn_region = Region(717, 219, 228, 90)
arenaDefeat_region = Region(752, 132, 383, 135)
arena0Energy_region = Region(259, 3, 161, 81)

glyphTypeBubble_region = Region(837, 223, 277, 113)
glyphTypeQuad_region = Region(1031, 254, 91, 316)
glyphTypeHexa_region = Region(1006, 254, 140, 318)

glyphCenterRegion = Region(924, 383, 73, 71)
glyphSubstatRegion = Region(454, 640, 1009, 290)
glyphTypeRegion = Region(621, 540, 779, 100)
--** MISC FUNCTIONS **--

-- swipe functions
function swipeLeftSlow()
	swipe(Region(600, 600, 10, 10), Region(1200, 600, 10, 10))
end

function swipeLeft()
	swipe(Region(200, 600, 10, 10), Region(1600, 600, 10, 10))
end

function swipeRight()
	swipe(Region(1600, 600, 10, 10), Region(200, 600, 10, 10))
end

function swipeRightSlow()
	swipe(Region(800, 600, 10, 10), Region(600, 600, 10, 10))
end

function swipeDownSlow()
	swipe(Region(1050, 650, 10, 10), Region(1050, 450, 10, 10))
end

function swipeDown()
	swipe(Region(1050, 800, 10, 10), Region(1050, 350, 10, 10))
end

function incVar(var)
	var = var + 1
	return var
end

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

function logMsg(msg)
	if(logCb) then
		local ts = os.time()
		local timeStr = os.date('%Y.%m.%d %H:%M:%S', ts)
		local file = io.open(scriptPath.."log.txt", "a")
		file:write("["..timeStr.."] "..msg, "\n")
		file:close()
	end
end

function logRun(runDate ,dun, stage, runtime, winLose, loot, gType, gRarity, gSet, gSellString)
	if(logRunsCb) then
		
		local file2 = io.open(scriptPath.."runs.csv", "a")
		file2:write(runDate..", "..dun..", "..stage..", "..runtime..", "..winLose..", "..loot..", "..gType..", "..gRarity..", "..gSet..", "..gSellString.."\n")
		file2:close()
	end
end

--
function searchSpeed()
    local rand = math.random(5)
    local res = (rand - (math.floor(math.random(2, 10)/2.5)))+ maxSearchSpeed
    return res
end

function calcWinrate(wins, runs, lose)
    if(wins == 0) then
        return 0
    elseif(lose == 0) then
		return 100
	else
       local result = (wins/runs)*100
        return math.floor(result)
    end
end

--sets exit message
function setExitStats(note)
	local runes = gBlue + gGreen + gYellow + gPurple
	local stats = " "
	if(arenaCb)then
		stats = "~~Dungeonruns: "..dungeonCount.." ~~\t\t\tWinrate: "..calcWinrate(dungeonWinCount, dungeonCount, dungeonLoseCount).."%\nW: "..dungeonWinCount.." L: "..dungeonLoseCount.."\t\t\t\t\t\t\t\t\t\t\t\t\t\tElapsed Time: "..SecondsToClockHour(elapsedTimeT:check()).."\n".."Glyphs: ".."g: "..gGreen.." ("..calcWinrate(gGreen, runes, 1).."%) y: "..gYellow.." ("..calcWinrate(gYellow, runes, 1).."%) p: "..gPurple.." ("..calcWinrate(gPurple, runes, 1).."%)\n\n ~~Arena matches: "..arenaCount.." ~~\n W: "..arenaWinCount.." L: "..arenaLoseCount.."\n"..note
	else
		stats = "~~Dungeonruns: "..dungeonCount.." ~~\t\t\tWinrate: "..calcWinrate(dungeonWinCount, dungeonCount, dungeonLoseCount).."%\nW: "..dungeonWinCount.." L: "..dungeonLoseCount.."\t\t\t\t\t\t\t\t\t\t\t\t\t\tElapsed Time: "..SecondsToClockHour(elapsedTimeT:check()).."\n".."Glyphs: ".."g: "..gGreen.." ("..calcWinrate(gGreen, runes, 1).."%) y: "..gYellow.." ("..calcWinrate(gYellow, runes, 1).."%) p: "..gPurple.." ("..calcWinrate(gPurple, runes, 1).."%)\n\n"..note
	end
	
	setStopMessage(stats)
	if(note ~= "")then
		logMsg("Script stopping: "..note)
	end
end

--sets onscreen results
function setResultsOs()
    if(showOnscreenStatsCb)then
        onScreenResultReg:highlightOff()
        wait(.3)
        --setHighlightTextStyle(0x00ffffff,0xf8ffffff, 12)
        setHighlightTextStyle(0x4d000000,0xf8ffffff, 12)
		local runes = gBlue + gGreen + gYellow + gPurple
		local stats = " "
		if(arenaCb)then
			stats = "Runs: "..dungeonCount.." W: "..dungeonWinCount.." L: "..dungeonLoseCount.." Glyphs: ".."g: "..gGreen.." ("..calcWinrate(gGreen, runes, 1).."%) y: "..gYellow.." ("..calcWinrate(gYellow, runes, 1).."%) p: "..gPurple.." ("..calcWinrate(gPurple, runes, 1).."%) Arena: "..arenaCount.." W:"..arenaWinCount.." L: "..arenaLoseCount
		else
			stats = "Runs: "..dungeonCount.." W: "..dungeonWinCount.." L: "..dungeonLoseCount.." Glyphs: ".."g: "..gGreen.." ("..calcWinrate(gGreen, runes, 1).."%) y: "..gYellow.." ("..calcWinrate(gYellow, runes, 1).."%) p: "..gPurple.." ("..calcWinrate(gPurple, runes, 1).."%)"
        end
		onScreenResultReg:highlight(stats)
    end
end

--format seconds, Src: https://gist.github.com/jesseadams/791673
function SecondsToClock(seconds)
	local seconds = tonumber(seconds)

	if (seconds <= 0) then
		return "00:00";
	else
		local mins = string.format("%02.f", math.floor(seconds/60));
		local secs = string.format("%02.f", math.floor(seconds - mins *60));
		return mins..":"..secs
	end
end

--format seconds, Src: https://gist.github.com/jesseadams/791673
function SecondsToClockHour(seconds)
    local seconds = tonumber(seconds)

    if seconds <= 0 then
        return "00:00:00";
    else
        hours = string.format("%02.f", math.floor(seconds/3600));
        mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
        secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
        return hours..":"..mins..":"..secs
    end
end

function waitRandom(startRange, endRange)
	wait(math.random(startRange * 10, endRange * 10) / 10)
end

--clicks a random location in a given region
function clickRandomReg(r)
    wait(.1)
    local region = r
    local loc

    local xPos = region:getX()
    local yPos = region:getY()
    local maxX = region:getW()
    local maxY = region:getH()

    local xClick = xPos + math.random(maxX)
    local yClick = yPos + math.random(maxY)
	
	if debugCb == true then
		region:highlight(1)
		locReg = Region(xClick, yClick, 5, 5)
		locReg:highlight(1)
	end
	
    loc = Location(xClick, yClick)
    click(loc)
end
--clicks a random location in the given region if a image was found, else just click the center. Also adds the scandelay as wait after click
function clickRandom(r)
	logMsg('clickRandom start')
	wait(.1)
	local region
	local loc
	
	if debugCb == true then
		wait(.1)
		r:highlight(1)
	end
	
	if r:getLastMatch() ~= nil then
		logMsg('clickRandom getLastMatch is NOT nill')
		region = r:getLastMatch()
	else
		logMsg('clickRandom getLastMatch is nill')
		region = r
        if debugCb == true then
            wait(.1)
            region:highlight(1)
        else
            wait(.1)
        end
        loc = region:getCenter()
		wait(.5)
		click(loc:offset(math.random(1,8), math.random(1, 10)))
		return
	end
	if debugCb == true then
		wait(.1)
		region:highlight(1)
	else
		wait(.1)
	end
	local xPos = region:getX()
	local yPos = region:getY()
	local maxX = region:getW()
	local maxY = region:getH()

	local xClick = xPos + math.random(maxX)
	local yClick = yPos + math.random(maxY)
	
		
	loc = Location(xClick, yClick)
	if debugCb == true then
		locReg = Region(xClick, yClick, 10, 10)
		locReg:highlight(1)
	end
	click(loc)

	wait((math.random(clickDelayMax))+0.35)

	logMsg('clickRandom end')
end

--checks if there is a newer version and updates the script
function updateScript()

    if(checkUpdateCb) then
        toast("checking for updates..")
		logMsg("checking for updates..")
        wait(2)
		local downloadUrl = "http://swhelper.bplaced.net/download/mmeg/"
        local latestVersion = httpGet("http://swhelper.bplaced.net/mmeg_version.php")
        wait(1)
        if(version ~= latestVersion) then
            httpDownload(downloadUrl.."mmeg_helper.tar",scriptPath.."mmeg_helper.tar")
            toast("updating MMeg Helper")
			logMsg("updating MMeg Helper")
            wait(1)
            untar(scriptPath.."mmeg_helper.tar", scriptPath, true)
            wait(1)
            toast("updated to latest version "..latestVersion)
			logMsg("updated to latest version "..latestVersion)
            wait(2)
            setStopMessage("please restart the script, update successfull")
            scriptExit()
        else
            toast("This is the latest version.")
			logMsg("This is the latest version.")
            wait(2)
        end
    end
end

-- checks if aspect ratio is 16:9
function check16To9()
    local width = screen:getX()
    local height = screen:getY()

    local tempW = math.floor(width/16)
    local tempH = math.floor(height/9)

    if(tempW ~= tempH) then
       showMessageDialog(width.."x"..height.." is not 16:9! It may not work right.\n\n You have been warned.", "Notice")
	   logMsg(width.."x"..height.." is not 16:9! It may not work right.")
    end


end

function returnHome()
	if(homeBattleBtn_region:exists(Pattern("homeBattleBtn.png"):similar(acc))) then
		logMsg("Already on homescreen")
		return
	end
	
	logMsg("Returning to homescreen")
	if(returnHomeBtn_region:exists(Pattern("returnHomeBtn.png"):similar(acc))) then
		while(returnHomeBtn_region:exists(Pattern("returnHomeBtn.png"):similar(acc)))do
			clickRandom(returnHomeBtn_region)
			wait(1)
		end
		
	else
		repeat
			keyevent(4)
			wait(2)
		until(returnHomeExit_region:exists(Pattern("returnHomeExit.png"):similar(acc)))
		
		wait(2)
		keyevent(4)
	end
end

function showConfigDialog()
    dialogInit()
    addSeparator()
	addTextView("Mode: ")
	sdDungeonItems = {"Benefit", "Wrath", "Strength", "Current", "Fire", "Water", "Air", "Nature", "ToH"}-- "Fire", "Water", "Air", "Nature", "ToH",
	addSpinner("spDungeon", sdDungeonItems, sdDungeonItems[1])
	addTextView("Stage: ")
	spStageItems = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"}
	addSpinnerIndex("spStage", spStageItems, spStageItems[1])
	newRow()
	addTextView("fodder lvling, run stop after ")
	addEditNumber("runCounterMax", "0")
	addTextView(" runs (only in current mode, 0 = disabled) ")
	addSeparator()
    addCheckBox("refillCb", "refill Energy with seals? ", false)
	addTextView("max refills (0 = infinite): ")
	addEditNumber("refillMaxCount", "0")
	addSeparator()
	addTextView("avg runtime (seconds) ")
	addEditNumber("avgRunTimeSec", "60")
	addSeparator()
	addCheckBox("clickBossCB", "click bosses?", false)
	newRow()
	addTextView("Glyphs: ")
	spGlyphsItems = {"Keep", "Sell", "keep green+", "keep yellow+", "keep only purple"}
    addSpinnerIndex("spGlyphsIndex", spGlyphsItems, spGlyphsItems[1])
	addSeparator()
	addTextView("Switch to Arena every : ")
	addSpinnerIndex("spModNum", spStageItems, spStageItems[3])
	addTextView(" refills")
	newRow()
	addCheckBox("arenaCb", "run Arena?", false)
	addCheckBox("refillPvpCb", "refill PvP Energy with seals? ", false)
	addTextView("max refills (0 = infinite): ")
	addEditNumber("refillMaxCountPvP", "0")
	addSeparator()
    spSearchSpdItems = {"4 sec", "8 sec", "16 sec", "32 sec"}
    addTextView("search Delay:  ")
    addSpinnerIndex("spSearchSpdIndex", spSearchSpdItems, spSearchSpdItems[2])
    spMaxClickDelayItems = {"2 sec", "3 sec", "5 sec"}
    addTextView("max Click Delay:  ")
    addSpinnerIndex("spMaxClickDelayIndex", spMaxClickDelayItems, spMaxClickDelayItems[2])
    newRow()
    addCheckBox("showOnscreenStatsCb", "onscreen stats?", false)
	addCheckBox("logRunsCb", "log runs?", false)
	addCheckBox("logCb", "enable log?", false)
	addCheckBox("saveGlyphCB", "save glyph image?", false)
	addCheckBox("checkUpdateCb","check for updates?", false)
    newRow()
    addCheckBox("immersiveCb", "immersive?", true)
	addCheckBox("dimScreenCb", "dim screen?", false)
	addCheckBox("debugCb", "debug mode?", false)
    newRow()
    spResItems = {"auto detect", "2560x1440", "1920x1080", "1280x720"}
    addTextView("Resolution:  ")
    addSpinnerIndex("spResIndex", spResItems, spResItems[1])
    addSeparator()
    dialogShowFullScreen("MM Helper Config")
	
end	

function setConfig()

	if(spResIndex == 1) then
        toast("detecting resolution..")
        wait(1)
		check16To9()

        local width = screen:getX()
        local height = screen:getY()
        Settings:setScriptDimension(true, 1920)
        Settings:setCompareDimension(true, width)
        toast("Resolution set to "..width.."x"..height)
        wait(1)
    elseif(spResIndex == 2) then
        Settings:setScriptDimension(true, 1920)
        Settings:setCompareDimension(true, 2560)
    elseif(spResIndex == 3) then
        Settings:setScriptDimension(true, 1920)
        Settings:setCompareDimension(true, 1920)
    elseif(spResIndex == 4) then
        Settings:setScriptDimension(true, 1920)
        Settings:setCompareDimension(true, 1280)
    end
	
	if(spSearchSpdIndex == 1)then
		clickDelayMax = 2
	elseif(spSearchSpdIndex == 1)then
		clickDelayMax = 3
	elseif(spSearchSpdIndex == 1)then
		clickDelayMax = 5
	end
	
	if(spSearchSpdIndex == 1)then
		maxSearchSpeed = 4
	elseif(spSearchSpdIndex == 1)then
		maxSearchSpeed = 8
	elseif(spSearchSpdIndex == 1)then
		maxSearchSpeed = 16
	elseif(spSearchSpdIndex == 1)then
		maxSearchSpeed = 32
	end

end

function waitForBattle()
	logMsg("Waiting for battle start...")
	setHighlightTextStyle(0x4d000000,0xf8ffffff, 20)
	screenCenterReg:highlight("Waiting till battle starts...")
	while not(farmGearBtn_region:exists(Pattern("farmGearBtn.png"):similar(acc))) do
		wait(4)
	end
	screenCenterReg:highlightOff()
	logMsg("Battle started")
	while(farmAutoDisabledBtn_region:exists(Pattern("farmAutoDisabledBtn.png"):similar(acc))) do
		wait(1)
		clickRandom(farmAutoDisabledBtn_region)
		logMsg("activated auto mode")
	end
	
	
end

function waitForResult()
	local runtime = Timer()
	local stage = 0
	
	logMsg("Looking for result")

	dungeonCount = dungeonCount +1
	setExitStats("")
	setResultsOs()
	if (clickBossCB == false and avgRunTimeSec ~=0)then
		toast("Waiting "..avgRunTimeSec.." sec")
		logMsg("Waiting "..avgRunTimeSec.." sec")
		wait(avgRunTimeSec)
	end

	repeat
		wait(searchSpeed())
		
		if(clickBossCB)then
			if(stage == 0 and farmThirdStage_region:exists(Pattern("farmThirdStage.png"):similar(.90))) then
				clickRandomReg(farmMiniBossClick)
				stage = 3
				logMsg("Clicked miniboss")
			end
			if(stage == 3 and farmFithStage_region:exists(Pattern("farmFithStage.png"):similar(.90))) then
				clickRandomReg(farmBossClick)
				stage = 5
				logMsg("Clicked boss")
			end
		end
		
		toast("Looking for result...")
	
	until(farmVictory_region:exists(Pattern("farmVictory.png"):similar(acc)) or farmGiveupSearchRegion:exists(Pattern("farmGiveupBtn.png"):similar(acc)))
	
	local win = "0000"
	if(farmVictory_region:exists(Pattern("farmVictory.png"):similar(acc))) then
		dungeonWinCount = dungeonWinCount + 1
		toast("Win")
		logMsg("Win")
		win = "true"
	elseif(farmGiveupSearchRegion:exists(Pattern("farmGiveupBtn.png"):similar(acc))) then
		dungeonLoseCount = dungeonLoseCount + 1
		toast("Lose")
		logMsg("Lose")
		win = "false"
		clickRandom(farmGiveupSearchRegion)
	end
	local runTime = SecondsToClock(runtime:check())
	logMsg("runtime: "..runTime)
	toast("runtime: "..runTime)
	
	
	clickRandomReg(screenCenterReg)
	setResultsOs()
	setExitStats("")
	wait(.5)

	local loot = "."
	local gType = "."
	local gRarity = "."
	local gSet = "."

	--1 blue, 2 green, 3yellow, 4 purple, no grade 99
	if(farmSearchLootReg:exists(Pattern("farmGetLootBtn.png"):similar(acc))) then
		wait(.5)
		loot, gType, gRarity, gSet = saveGlyphImage()	
		if(spGlyphsIndex == 1)then
			wait(.5)
			toast("Keep")
			while not(farmSearchReplayReg:exists(Pattern("farmReplayBtn.png"):similar(acc))) do
					clickRandom(farmSearchLootReg)
					wait(.6)
				end
			logMsg("Getting loot")
			wait(.1)
			sellString = "False"
		elseif(spGlyphsIndex == 2)then
			sellGlyph(loot.." "..gType.." "..gRarity.." "..gSet)
		elseif(spGlyphsIndex == 3)then 
			if(glyphGradeNum < 2 )then
				sellGlyph(loot.." "..gType.." "..gRarity.." "..gSet)
				logMsg("selling - keep only green+")
			else
				wait(.5)
				toast("Keep")
				while not(farmSearchReplayReg:exists(Pattern("farmReplayBtn.png"):similar(acc))) do
					clickRandom(farmSearchLootReg)
					wait(.6)
				end
				logMsg("Getting loot")
				wait(.1)
				sellString = "False"	
			end
		elseif(spGlyphsIndex == 4)then 
			if(glyphGradeNum < 3 )then
				sellGlyph(loot.." "..gType.." "..gRarity.." "..gSet)
				logMsg("selling - keep only yellow+")
			else
				wait(.5)
				toast("Keep")
				while not(farmSearchReplayReg:exists(Pattern("farmReplayBtn.png"):similar(acc))) do
					clickRandom(farmSearchLootReg)
					wait(.6)
				end
				logMsg("Getting loot")
				wait(.1)
				sellString = "False"	
			end
		elseif(spGlyphsIndex == 5)then 
			if(glyphGradeNum ~= 4 )then
				sellGlyph(loot.." "..gType.." "..gRarity.." "..gSet)
				logMsg("selling - keep only purple")
			else
				wait(.5)
				toast("Keep")
				while not(farmSearchReplayReg:exists(Pattern("farmReplayBtn.png"):similar(acc))) do
					clickRandom(farmSearchLootReg)
					wait(.6)
				end
				
				logMsg("Getting loot")
				wait(.1)
				sellString = "False"				
			end
		end	
			
	end
	wait(1)
	if(farmGetMonContinueBtn_region:exists(Pattern("farmGetMonContinueBtn.png"):similar(acc))) then
		wait(1)
		clickRandom(farmGetMonContinueBtn_region)
		logMsg("Getting dropped monster")
	end

	local runDate = os.date("%d.%m.%y %H:%M:%S")
	logRun(runDate, spDungeon, spStage, runTime, win, loot, gType, gRarity, gSet, sellString)
	--("Time, Dungeon, Stage, Runtime, Win, Loot\n")	
	local runes = gBlue + gGreen + gYellow + gPurple
    local stats = "_________________________________________________\n\t\t\t\t\t  Dungeonruns: "..dungeonCount.."\t\t Winrate: "..calcWinrate(dungeonWinCount, dungeonCount, dungeonLoseCount).."%\n\t\t\t\t\t  W: "..dungeonWinCount.." L: "..dungeonLoseCount.."\t\t\t\t Elapsed Time: "..SecondsToClockHour(elapsedTimeT:check()).."\n\t\t\t\t\t  ".."Glyphs: ".."g: "..gGreen.." ("..calcWinrate(gGreen, runes, 1).."%) y: "..gYellow.." ("..calcWinrate(gYellow, runes, 1).."%) p: "..gPurple.." ("..calcWinrate(gPurple, runes, 1).."%)\n\t\t\t\t\t  _________________________________________________"
	logMsg(stats)
end

function replay()
	
	if(spDungeon == "Current")then
		if(runCounterMax ~= 0) then
			if(runCounterMax <= dungeonCount)then
				setExitStats("Max runs reached!")
				scriptExit()
			end
		end
	end

	logMsg("Looking for absence of farmReplayBtn.png")
	while not(farmSearchReplayReg:exists(Pattern("farmReplayBtn.png"):similar(acc))) do		
		wait(1)
	end

	logMsg("Looking for absence of farmFastModeBtn.png")
	if not(farmFastModeBtn_region:exists(Pattern("farmFastModeBtn.png"):similar(acc))) then		
		clickRandom(farmFastModeBtn_region)
		wait(1)
	end

	logMsg('Click replay')
	clickRandom(farmSearchReplayReg)

	if(checkEnergy()) then
		if(refillCb) then
			refillEnergy()
			if(refillCount%spModNum == 0)then
				logMsg("switch to arena")
				toast("switch to arena")
				toArena = true
				return -- escape to do arena
			end
			while not(farmFastModeBtn_region:exists(Pattern("farmFastModeBtn.png"):similar(acc))) do
				wait(1)
				clickRandom(farmFastModeBtn_region)
			end
			wait(1)
			clickRandom(farmSearchReplayReg)
		else
			setExitStats("")
			oOEnergy = true
			return
		end
	end
	logMsg("Replay dungeon")
	while not(farmGearBtn_region:exists(Pattern("farmGearBtn.png"):similar(acc))) do
		wait(1)
	end

end

function sellGlyph(note)

	if(farmSearchLootReg:exists(Pattern("farmSellLootBtn.png"):similar(acc))) then
				wait(.1)
				sellString = "True"
				clickRandom(farmSearchLootReg)
				logMsg("Selling --> "..note)
				if(farmSellGlyphOkBtn_region:exists(Pattern("farmSellGlyphOkBtn.png"):similar(acc))) then
					clickRandom(farmSellGlyphOkBtn_region)

					wait(.5)
					toast("Sell")
				end
			end

	end

function checkEnergy()

	logMsg("Checking energy")

	if(farmOutOfEnergy_region:exists(Pattern("farmOutOfEnergy.png"):similar(acc))) then
		logMsg("Energy empty")
		return true
	else
		logMsg("Energy remaining")
		return false
	end

end

function refillEnergy()
	refillCount = refillCount +1
	if(refillMaxCount > 0)then
		if(refillMaxCount <= refillCount)then
				setExitStats("Max refills reached!")
				logMsg("max refills reached, exit script")
				scriptExit()
		else
			logMsg("- - - - "..refillCount..". refill - - - -")
		end
	end
	while not(farmOutOfEnergyYesBtn_region:exists(Pattern("farmOutOfEnergyYesBtn.png"):similar(acc))) do
		wait(1)
	end
	clickRandom(farmOutOfEnergyYesBtn_region)
	while not(shopEnergyBtn_region:exists(Pattern("shopEnergyBtn.png"):similar(acc))) do
		wait(1)
	end
	clickRandom(shopEnergyBtn_region)
	while not(shopBuyEnergyYesBtn_region:exists(Pattern("shopBuyEnergyYesBtn.png"):similar(acc))) do
		wait(1)
	end
	clickRandom(shopBuyEnergyYesBtn_region)
	while not(shopEnergyConfirmOkBtn_region:exists(Pattern("shopEnergyConfirmOkBtn.png"):similar(acc))) do
		wait(1)
	end
	clickRandom(shopEnergyConfirmOkBtn_region)
	wait(1)
	keyevent(4)
	
end

function refillPvpEnergy()
	if(refillMaxCountPvP > 0)then
		if(refillMaxCountPvP <= refillCountPvP)then
				setExitStats("Max PvP refills reached!")
				logMsg("max PvP refills reached, exit script")
				scriptExit()
		else
			refillCountPvP = refillCountPvP +1
			logMsg("- - - - "..refillCountPvP..". PvP refill - - - -")
		end
	end
	while not(farmOutOfEnergyYesBtn_region:exists(Pattern("farmOutOfEnergyYesBtn.png"):similar(acc))) do
		wait(1)
	end
	clickRandom(farmOutOfEnergyYesBtn_region)
	while not(shopArenaEnergyBtn_region:exists(Pattern("shopArenaEnergyBtn.png"):similar(acc))) do
		wait(1)
	end
	clickRandom(shopArenaEnergyBtn_region)
	while not(shopBuyEnergyYesBtn_region:exists(Pattern("shopBuyEnergyYesBtn.png"):similar(acc))) do
		wait(1)
	end
	clickRandom(shopBuyEnergyYesBtn_region)
	while not(shopEnergyConfirmOkBtn_region:exists(Pattern("shopEnergyConfirmOkBtn.png"):similar(acc))) do
		wait(1)
	end
	clickRandom(shopEnergyConfirmOkBtn_region)
	wait(1)
	keyevent(4)
	
end

function findDungeon()
	--"Benefit", "Wrath", "Strength", "Fire", "Water", "Air", "Nature", "ToH", "Current"
	wait(1)
	logMsg("Running "..spDungeon.." Stage "..spStage)
	toast("Running "..spDungeon.." Stage "..spStage)
	
	if(spDungeon == "Current")then
		return
	end
	
	stage={
		Pattern("stage1.png"):similar(.95),
		Pattern("stage2.png"):similar(.95),
		Pattern("stage3.png"):similar(.95),
		Pattern("stage4.png"):similar(.95),
		Pattern("stage5.png"):similar(.95),
		Pattern("stage6.png"):similar(.95),
		Pattern("stage7.png"):similar(.95),
		Pattern("stage8.png"):similar(.95),
		Pattern("stage9.png"):similar(.95),
		Pattern("stage10.png"):similar(.95)
	
	}
	while not(homeBattleBtn_region:exists(Pattern("homeBattleBtn.png"):similar(acc))) do
		wait(1)
	end
	wait(1)
	while(homeBattleBtn_region:exists(Pattern("homeBattleBtn.png"):similar(acc))) do
		clickRandom(homeBattleBtn_region)
		wait(1)
	end
	
	logMsg("1")
	
	while not(dragonMistIslandBtn_region:exists(Pattern("dragonMistIslandBtn.png"):similar(acc))) do
		wait(1)
	end
	wait(1)
	while(dragonMistIslandBtn_region:exists(Pattern("dragonMistIslandBtn.png"):similar(acc))) do
		clickRandom(dragonMistIslandBtn_region)
		wait(1)
	end
	
	logMsg("2")
	
	if(spDungeon == "Benefit" or spDungeon == "Wrath" or spDungeon == "Strength")then
		while not(glyphDungeonBtn_region:exists(Pattern("glyphDungeonBtn.png"):similar(acc))) do
			wait(1)
		end
		clickRandom(glyphDungeonBtn_region)
	
		while not(benefitBtn_region:exists(Pattern("benefitBtn.png"):similar(acc)) or benefitBtn_region:exists(Pattern("benefitBtn2.png"):similar(acc))) do
			wait(1)
		end
		
		if(spDungeon == "Benefit") then
			clickRandom(benefitBtn_region)			
		elseif(spDungeon == "Wrath")then
			local tmpWrath = benefitBtn_region:getLastMatch()
			local x = tmpWrath:getX()
			local y = tmpWrath:getY()
			local w = tmpWrath:getW()
			local h = tmpWrath:getH()
			local wrathReg = Region(x+270,y,w,h)
			clickRandom(wrathReg)
		elseif(spDungeon == "Strength")then
			local tmpWrath = benefitBtn_region:getLastMatch()
			local x = tmpWrath:getX()
			local y = tmpWrath:getY()
			local w = tmpWrath:getW()
			local h = tmpWrath:getH()
			local strengthReg = Region(x+550,y,w,h)
			clickRandom(strengthReg)
		end
		
		
		
	elseif(spDungeon == "Fire" or spDungeon == "Water" or spDungeon == "Air" or spDungeon == "Nature")then
		local allFour = false
		while not(eleDungeonBtn_region:exists(Pattern("eleDungeonBtn.png"):similar(acc))) do
			wait(1)
		end
		clickRandom(eleDungeonBtn_region)
		
		while not(dungeonPlayBtn_region:exists(Pattern("dungeonPlayBtn.png"):similar(acc))) do
			wait(1)
		end
		
		if(eleAllEvent_region:exists(Pattern("eleAllEvent.png"):similar(acc))) then
			allFour = true
			logMsg("Event for all Ele Dungeons active")
		end
		
		local weekDay = os.date("%w") --0 sunday - 6 saturday
		if(allFour == true and spDungeon == "Fire") then
		  wait(1)
		elseif(weekDay == 5 and spDungeon == "Fire") then
			wait(1)
		elseif(weekDay == 6 and spDungeon == "Air") then
			wait(1)
		else
			wait(1)
			local p = 0
			
			if(spDungeon == "Fire")then
				p = Pattern("eleFireBtn.png"):similar(acc)
			elseif(spDungeon == "Water")then
				p = Pattern("eleWaterBtn.png"):similar(acc)
			elseif(spDungeon == "Air")then
				p = Pattern("eleAirBtn.png"):similar(acc)
			elseif(spDungeon == "Nature")then
				p = Pattern("eleNatureBtn.png"):similar(acc)
			end
			
			if(eleSearchRegion:exists(p))then
				clickRandom(eleSearchRegion)
			else
				wait(1)
				setExitStats("There is no "..spDungeon.." today!")
				scriptExit()
			end
		end
		wait(1)
		
	
	elseif(spDungeon == "ToH")then
		while not(tohBtn_region:exists(Pattern("tohBtn.png"):similar(acc))) do
			wait(1)
		end
		clickRandom(tohBtn_region)
		wait(1)

	end
	
	if(spStage < 7) then
		swipeLeft()
		wait(.5)
		swipeLeft()
	elseif(spStage >= 7) then
		swipeRight()
	end
	while not(stageSearchRegion:exists(stage[spStage])) do
		swipeRightSlow()
		wait(3)
	end
	wait(1)
	clickRandom(stageSearchRegion)
	
	while not(dungeonPlayBtn_region:exists(Pattern("dungeonPlayBtn.png"):similar(acc))) do
		wait(1)
	end
	clickRandom(dungeonPlayBtn_region)
	
	wait(1)
	if(checkEnergy()) then
		if(refillCb) then
			refillEnergy()
			wait(1)
			clickRandom(dungeonPlayBtn_region)
		else
			setExitStats("")
			oOEnergy = true
			return
		end
	end
	
	while not(dungeonStartBtn_region:exists(Pattern("dungeonStartBtn.png"):similar(acc))) do
		wait(1)
	end
	clickRandom(dungeonStartBtn_region)
		
	logMsg("Dungeon found and starting..")

end

--saves a image of the glyph
function saveGlyphImage()

	local gType = 'null' -- getGlyphType()
	local gRarity = getGlyphRarity()
	local gSet = 'null' -- getGlyphSet()
	  
	setExitStats("")
	if(saveGlyphCB)then
	    local newImageName = os.date("%d.%m.%y_%H.%M.%S")
		local newDirName = os.date("%d.%m.%y") 
		resultString = gType.."\n"..gRarity.."\n"..gSet.."\n"..newImageName
		setHighlightTextStyle(0x8ff2f2f2, 0xf80000ff, 16)
	    glyphResultReg:highlight(resultString)
		glyphRegion:highlight(1)
		os.execute("mkdir "..localPath.."glyphs/"..newDirName)
		saveReg:save("tmp.png")
		wait(.3)
		os.execute("mv "..localPath.."image/tmp.png" .. " " ..localPath.."glyphs/"..newDirName.."/"..newImageName..".png")
		setHighlightTextStyle(0x00ffffff,0xf8ffffff, 12)

		glyphResultReg:highlightOff()
		logMsg("saved "..newImageName)
	end
    return "Glyph", gType, gRarity, gSet
end

--show rune data
function showEvaluationData()

    local time = os.date("%d.%m.%y_%H.%M.%S")

    setHighlightTextStyle(0x8ff2f2f2, 0xf80000ff, 16)
    resultString = "NICE GLYPH"
    glyphResultReg:highlight(resultString)
    glyphRegion:highlight(2)
    setHighlightTextStyle(0x00ffffff,0xf8ffffff, 12)

    glyphResultReg:highlightOff()
    wait(1)

end

function getGlyphType()
	logMsg("Getting glyph type...")
	if(glyphTypeBubble_region:exists(Pattern("glyphTypeBubble.png"):similar(0.95)))then
		logMsg("--> Circle")
		return "Circle"
	elseif(glyphTypeQuad_region:exists(Pattern("glyphTypeQuad.png"):similar(0.95)))then
		logMsg("--> Square")
		return "Square"
	elseif(glyphTypeHexa_region:exists(Pattern("glyphTypeHexa.png"):similar(0.95)))then
		logMsg("--> Hexagon")
		return "Hexagon"
	else
		logMsg("--> can't detect type")
		return "No type detected"
	end
end
--1 blue, 2 green, 3yellow, 4 purple, no grade 99
function getGlyphRarity()
	logMsg("Getting glyph rarity...")
	r, g, b = getColor(glyphCenterRegion)
	--toast("red: "..r.." green: "..g.." blue: "..b)
	if(g > b and g > r )then
		logMsg("--> Green")
		wait(.1)
		glyphGradeNum = 2
		wait(.1)
		gGreen = gGreen+1
		wait(.1)
		return "Green"
	elseif(r > g and b > g)then
		logMsg("--> Purple")
		wait(.1)
		glyphGradeNum = 4
		wait(.1)
		gPurple = gPurple+1
		wait(.1)
		return "Purple"
	elseif(b > r and b > g)then
		logMsg("--> Blue")
		wait(.1)
		glyphGradeNum = 1
		wait(.1)
		gBlue = gBlue+1
		wait(.1)
		return "Blue"
	elseif(g > b and r > b)then
		logMsg("--> Yellow")
		wait(.1)
		glyphGradeNum = 3
		wait(.1)
		gYellow = gYellow+1
		wait(.1)
		return "Yellow"
	else
		glyphGradeNum = 99
		logMsg("--> no color r:"..r.." g:"..g.." b:"..b)
		return "no color r:"..r.." g:"..g.." b:"..b
	end
	
	
end

function getGlyphSet()
	logMsg("Getting glyph Set...")
	pBenefit={
		Pattern("glyphVitality.png"):similar(acc),--
		Pattern("glyphDefense.png"):similar(acc), --
		Pattern("glyphEndurance.png"):similar(acc),--
		Pattern("glyphImmunity.png"):similar(acc)
		}
	pWrath={
			Pattern("glyphHaste.png"):similar(acc), --
			Pattern("glyphLifesteal.png"):similar(acc), --
			Pattern("glyphPrecision.png"):similar(acc), --
			Pattern("glyphAppeasement.png"):similar(acc) --
			}
	pStrenght={
		Pattern("glyphStrength.png"):similar(acc), --
		Pattern("glyphFrenzy.png"):similar(acc), --
		Pattern("glyphDestruction.png"):similar(acc), --
		Pattern("glyphMeditation.png"):similar(acc) --
		}		
	
	if(spDungeon == "Benefit") then
		
		if(glyphTypeRegion:exists(pBenefit[1]))then
			logMsg("--> Vitality")
			return "Vitality"
		elseif(glyphTypeRegion:exists(pBenefit[2]))then
			logMsg("--> Defense")
			return "Defense"
		elseif(glyphTypeRegion:exists(pBenefit[3]))then
			logMsg("--> Endurance")
			return "Endurance"
		elseif(glyphTypeRegion:exists(pBenefit[4]))then
			logMsg("--> Immunity")
			return "Immunity"
		else
			return "."
		end
	elseif(spDungeon == "Wrath")then
		
		if(glyphTypeRegion:exists(pWrath[1]))then
			logMsg("--> Haste")
			return "Haste"
		elseif(glyphTypeRegion:exists(pWrath[2]))then
			logMsg("--> Lifesteal")
			return "Lifesteal"
		elseif(glyphTypeRegion:exists(pWrath[3]))then
			logMsg("--> Precision")
			return "Precision"
		elseif(glyphTypeRegion:exists(pWrath[4]))then
			logMsg("--> Appeasement")
			return "Appeasement"
		else
			return "."
		end
	elseif(spDungeon == "Strength")then

		if(glyphTypeRegion:exists(pStrenght[1]))then
			logMsg("--> Strength")
			return "Strength"
		elseif(glyphTypeRegion:exists(pStrenght[2]))then
			logMsg("--> Frenzy")
			return "Frenzy"
		elseif(glyphTypeRegion:exists(pStrenght[3]))then
			logMsg("--> Destruction")
			return "Destruction"
		elseif(glyphTypeRegion:exists(pStrenght[4]))then
			logMsg("--> Meditation")
			return "Meditation"
		else
			return "."
		end
	else
		if(glyphTypeRegion:exists(pStrenght[1]))then
			logMsg("--> Strength")
			return "Strength"
		elseif(glyphTypeRegion:exists(pStrenght[2]))then
			logMsg("--> Frenzy")
			return "Frenzy"
		elseif(glyphTypeRegion:exists(pStrenght[3]))then
			logMsg("--> Destruction")
			return "Destruction"
		elseif(glyphTypeRegion:exists(pStrenght[4]))then
			logMsg("--> Meditation")
			return "Meditation"
		elseif(glyphTypeRegion:exists(pWrath[1]))then
			logMsg("--> Haste")
			return "Haste"
		elseif(glyphTypeRegion:exists(pWrath[2]))then
			logMsg("--> Lifesteal")
			return "Lifesteal"
		elseif(glyphTypeRegion:exists(pWrath[3]))then
			logMsg("--> Precision")
			return "Precision"
		elseif(glyphTypeRegion:exists(pWrath[4]))then
			logMsg("--> Appeasement")
			return "Appeasement"
		elseif(glyphTypeRegion:exists(pBenefit[1]))then
			logMsg("--> Vitality")
			return "Vitality"
		elseif(glyphTypeRegion:exists(pBenefit[2]))then
			logMsg("--> Defense")
			return "Defense"
		elseif(glyphTypeRegion:exists(pBenefit[3]))then
			logMsg("--> Endurance")
			return "Endurance"
		elseif(glyphTypeRegion:exists(pBenefit[4]))then
			logMsg("--> Immunity")
			return "Immunity"
		else
			return "."
		end
	end

end

function arena()
	if not(arenaCb)then
		oOPvpEnergy = true
		return
	elseif(spDungeon == "Current")then
		oOPvpEnergy = true
		return
	end

	toast("Running Arena")
	logMsg("Running Arena")
	wait(1)
	if(arena0Energy_region:exists(Pattern("arena0Energy.png"):similar(1.0)))then
		logMsg("Out of Pvp energy!")
		toast("Out of Pvp energy!")
		oOPvpEnergy = true
		return
	end
	swipeLeft()
	wait(2)
	while not(homeArenaBtn_region:exists(Pattern("homeArenaBtn.png"):similar(acc))) do
		wait(1)
	end
	clickRandom(homeArenaBtn_region)
	
	
	while(oOPvpEnergy == false)do
		while not(arenaStartBtn_region:exists(Pattern("arenaStartBtn.png"):similar(acc))) do
			wait(1)
		end
		while (arenaStartBtn_region:exists(Pattern("arenaStartBtn.png"):similar(acc)) and checkEnergy() == false) do
			clickRandom(arenaStartBtn_region)
			wait(1)
		end
		
		wait(1)
		if(checkEnergy()) then
			if(refillPvpCb) then
				refillPvpEnergy()
				wait(1)
			else
				setExitStats("")
				oOPvpEnergy = true
				logMsg("Out of Pvp energy!")
				toast("Out of Pvp energy!")
				return
			end
		end
		
		while not(arenaStartBtn2_region:exists(Pattern("arenaStartBtn2.png"):similar(acc))) do
			wait(1)
		end
		while(arenaStartBtn2_region:exists(Pattern("arenaStartBtn2.png"):similar(acc))) do
			clickRandom(arenaStartBtn2_region)
			wait(1)
		end
		
		

		
		wait(.5)
		logMsg("Starting Arena Match")
		while not(farmGearBtn_region:exists(Pattern("farmGearBtn.png"):similar(acc))) do
			wait(1)
		end
		
		while(farmAutoDisabledBtn_region:exists(Pattern("farmAutoDisabledBtn.png"):similar(acc))) do
			repeat
				wait(1)
				clickRandom(farmAutoDisabledBtn_region)
			until not(farmAutoDisabledBtn_region:exists(Pattern("farmAutoDisabledBtn.png"):similar(acc)))
		end
		
		arenaCount = arenaCount + 1
		setExitStats("")
		setResultsOs()

		repeat
			wait(searchSpeed())
			
			toast("Looking for result...")
	
		until(arenaVictory_region:exists(Pattern("arenaVictory.png"):similar(acc)) or arenaDefeat_region:exists(Pattern("arenaDefeat.png"):similar(acc)) or arenaMilestoneLoot_region:exists(Pattern("arenaMilestoneLoot.png"):similar(acc)))
		
		if(arenaVictory_region:exists(Pattern("arenaVictory.png"):similar(acc))) then

			toast("Win")
			logMsg("Arena - Win")
			arenaWinCount = arenaWinCount + 1
			if(arenaMilestoneLoot_region:exists(Pattern("arenaMilestoneLoot.png"):similar(acc))) then
				logMsg("Milestone reached!")
				while not(arenaLootBtn_region:exists(Pattern("arenaLootBtn.png"):similar(acc))) do
					wait(1)
				end
				clickRandom(arenaLootBtn_region)
			end
		elseif(arenaDefeat_region:exists(Pattern("arenaDefeat.png"):similar(acc))) then
			toast("Lose")
			logMsg("Arena - Lose")
			arenaLoseCount = arenaLoseCount + 1
		elseif(arenaMilestoneLoot_region:exists(Pattern("arenaMilestoneLoot.png"):similar(acc))) then

			toast("Win")
			logMsg("Arena - Win")
			arenaWinCount = arenaWinCount + 1
			logMsg("Milestone reached!")
			while not(arenaLootBtn_region:exists(Pattern("arenaLootBtn.png"):similar(acc))) do
				wait(1)
			end
			clickRandom(arenaLootBtn_region)
			
		end
		setExitStats("")
		setResultsOs()
		clickRandomReg(screenReg)
	end
end


if not(file_exists(scriptPath.."runs.csv"))then
	local file = io.open(scriptPath.."runs.csv", "a")
	file:write("Time, Dungeon, Stage, Runtime, Win, Loot, Type, Rarity, Set, Sell\n")
	file:close()			
end



wait(1)


showConfigDialog()
setConfig()
updateScript()
logMsg(" ")
logMsg("****    MMEG Helper v"..version.." started    ****")
toast("MM Helper v"..version.." started")
wait(1)
setExitStats("")
setResultsOs()


while true do
	if(dimScreenCb == true) then
		setBrightness(0)
	end
	arena()
	
	if(spDungeon ~= "Current")then
		returnHome()
	end
	
	findDungeon()
	wait(1)

	waitForBattle()
	while(oOEnergy == false and toArena == false)do
		waitForResult()
		replay()
	end
	toArena = false
	
	if(spDungeon == "Current")then
		setExitStats("Out of Energy!")
		scriptExit()
	end
	returnHome()
	
	if(idle == false and oOEnergy == true) then
			t = Timer()
			idle = true
	end

	if(idle == true and oOEnergy == true) then
		setBrightness(0)
		logMsg("idling for 60 min to wait for energy...")
		repeat
			local tmp = 5
			sec = t:check()
			message = "Idle ON: "..SecondsToClock(sec).." min"
			if(tmp >= 5)then
				logMsg(message)
				tmp = 0
			end
			setHighlightTextStyle(0x8ff2f2f2, textColor, 24)
			screenCenterReg:highlight(message, maxSearchSpeed)
			setExitStats("")

			if(sec >= 3600) then
				idle = false
				oOEnergy = false
				oOPvpEnergy = false

				if(dimScreenCb == false) then
					setBrightness(savedBrightness)
				end
				wait(.5)

				screenCenterReg:highlightOff()

			end
		until(idle == false)
	end
	
end