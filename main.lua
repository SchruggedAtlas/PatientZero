require "Entity"
require "Entities"

function love.load()
  love.window.setMode(0,0, {vsync=true})
  screen_w = love.graphics.getWidth()
  screen_h = love.graphics.getHeight()
  num_participants = 50000
  total_time = 0
  entities = Entities()
  entities:init(num_participants,screen_w,screen_h)
  love.window.setFullscreen(true, "desktop")
  print(tostring(screen_w)..":"..tostring(screen_h))
end

function love.keypressed(key)
  if key == "escape" then
    love.event.push("quit")
  end
  if key == "i" then
    love.graphics.setColor(susceptible)
    total_time = 0
    entities = Entities()
    entities:init(num_participants,screen_w,screen_h)
  end
end

function love.update(dt)
  total_time = total_time + dt
  entities:update(total_time)
  entities:checkForCollisions(total_time)
end

function love.draw()
  entities:draw()
end
