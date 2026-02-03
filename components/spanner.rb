require 'ruby2d'

class Spanner
  attr_accessor :x, :y, :vy, :radius, :dragging, :falling, :following_socket, :deleted
  attr_reader :image

  GRAVITY = 0.5

  def method_missing(method_name, *args, &block)
    10.times do
        puts "Error spanner in the works!"
    end

    exit(1)
  end

  # Make respond_to? aware of method_missing
  def respond_to_missing?(method_name, include_private = false)
    true
  end

  def initialize(x, y, radius = 60)
    @x = x
    @y = y
    @radius = radius
    @vy = 0
    @dragging = false
    @falling = true
    @delete = false
    @following_socket = false

    # Image for the spanner
    @image = Image.new(
      './assets/spanner.png',
      x: @x - @radius,
      y: @y - @radius,
      z: 1,
      width: 150,
      height: 85
    )
  end

  # Check if a point is inside the spanner (for dragging)
  def contains_point?(mx, my)
    dx = mx - @x
    dy = my - @y
    Math.sqrt(dx*dx + dy*dy) <= @radius
  end

  # Drag handlers
  def start_drag
    @dragging = true
    @falling = false
    @vy = 0
  end

  def stop_drag
    @dragging = false
    @falling = true
  end

  def drag_to(mx, my)
    @x = mx
    @y = my
    update_graphics
  end

  # Update physics
  def update(hitbox_y = Float::INFINITY)
    return if @dragging

    if @falling
      @vy += GRAVITY
      @y += @vy

      # Collide with a horizontal hitbox
      if @y + @radius >= hitbox_y
        @y = hitbox_y - @radius
        @vy = 0
      end

      update_graphics
    end
  end

  # Update image position
  def update_graphics
    @image.x = @x - @radius
    @image.y = @y - @radius
  end
end
