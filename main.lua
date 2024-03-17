Input = require 'libraries/boipushy/Input'
anim8 = require 'libraries.anim8.anim8'
UP    = "up"
LEFT  = "left"
RIGHT = "right"
DOWN  = "down"

function love.load()
    input = Input()
    TITLE = "Frogger"
    lanes = 	{ 
    {0.0,  "wwwhhwwwhhwwwhhwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww"}, -- 64 elements per lanes
    {-3.0, ",,,jllk,,jllllk,,,,,,,jllk,,,,,jk,,,jlllk,,,,jllllk,,,,jlllk,,,,"}, 
    {3.0,  ",,,,jllk,,,,,jllk,,,,jllk,,,,,,,,,jllk,,,,,jk,,,,,,jllllk,,,,,,,"},
    {2.0,  ",,jlk,,,,,jlk,,,,,jk,,,,,jlk,,,jlk,,,,jk,,,,jllk,,,,jk,,,,,,jk,,"},
    {0.0,  "pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp"},
    {-3.0, "....dddf.......dddf....dddf..........dddf........dddf....dddf..."},
    { 3.0, ".....ty..ty....ty....ty.....ty........ty..ty.ty......ty.......ty"},
    {-4.0, "..zz.....zz.........zz..zz........zz...zz...zz....zz...zz...zz.."},		
    {2.0,  "..ty.....ty.......ty.....ty......ty..ty.ty.......ty....ty......."},
    {0.0,  "pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp"}
    }

    WIDTH = 128
    HEIGHT = 80
    UNIT_SIZE = 8
    SCREEN_WIDTH = WIDTH * UNIT_SIZE
    SCREEN_HEIGHT = HEIGHT * UNIT_SIZE
    fTimeSinceStart = 0.0
    fFrogX = 8.0
    fFrogY = 9.0
    nLaneWidth = 17
    nCellSize = 8
    bufDanger = {}
    for i = 1, WIDTH * HEIGHT do
        table.insert(bufDanger, false)
    end

    input = Input()
    input:bind('left', 'left')
    input:bind('up', 'up')
    input:bind('right', 'right')
    input:bind('down', 'down')
    input:bind('escape', 'escape')
    input:bind('r', 'r')

    love.window.setTitle(TITLE)
    love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT)

    FROG_IMG = love.graphics.newImage("assets/sprite/frog.png")
    iFrogLeft  = love.graphics.newQuad(0  , 0, 64, 64, FROG_IMG)
    iFrogUp    = love.graphics.newQuad(64 , 0, 64, 64, FROG_IMG)
    iFrogRight = love.graphics.newQuad(128, 0, 64, 64, FROG_IMG)
    iFrogDown  = love.graphics.newQuad(192, 0, 64, 64, FROG_IMG)
    iDeadFrogLeft  = love.graphics.newQuad(0  , 64, 64, 64, FROG_IMG)
    iDeadFrogUp    = love.graphics.newQuad(64 , 64, 64, 64, FROG_IMG)
    iDeadFrogRight = love.graphics.newQuad(128, 64, 64, 64, FROG_IMG)
    iDeadFrogDown  = love.graphics.newQuad(192, 64, 64, 64, FROG_IMG)
    iWinLeftFrog   = love.graphics.newQuad(0  , 128, 64, 64, FROG_IMG)
    iWinRightFrog  = love.graphics.newQuad(64  ,128, 64, 64, FROG_IMG)

    MELTING_FROG_IMG = love.graphics.newImage("assets/sprite/melting_frog.png")
    meltingFrogGrid = anim8.newGrid(64, 64, MELTING_FROG_IMG:getWidth(), MELTING_FROG_IMG:getHeight())
    aMeltFrogL = anim8.newAnimation(meltingFrogGrid("1-4",  1), .5, "pauseAtEnd")
    aMeltFrogU = anim8.newAnimation(meltingFrogGrid("1-4",  2), .5, "pauseAtEnd")
    aMeltFrogR = anim8.newAnimation(meltingFrogGrid("1-4",  3), .5, "pauseAtEnd")
    aMeltFrogD = anim8.newAnimation(meltingFrogGrid("1-4",  4), .5, "pauseAtEnd")

    CARS_IMG = love.graphics.newImage("assets/sprite/cars.png")
    iCar0 = love.graphics.newQuad(0  , 0, 64, 64, CARS_IMG)
    iCar1 = love.graphics.newQuad(64 , 0, 64, 64, CARS_IMG)
    iCar2 = love.graphics.newQuad(128, 0, 64, 64, CARS_IMG)
    iCar30= love.graphics.newQuad(192, 0, 64, 64, CARS_IMG)
    iCar31= love.graphics.newQuad(255, 0, 64, 64, CARS_IMG)    

    LOGS_IMG = love.graphics.newImage("assets/sprite/logs.png")
    iLog0 = love.graphics.newQuad(0  , 128, 64, 64, LOGS_IMG)
    iLog1 = love.graphics.newQuad(64 , 128, 64, 64, LOGS_IMG)
    iLog2 = love.graphics.newQuad(128, 128, 64, 64, LOGS_IMG)

    TILES_IMG = love.graphics.newImage("assets/sprite/tiles.png")
    iRock = love.graphics.newQuad(0, 0, 64, 64, TILES_IMG)
    iWater = love.graphics.newQuad(0, 64, 64, 64, TILES_IMG)
    iRoad0 = love.graphics.newQuad(256, 0, 64, 64, TILES_IMG)
    iRoad1 = love.graphics.newQuad(192, 0, 64, 64, TILES_IMG)
    iRoad2 = love.graphics.newQuad(64, 0, 64, 64, TILES_IMG)
    iRoad3 = love.graphics.newQuad(320, 0, 64, 64, TILES_IMG)
    iGrass = love.graphics.newQuad(192, 64, 64, 64, TILES_IMG)
    iLeftWin = love.graphics.newQuad(256, 64, 64, 64, TILES_IMG)
    iRightWin = love.graphics.newQuad(320, 64, 64, 64, TILES_IMG)

    cFrog = {}
    cFrog.direction = UP
    cFrog.isLife = true
    cFrog.isMelted = false

    sounds = {}
    sounds.extra = love.audio.newSource("assets/sfx/frogger-extra.wav", "static")
    sounds.extra:setVolume(1)
    sounds.plunk = love.audio.newSource("assets/sfx/frogger-plunk.wav", "static")
    sounds.plunk:setVolume(1)
    sounds.squash = love.audio.newSource("assets/sfx/frogger-squash.wav", "static")
    sounds.squash:setVolume(1)
