require 'ruby2d'

class Orange
  attr_accessor :x, :y, :radius, :vy, :following_socket

  GRAVITY = 0.5
  SHADOW_OFFSET_X = 6
  SHADOW_OFFSET_Y = 6
  SHADOW_COLOR = [0, 0, 0, 0.25]

  def initialize(x, y, radius = 30)
    @x = x
    @y = y
    @radius = radius
    @vy = 0
    @dragging = false
    @falling = true
    @following_socket = nil

    @shadow = Circle.new(x: @x + SHADOW_OFFSET_X, y: @y + SHADOW_OFFSET_Y, radius: @radius, color: SHADOW_COLOR, z: 0)
    @circle = Circle.new(x: @x, y: @y, radius: @radius, color: 'orange', z: 1)
  end

  def contains_point?(mx, my)
    dx = mx - @x
    dy = my - @y
    Math.sqrt(dx*dx + dy*dy) <= @radius
  end

  def stop_falling; @falling = false; end
  def start_drag; @dragging = true; @falling = false; @vy = 0; end
  def stop_drag; @falling = true; @dragging = false; end
  def drag_to(mx, my); @x = mx; @y = my; update_graphics; end

  # Update position
  def update(hitbox_y = Float::INFINITY)
    if @following_socket
      # Snap and follow socket
      @x = @following_socket.x
      @y = @following_socket.y
      update_graphics
      return
    end

    if @falling
      @vy += GRAVITY
      @y += @vy

      if @y + @radius >= hitbox_y
        @y = hitbox_y - @radius
        @vy = 0
      end

      update_graphics
    end
  end

  def update_graphics
    @shadow.x = @x + SHADOW_OFFSET_X
    @shadow.y = @y + SHADOW_OFFSET_Y
    @circle.x = @x
    @circle.y = @y
  end
end
