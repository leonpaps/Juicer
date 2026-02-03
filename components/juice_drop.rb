require 'ruby2d'

class JuiceDrop
  attr_accessor :x, :y, :vx, :vy, :radius, :circle

  GRAVITY = 0.5

  def initialize(x, y, radius: 10, vx_range: -5..5, vy_range: -5..5)
    @x = x
    @y = y
    @radius = radius
    @vx = rand(vx_range)
    @vy = rand(vy_range)

    # Circle with transparent orange color
    @circle = Circle.new(
      x: @x,
      y: @y,
      radius: @radius,
      color: [255, 165, 0, 150], # semi-transparent orange
      z: 1
    )
  end

  def update
    @vy += GRAVITY
    @x += @vx
    @y += @vy
    @circle.x = @x
    @circle.y = @y
  end

  def off_screen?(height)
    @y - @radius > height
  end
end

class Juice
  attr_accessor :drops

  def initialize(start_x, start_y, count: 20)
    @drops = []
    count.times do
      @drops << JuiceDrop.new(start_x, start_y)
    end
  end

  def update(window_height)
    @drops.each(&:update)
    # Remove drops below screen
    @drops.reject! { |drop| drop.off_screen?(window_height) }
  end
end