end

function love.update(dt)
    fTimeSinceStart = fTimeSinceStart + dt
    checkCollisionWithCars()
    checkCollisionWithLogs(dt)

    if input:released("up") and cFrog.isLife then
        fFrogY = fFrogY - 1
        cFrog.direction = UP
        checkWinner()
    end
    if input:released("right") and cFrog.isLife then
        fFrogX = fFrogX + 1
        cFrog.direction = RIGHT
    end
    if input:released("left") and cFrog.isLife then
        fFrogX = fFrogX - 1
        cFrog.direction = LEFT
    end
    if input:released("down") and cFrog.isLife then 
        fFrogY = fFrogY + 1
        cFrog.direction = DOWN
    end
    if input:released("escape") and cFrog.isLife then 
        love.event.quit()
    end

    if input:released("r") and not cFrog.isLife then 
        cFrog.direction = UP
        cFrog.isLife = true
        cFrog.isMelted = false
        fFrogX = 8.0
        fFrogY = 9.0
        aMeltFrogL = anim8.newAnimation(meltingFrogGrid("1-4",  1), .5, "pauseAtEnd")
        aMeltFrogU = anim8.newAnimation(meltingFrogGrid("1-4",  2), .5, "pauseAtEnd")
        aMeltFrogR = anim8.newAnimation(meltingFrogGrid("1-4",  3), .5, "pauseAtEnd")
        aMeltFrogD = anim8.newAnimation(meltingFrogGrid("1-4",  4), .5, "pauseAtEnd")
    end
    clampFrog()

    if cFrog.isMelted then
        aMeltFrogL:update(dt)
        aMeltFrogU:update(dt)
        aMeltFrogR:update(dt)
        aMeltFrogD:update(dt)
    end
end

