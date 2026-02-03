require 'ruby2d'

class Blade
  attr_accessor :cx, :cy

  WIDTH  = 40
  HEIGHT = 60

  def initialize(cx, cy, color: 'orange')
    @cx = cx
    @cy = cy
    @color = color

    @quad = Quad.new(
      x1: @cx,       y1: @cy - HEIGHT / 2, # top
      x2: @cx + WIDTH / 2, y2: @cy,         # right
      x3: @cx,       y3: @cy + HEIGHT / 2, # bottom
      x4: @cx - WIDTH / 2, y4: @cy,         # left
      color: @color,
      z: 1
    )
  end

  def collide?(orange)
    return false if orange.deleted

    dx = (orange.x - @cx).abs
    dy = (orange.y - @cy).abs

    dx < (WIDTH / 2 + orange.radius) &&
      dy < (HEIGHT / 2 + orange.radius)
  end

  def set_position(cx, cy)
    @cx = cx
    @cy = cy

    @quad.x1, @quad.y1 = @cx, @cy - HEIGHT / 2
    @quad.x2, @quad.y2 = @cx + WIDTH / 2, @cy
    @quad.x3, @quad.y3 = @cx, @cy + HEIGHT / 2
    @quad.x4, @quad.y4 = @cx - WIDTH / 2, @cy
  end

  def draw
    # Static unless moved
  end
end
