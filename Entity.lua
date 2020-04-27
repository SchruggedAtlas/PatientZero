require "class"

Entity = class(
  function(a, name)
    a.name = name
  end
)

function Entity:randomf(min, max, precision)
  return love.math.random(min,max)/precision
end

function Entity:set_direction(min,max,precision,speed)
  self.xdir = Entity:randomf(min,max,precision)*speed
  self.ydir = Entity:randomf(min,max,precision)*speed
end

function Entity:init(xpos,ypos,radius,screen_w,screen_h)
  self.xpos = xpos
  self.ypos = ypos
  self.screen_w = screen_w
  self.screen_h = screen_h
  self.radius = radius
  self.color = susceptible
  self.total_time = 0
end

function Entity:setColor(color)
  if self.color == susceptible and color == infectious then
    self.start = love.timer.getTime()
  end
  self.color = color
end

function Entity:keepInScreen()
  -- check for collision with sides
  if self.xpos > self.screen_w - self.radius then
    self.xpos = self.screen_w - self.radius
    self.xdir = -1*self.xdir
  elseif self.xpos < 0 then
    self.xpos = 0
    self.xdir = -1*self.xdir
  end
  -- check for collision with top/bottom
  if self.ypos > self.screen_h - self.radius then
    self.ypos = self.screen_h - self.radius
    self.ydir = -1*self.ydir
  elseif self.ypos < 0 then
    self.ypos = 0
    self.ydir = -1*self.ydir
  end
end

function Entity:update()
  -- update postion in X and Y
  self.xpos = self.xpos + self.xdir + Entity:randomf(-100.0,100.0,100.0)
  self.ypos = self.ypos + self.ydir + Entity:randomf(-100.0,100.0,100.0)
  -- in this section, the entity gets better or dies
  if self.color == infectious then
    self.total_time = love.timer.getTime() - self.start
    if self.total_time > 10.0 then
      self.color = removed
    end
  end
end

function Entity:draw()
  love.graphics.setColor(self.color)
  love.graphics.rectangle("fill",self.xpos,self.ypos,self.radius,self.radius)
end