function love.draw()
    drawBackground()
    drawLogs()
    drawFrog()
    local x = -1 
    local y = 0        
    for key, lane in ipairs(lanes) do
        local nStartPos = math.floor(fTimeSinceStart * lane[1]) % 64
        local nCellOffset = math.floor(nCellSize * fTimeSinceStart * lane[1]) % 8
        local nReminder = nCellSize * fTimeSinceStart * lane[1] - math.floor(nCellSize * fTimeSinceStart * lane[1])
        nReminder = round(nReminder, 3)
        nCellOffset = nCellOffset + nReminder
        
        if nStartPos < 0 then 
            nStartPos = 64 - (math.abs(nStartPos) % 64)
        end
        for idx = 0, nLaneWidth do
            local graphic = lane[2]:sub(((nStartPos + (idx+1)) % 64), ((nStartPos + (idx+1)) % 64))
            if graphic == ',' then

            elseif graphic == "t" then
                love.graphics.setColor(1, 1, 1)
                love.graphics.draw(CARS_IMG, iCar0, (((x + idx)*nCellSize  - nCellOffset) * UNIT_SIZE) , y * nCellSize * UNIT_SIZE)
            elseif graphic == "y" then
                love.graphics.setColor(1, 1, 1)
                love.graphics.draw(CARS_IMG, iCar1, (((x + idx)*nCellSize  - nCellOffset) * UNIT_SIZE) , y * nCellSize * UNIT_SIZE)
            elseif graphic == "z" then
                love.graphics.setColor(1, 1, 1)
                love.graphics.draw(CARS_IMG, iCar2, (((x + idx)*nCellSize  - nCellOffset) * UNIT_SIZE) , y * nCellSize * UNIT_SIZE)
            elseif graphic == "d" then
                love.graphics.setColor(1, 1, 1)
                love.graphics.draw(CARS_IMG, iCar31, (((x + idx)*nCellSize  - nCellOffset) * UNIT_SIZE) , y * nCellSize * UNIT_SIZE)
            elseif graphic == "f" then
                love.graphics.setColor(1, 1, 1)
                love.graphics.draw(CARS_IMG, iCar30, (((x + idx)*nCellSize  - nCellOffset) * UNIT_SIZE) , y * nCellSize * UNIT_SIZE)
            elseif graphic == "a" then    
                love.graphics.setColor(1, 1, 1)
                --love.graphics.draw(CARS_IMG, iCar30, (((x + idx)*nCellSize  - nCellOffset) * UNIT_SIZE) , y * nCellSize * UNIT_SIZE)
                love.graphics.draw(FROG_IMG, iWinLeftFrog, (((x + idx)*nCellSize  - nCellOffset) * UNIT_SIZE) , y * nCellSize * UNIT_SIZE)
            elseif graphic == "b" then    
                love.graphics.setColor(1, 1, 1)
                love.graphics.draw(FROG_IMG, iWinRightFrog, (((x + idx)*nCellSize  - nCellOffset) * UNIT_SIZE) , y * nCellSize * UNIT_SIZE)
            elseif graphic == "w" then
                love.graphics.draw(TILES_IMG, iGrass, (((x + idx)*nCellSize  - nCellOffset) * UNIT_SIZE) , y * nCellSize * UNIT_SIZE)
            end
        end
        y = y + 1
    end
end

function love.run()
    if love.math then love.math.setRandomSeed(os.time()) end
    if love.load then love.load(arg) end
    if love.timer then love.timer.step() end

    local dt = 0
    local fixed_dt = 1/60
    local accumulator = 0

    while true do
        if love.event then
            love.event.pump()
            for name, a, b, c, d, e, f in love.event.poll() do
                if name == 'quit' then
                    if not love.quit or not love.quit() then
                        return a
                    end
                end
                love.handlers[name](a, b, c, d, e, f)
            end
        end

        if love.timer then
            love.timer.step()
            dt = love.timer.getDelta()
        end

        accumulator = accumulator + dt
        while accumulator >= fixed_dt do
            if love.update then love.update(fixed_dt) end
            accumulator = accumulator - fixed_dt
        end

        if love.graphics and love.graphics.isActive() then
            love.graphics.clear(love.graphics.getBackgroundColor())
            love.graphics.origin()
            if love.draw then love.draw() end
            love.graphics.present()
        end

        if love.timer then love.timer.sleep(0.001) end
    end
end

