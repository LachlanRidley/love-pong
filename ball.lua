local vector = require "hump.vector"

Ball = {
	x = 300,
	y = 300,
	radius = 10,
	velocity = vector.fromPolar(math.pi * 1.1, 100)
}

function Ball:new (o)
	o = o or {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self
	return o
end

function Ball:draw()
	love.graphics.circle("fill", self.x, self.y, self.radius)
end

function Ball:move(dt)
	self.x = self.x + self.velocity.x * dt
	self.y = self.y + self.velocity.y * dt
end


function Ball:bounceOnLeftEdge(direction, dt)
	self.velocity = self.velocity:mirrorOn(vector.fromPolar(math.pi * 0.5,10))
end

function Ball:bounceOnRightEdge(direction, dt)
	self.velocity = self.velocity:mirrorOn(vector.fromPolar(math.pi * 1.5,10))
end

function Ball:bounceOnTopEdge(direciton, dt)
	self.velocity = self.velocity:mirrorOn(vector.fromPolar(math.pi * 1, 10))
end

function Ball:bounceOnBottomEdge(direciton, dt)
	self.velocity = self.velocity:mirrorOn(vector.fromPolar(math.pi * 0, 10))
end

function Ball:getBBox()
	return {
		x = self.x - self.radius,
		y = self.y - self.radius,
		width = self.radius * 2,
		height = self.radius * 2
	}
end

return Ball