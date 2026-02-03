require 'ruby2d'

class FeederHitbox
  attr_accessor :cx, :cy, :radius

  def initialize(cx, cy, radius, debug: false)
    @cx = cx
    @cy = cy
    @radius = radius
    @debug = debug

    # Optional visible circle for debugging
    if @debug
      @circle = Circle.new(
        x: @cx,
        y: @cy,
        radius: @radius,
        color: 'green',
        z: 10,
        sectors: 64
      )
    end
  end

  # Check collision with an orange
  def collide?(orange)
    dx = orange.x - @cx
    dy = orange.y - @cy
    distance = Math.sqrt(dx*dx + dy*dy)
    distance <= (orange.radius + @radius)
  end

  # Draw the hitbox if debugging
  def draw
    @circle&.draw
  end
end