function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function drawFrog()
    love.graphics.setColor(1, 1, 1)
    if cFrog.direction == UP then
        if cFrog.isLife then
            love.graphics.draw(FROG_IMG, iFrogUp, fFrogX * nCellSize * UNIT_SIZE, fFrogY * nCellSize * UNIT_SIZE)
        elseif not cFrog.isMelted then
            love.graphics.draw(FROG_IMG, iDeadFrogUp, fFrogX * nCellSize * UNIT_SIZE, fFrogY * nCellSize * UNIT_SIZE)
        else
            aMeltFrogU:draw(MELTING_FROG_IMG, fFrogX * nCellSize * UNIT_SIZE, fFrogY * nCellSize * UNIT_SIZE)
        end
    elseif cFrog.direction == RIGHT then
        if cFrog.isLife then
            love.graphics.draw(FROG_IMG, iFrogRight, fFrogX * nCellSize * UNIT_SIZE, fFrogY * nCellSize * UNIT_SIZE)  
        elseif not cFrog.isMelted then
            love.graphics.draw(FROG_IMG, iDeadFrogRight, fFrogX * nCellSize * UNIT_SIZE, fFrogY * nCellSize * UNIT_SIZE)  
        else
            aMeltFrogR:draw(MELTING_FROG_IMG, fFrogX * nCellSize * UNIT_SIZE, fFrogY * nCellSize * UNIT_SIZE)
        end
    elseif cFrog.direction == DOWN then
        if cFrog.isLife then
            love.graphics.draw(FROG_IMG, iFrogDown, fFrogX * nCellSize * UNIT_SIZE, fFrogY * nCellSize * UNIT_SIZE)
        elseif not cFrog.isMelted then
            love.graphics.draw(FROG_IMG, iDeadFrogDown, fFrogX * nCellSize * UNIT_SIZE, fFrogY * nCellSize * UNIT_SIZE)
        else
            aMeltFrogD:draw(MELTING_FROG_IMG, fFrogX * nCellSize * UNIT_SIZE, fFrogY * nCellSize * UNIT_SIZE)
        end
    elseif cFrog.direction == LEFT then
        if cFrog.isLife then
            love.graphics.draw(FROG_IMG, iFrogLeft, fFrogX * nCellSize * UNIT_SIZE, fFrogY * nCellSize * UNIT_SIZE)
        elseif not cFrog.isMelted then
            love.graphics.draw(FROG_IMG, iDeadFrogLeft, fFrogX * nCellSize * UNIT_SIZE, fFrogY * nCellSize * UNIT_SIZE)
        else
            aMeltFrogD:draw(MELTING_FROG_IMG, fFrogX * nCellSize * UNIT_SIZE, fFrogY * nCellSize * UNIT_SIZE)
        end
    end
end

function drawBackground()  
    for x = 0, nLaneWidth do
        love.graphics.draw(TILES_IMG, iWater, x * nCellSize * nCellSize, 0 * nCellSize * UNIT_SIZE)
        love.graphics.draw(TILES_IMG, iWater, x * nCellSize * nCellSize, 1 * nCellSize * UNIT_SIZE)
        love.graphics.draw(TILES_IMG, iWater, x * nCellSize * nCellSize, 2 * nCellSize * UNIT_SIZE)
        love.graphics.draw(TILES_IMG, iWater, x * nCellSize * nCellSize, 3 * nCellSize * UNIT_SIZE)
        love.graphics.draw(TILES_IMG, iRock, x * nCellSize * nCellSize,  4 * nCellSize * UNIT_SIZE)
        love.graphics.draw(TILES_IMG, iRoad0, x * nCellSize * nCellSize, 5 * nCellSize * UNIT_SIZE)
        love.graphics.draw(TILES_IMG, iRoad1, x * nCellSize * nCellSize, 6 * nCellSize * UNIT_SIZE)
        love.graphics.draw(TILES_IMG, iRoad2, x * nCellSize * nCellSize, 7 * nCellSize * UNIT_SIZE)
        love.graphics.draw(TILES_IMG, iRoad3, x * nCellSize * nCellSize, 8 * nCellSize * UNIT_SIZE)
        love.graphics.draw(TILES_IMG, iRock, x * nCellSize * nCellSize,  9 * nCellSize * UNIT_SIZE)
    end
    --wwwhhwwwhhwwwhhwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww

    --Win Place
    love.graphics.draw(TILES_IMG, iLeftWin, 2 * nCellSize * nCellSize, 0)
    love.graphics.draw(TILES_IMG, iRightWin, 3 * nCellSize * nCellSize, 0)
    --
    --Win Place
    love.graphics.draw(TILES_IMG, iLeftWin, 7 * nCellSize * nCellSize, 0)
    love.graphics.draw(TILES_IMG, iRightWin, 8 * nCellSize * nCellSize, 0)
    --
    ---Win Place
    love.graphics.draw(TILES_IMG, iLeftWin, 12 * nCellSize * nCellSize, 0)
    love.graphics.draw(TILES_IMG, iRightWin, 13 * nCellSize * nCellSize, 0)
    ---

