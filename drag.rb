require 'ruby2d'

set width: 600, height: 400, background: 'white'

circles = [
  Circle.new(x: 150, y: 200, radius: 30, color: 'orange'),
  Circle.new(x: 450, y: 200, radius: 30, color: 'blue')
]

dragging = nil
offset_x = 0
offset_y = 0

on :mouse_down do |event|
  circles.each do |c|
    dx = event.x - c.x
    dy = event.y - c.y
    if Math.sqrt(dx*dx + dy*dy) <= c.radius
      dragging = c
      offset_x = dx
      offset_y = dy
      break
    end
  end
end

on :mouse_up do
  dragging = nil
end

on :mouse_move do |event|
  if dragging
    dragging.x = event.x - offset_x
    dragging.y = event.y - offset_y
  end
end

show