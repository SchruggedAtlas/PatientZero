require "class"
require "Entity"

Entities = class(
  function(a, name)
    a.name = name
  end
)

function Entities:init(num,width,height)
  self.entities = {}
  self.pzero = false
  self.num_entities = num
  self.radius = 4
  self.center_w = width/2
  self.center_h = height/2
  self.dmin = -100.0
  self.dmax = 100.0
  self.precision = 1000.0
  self.speed = 6
  self.summary = {}
  self.impact = love.audio.newSource("sound83.wav", "static")
  self.font = love.graphics.newFont("Courier Prime.ttf", 24)
  self.report_time = 0
  love.graphics.setFont(self.font)
  for i=1,num,1 do
    entity=Entity()
    entity:init(self.center_w,self.center_h,self.radius,width,height)
    entity:set_direction(self.dmin,self.dmax,self.precision,self.speed)
    table.insert(self.entities,entity)
  end
end

function collision(e1,e2)
  return e1.xpos < e2.xpos+e2.radius and
         e2.xpos < e1.xpos+e1.radius and
         e1.ypos < e2.ypos+e2.radius and
         e2.ypos < e1.ypos+e1.radius
end

function getPatientZero(num)
  patient_zero = math.random(1, num)
  return  patient_zero
end

function getSummary(population)
  local S = 0
  local I = 0
  local R = 0
  for index, entity in ipairs(population) do
    if entity.color == susceptible then
      S = S+1
    elseif entity.color == infectious then
      I = I+1
    elseif entity.color == removed then
      R = R+1
    end
  end
  return {S,I,R}
end

function Entities:checkForCollisions(total_time)
  if total_time > 20.0 then
    -- Check for patient zero
    if self.pzero ~= true then
      pzero = getPatientZero(self.num_entities)
      self.entities[pzero]:setColor(infectious)
      self.pzero = true
    end
    -- Check for collisions
    for i=1,self.num_entities,1 do
      for j=1,self.num_entities,1 do
        if i~=j then
          if collision(self.entities[i], self.entities[j]) then
            if self.entities[i].color == infectious or self.entities[j] == infectious then
              if self.entities[i].color == susceptible then
                self.impact:play()
                self.entities[i]:setColor(infectious)
              end
              if self.entities[j].color == susceptible then
                self.impact:play()
                self.entities[j]:setColor(infectious)
              end
            end
          end
        end
      end
    end
  end
end

function Entities:update(total_time)
  for index, entity in ipairs(self.entities) do
    entity:update()
    entity:keepInScreen()
  end
  self.summary = getSummary(self.entities)
  local int_time = math.floor(total_time)
  if int_time > self.report_time then
    print(tostring(int_time)..":"..tostring(self.summary[1])..":"..tostring(self.summary[2])..":"..tostring(self.summary[3]))
    self.report_time = int_time
  end
end

function Entities:draw()
  for index, entity in ipairs(self.entities) do
    entity:draw()
  end
  love.graphics.setColor(susceptible)
  love.graphics.print("Susceptible : " .. tostring(self.summary[1]),10,10)
  love.graphics.setColor(infectious)
  love.graphics.print("Infected    : " .. tostring(self.summary[2]),10,40)
  love.graphics.setColor(removed)
  love.graphics.print("Removed     : " .. tostring(self.summary[3]),10,70)
end