end

function clampFrog()
    if fFrogX < 0 then
        fFrogX = 0
    elseif fFrogX >= nLaneWidth - 1 then
        fFrogX = nLaneWidth - 2
    elseif fFrogY >= #lanes - 1 then
        fFrogY = #lanes - 1
    elseif fFrogY < 0 then
        fFrogY = 0
    end
end

function checkCollisionWithCars()
    local x = -1
    local y = 0
    for key, lane in ipairs(lanes) do
        if not cFrog.isLife then
            return
        end
        local nStartPos = math.floor(fTimeSinceStart * lane[1]) % 64
        local nCellOffset = math.floor(nCellSize * fTimeSinceStart * lane[1]) % 8
        local nReminder = nCellSize * fTimeSinceStart * lane[1] - math.floor(nCellSize * fTimeSinceStart * lane[1])
        nReminder = round(nReminder, 3)
        nCellOffset = nCellOffset + nReminder
        
        if nStartPos < 0 then 
            nStartPos = 64 - (math.abs(nStartPos) % 64)
        end
        for idx = 0, nLaneWidth do
            local graphic = lane[2]:sub(((nStartPos + (idx+1)) % 64), ((nStartPos + (idx+1)) % 64))
            if graphic == "t" or graphic == "z" or graphic == "d" or graphic == "f" then
                local nTileX  = (((x + idx)*nCellSize  - nCellOffset) * UNIT_SIZE)
                local nTileY  = y * nCellSize * UNIT_SIZE
                local nWidth  = nCellSize * UNIT_SIZE
                local nHeight = nCellSize * UNIT_SIZE
                local nFrogX  = fFrogX * nCellSize * UNIT_SIZE
                local nFrogY  = fFrogY  * nCellSize * UNIT_SIZE
                if nFrogX < nTileX + nWidth and nFrogX + nWidth > nTileX
                    and nFrogY < nTileY + nHeight and nFrogY + nHeight > nTileY then
                        sounds.squash:play()
                        cFrog.isLife = false
                end
            end
        end

        y = y + 1
    end
end

function checkCollisionWithLogs(dt)
    local x = -1
    local y = 0
    for key, lane in ipairs(lanes) do
        if not cFrog.isLife then
            return
        end
        local nStartPos = math.floor(fTimeSinceStart * lane[1]) % 64
        local nCellOffset = math.floor(nCellSize * fTimeSinceStart * lane[1]) % 8
        local nReminder = nCellSize * fTimeSinceStart * lane[1] - math.floor(nCellSize * fTimeSinceStart * lane[1])
        nReminder = round(nReminder, 3)
        nCellOffset = nCellOffset + nReminder
        
        if nStartPos < 0 then 
            nStartPos = 64 - (math.abs(nStartPos) % 64)
        end

        if fFrogY <= 3 then 
            for idx = 0, nLaneWidth do
                local graphic = lane[2]:sub(((nStartPos + (idx+1)) % 64), ((nStartPos + (idx+1)) % 64))
                local isOnLog = false
                if graphic == "j" or graphic == "k" then
                    local nTileX  = (((x + idx)*nCellSize  - nCellOffset) * UNIT_SIZE)
                    local nTileY  = y * nCellSize * UNIT_SIZE
                    local nWidth  = nCellSize * UNIT_SIZE
                    local nHeight = nCellSize * UNIT_SIZE
                    local nFrogX  = fFrogX * nCellSize * UNIT_SIZE
                    local nFrogY  = fFrogY  * nCellSize * UNIT_SIZE
                    if nFrogX < nTileX + nWidth and nFrogX + nWidth > nTileX
                        and nFrogY < nTileY + nHeight and nFrogY + nHeight > nTileY then
                            fFrogX = fFrogX - round(dt * lane[1], 3)
                            isOnLog = true
                    end
                elseif graphic == "l" then
                    local nTileX  = (((x + idx)*nCellSize  - nCellOffset) * UNIT_SIZE)
                    local nTileY  = y * nCellSize * UNIT_SIZE
                    local nWidth  = nCellSize * UNIT_SIZE
                    local nHeight = nCellSize * UNIT_SIZE
                    local nFrogX  = fFrogX * nCellSize * UNIT_SIZE
                    local nFrogY  = fFrogY  * nCellSize * UNIT_SIZE
                    if nFrogX < nTileX + nWidth and nFrogX + nWidth > nTileX
                        and nFrogY < nTileY + nHeight and nFrogY + nHeight > nTileY then
                            fFrogX = fFrogX - round(dt / 2 * lane[1], 3)
                            isOnLog = true
                    end
                elseif graphic == "," then 
                    local nTileX  = (((x + idx)*nCellSize  - nCellOffset) * UNIT_SIZE)
                    local nTileY  = y * nCellSize * UNIT_SIZE
                    local nWidth  = nCellSize * UNIT_SIZE - 15
                    local nHeight = nCellSize * UNIT_SIZE - 15
                    local nFrogX  = fFrogX * nCellSize * UNIT_SIZE 
                    local nFrogY  = fFrogY  * nCellSize * UNIT_SIZE
                    if nFrogX < nTileX + nWidth and nFrogX + nWidth > nTileX
                        and nFrogY < nTileY + nHeight and nFrogY + nHeight > nTileY and not isOnLog then
                            sounds.plunk:play()
                            cFrog.isLife = false
                            cFrog.isMelted = true
                    end
                end
            end
        end
        

        y = y + 1
    end
