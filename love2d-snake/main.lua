function dead()
    return x < 0 or x >= w or y < 0 or y >= h or taken(x, y)
end

function eaten()
    return x == fx and y == fy
end

function taken(xx, yy)
    for i = 1, #body do
        if body[i] == {xx, yy} then
            return true
        end
    end
    return false
end

function food()
    local fx = math.random(0, w - 1)
    local fy = math.random(0, h - 1)
    while taken(fx, fy) do
        fx = math.random(0, w - 1)
        fy = math.random(0, h - 1)
    end
    return fx, fy
end

function love.load()
    s = 10
    w, h = 15, 15
    love.window.setMode(w * s, h * s, {resizable = false})
    x, y = 0, 0
    body = {{x, y}}
    fx, fy = food()
    tx, ty = x, y
    dir = {
        {1, 0}, -- right
        {-1, 0}, -- left
        {0, -1}, -- up
        {0, 1}, -- down
    }
    curdir = 1
    nextdir = 1
    last = 0
    fps = 3
    score = 0
    math.randomseed(os.time())
end

function love.update(dt)
    if love.keyboard.isDown("up") and curdir ~= 4 then
        nextdir = 3
    elseif love.keyboard.isDown("down") and curdir ~= 3 then
        nextdir = 4
    elseif love.keyboard.isDown("left") and curdir ~= 1 then
        nextdir = 2
    elseif love.keyboard.isDown("right") and curdir ~= 2 then
        nextdir = 1
    end

    last = last + dt
    if 1/fps > last then
        return
    end
    last = 0

    if dead() then
        print("dead, score:", score)
        return
    end

    if eaten() then
        score = score + 1
        table.insert(body, {tx, ty})
        fx, fy = food()
    end

    curdir = nextdir
    x = x + dir[curdir][1]
    y = y + dir[curdir][2]

    passed = table.remove(body, #body)
    tx, ty = passed[1], passed[2]
    table.insert(body, 1, {x, y})
end

function love.draw()
    for i = 1, #body do
        love.graphics.rectangle("fill", body[i][1] * s, body[i][2] * s, s, s)
    end
    love.graphics.rectangle("fill", fx * s, fy * s, s, s)
end
