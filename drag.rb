require 'ruby2d'

set width: 900, height: 600, background: 'white'

CIRCLE_RADIUS = 30
GRAVITY = 0.5
MIN_Y = Window.height - CIRCLE_RADIUS
STRIP_COUNT = 30  # Smooth gradient

# Gradient circle class using hex colors
class GradientCircle
  attr_reader :x, :y
  attr_accessor :vy

  def initialize(x, y, radius, top_color, bottom_color)
    @x = x
    @y = y
    @radius = radius
    @top_color = top_color
    @bottom_color = bottom_color
    @vy = 0
    @dragging = false
    @strips = []
    draw_gradient
  end

  def draw_gradient
    @strips.each(&:remove)
    @strips.clear

    STRIP_COUNT.times do |i|
      t = i.to_f / (STRIP_COUNT - 1)

      # Interpolate hex colors
      c = interpolate_hex(@top_color, @bottom_color, t)

      y_offset = -@radius + i * 2 * @radius / STRIP_COUNT.to_f
      w = Math.sqrt(@radius**2 - y_offset**2) * 2

      @strips << Rectangle.new(
        x: @x - w/2,
        y: @y + y_offset,
        width: w,
        height: 2 * @radius / STRIP_COUNT.to_f,
        color: c,
        z: 1
      )
    end
  end

  def interpolate_hex(c1, c2, t)
    # Convert hex to integers
    r1, g1, b1 = c1.scan(/../).map { |h| h.hex }
    r2, g2, b2 = c2.scan(/../).map { |h| h.hex }

    r = (r1*(1-t) + r2*t).to_i
    g = (g1*(1-t) + g2*t).to_i
    b = (b1*(1-t) + b2*t).to_i

    "#%02x%02x%02x" % [r,g,b]
  end

  # Gravity update
  def update
    unless @dragging
      @vy += GRAVITY
      @y += @vy
      @y = MIN_Y if @y > MIN_Y
      draw_gradient
    end
  end

  # Dragging
  def contains_point?(mx, my)
    dx = mx - @x
    dy = my - @y
    Math.sqrt(dx*dx + dy*dy) <= @radius
  end

  def start_drag
    @dragging = true
    @vy = 0
  end

  def stop_drag
    @dragging = false
  end

  def drag_to(mx, my)
    @x = mx
    @y = my
    draw_gradient
  end
end

# Start 3 circles in bottom-right corner
offset = 2 * CIRCLE_RADIUS
circles = [
  GradientCircle.new(Window.width - offset, MIN_Y - offset, CIRCLE_RADIUS, 'ffcc80', 'ff6600'),
  GradientCircle.new(Window.width - offset - 2*CIRCLE_RADIUS, MIN_Y - offset, CIRCLE_RADIUS, 'ffcc80', 'ff6600'),
  GradientCircle.new(Window.width - offset - 4*CIRCLE_RADIUS, MIN_Y - offset, CIRCLE_RADIUS, 'ffcc80', 'ff6600')
]

dragging_circle = nil
drag_offset_x = 0
drag_offset_y = 0

on :mouse_down do |event|
  circles.each do |c|
    if c.contains_point?(event.x, event.y)
      dragging_circle = c
      drag_offset_x = event.x - c.x
      drag_offset_y = event.y - c.y
      c.start_drag
      break
    end
  end
end

on :mouse_up do |_|
  if dragging_circle
    dragging_circle.stop_drag
    dragging_circle = nil
  end
end

on :mouse_move do |event|
  if dragging_circle
    dragging_circle.drag_to(event.x - drag_offset_x, event.y - drag_offset_y)
  end
end

update do
  circles.each(&:update)
end

show