end

function checkWinner()
    if fFrogY == 0 then
        if lanes[1][2]:sub(math.floor(fFrogX+1), math.floor(fFrogX+1)) == "w" then
            fFrogY = fFrogY + 1
        else
            --first gap
            if (math.floor(fFrogX + 1)) == 4 or (math.floor(fFrogX + 1)) == 5 then
                local firstPart  =  lanes[1][2]:sub(1, 3)
                local secondPart =  lanes[1][2]:sub(6, #lanes[1][2])
                lanes[1][2] = firstPart .. "ab" .. secondPart
                fFrogX = 8.0
                fFrogY = 9.0
                sounds.extra:play()
            --second gap
            elseif (math.floor(fFrogX + 1)) == 9 or math.floor(fFrogX + 1) == 10 then
                local firstPart  =  lanes[1][2]:sub(1, 8)
                local secondPart =  lanes[1][2]:sub(11, #lanes[1][2])
                lanes[1][2] = firstPart .. "ab" .. secondPart
                fFrogX = 8.0
                fFrogY = 9.0
                sounds.extra:play()
            --third gap
            elseif math.floor(fFrogX + 1) == 14 or math.floor(fFrogX + 1) == 15 then   
                local firstPart  =  lanes[1][2]:sub(1, 13)
                local secondPart =  lanes[1][2]:sub(16, #lanes[1][2])
                lanes[1][2] = firstPart .. "ab" .. secondPart
                fFrogX = 8.0
                fFrogY = 9.0
                sounds.extra:play()
            end
        end
    end
end

function drawLogs()
    local x = -1 
    local y = 0        
    for key, lane in ipairs(lanes) do
        local nStartPos = math.floor(fTimeSinceStart * lane[1]) % 64
        local nCellOffset = math.floor(nCellSize * fTimeSinceStart * lane[1]) % 8
        local nReminder = nCellSize * fTimeSinceStart * lane[1] - math.floor(nCellSize * fTimeSinceStart * lane[1])
        nReminder = round(nReminder, 3)
        nCellOffset = nCellOffset + nReminder
        
        if nStartPos < 0 then 
            nStartPos = 64 - (math.abs(nStartPos) % 64)
        end
        for idx = 0, nLaneWidth do
            local graphic = lane[2]:sub(((nStartPos + (idx+1)) % 64), ((nStartPos + (idx+1)) % 64))
            if graphic == 'j' then
                love.graphics.setColor(1, 1, 1)
                love.graphics.draw(LOGS_IMG, iLog0, (((x + idx)*nCellSize  - nCellOffset) * UNIT_SIZE) , y * nCellSize * UNIT_SIZE)
            elseif graphic == 'l' then
                love.graphics.setColor(1, 1, 1)
                love.graphics.draw(LOGS_IMG, iLog1, (((x + idx)*nCellSize  - nCellOffset) * UNIT_SIZE) , y * nCellSize * UNIT_SIZE)
            elseif graphic == 'k' then
                love.graphics.setColor(1, 1, 1)
                love.graphics.draw(LOGS_IMG, iLog2, (((x + idx)*nCellSize  - nCellOffset) * UNIT_SIZE) , y * nCellSize * UNIT_SIZE)
            end
        end
        y = y + 1
    end
end