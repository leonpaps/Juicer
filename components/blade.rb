require 'ruby2d'

class Blade
  attr_accessor :cx, :cy

  def initialize(cx, cy, color: 'orange')
    @cx = cx
    @cy = cy
    @color = color

    # Hardcoded upside-down diamond points relative to center
    # 40px wide, 60px tall
    @quad = Quad.new(
      x1: @cx,       y1: @cy - 30,  # top point
      x2: @cx + 20,  y2: @cy,       # right point
      x3: @cx,       y3: @cy + 30,  # bottom point
      x4: @cx - 20,  y4: @cy,       # left point
      color: @color,
      z: 1
    )
  end

  # Update position (if center moves)
  def set_position(cx, cy)
    @cx = cx
    @cy = cy
    @quad.x1, @quad.y1 = @cx, @cy - 30
    @quad.x2, @quad.y2 = @cx + 20, @cy
    @quad.x3, @quad.y3 = @cx, @cy + 30
    @quad.x4, @quad.y4 = @cx - 20, @cy
  end

  def draw
    # No dynamic update needed unless you move the center
    # Just keep quad at current coordinates
  end
end

# --- Standalone run ---
if __FILE__ == $0
  set width: 400, height: 400, background: 'white'

  blade = Blade.new(200, 200)

  update do
    blade.draw
  end

  show
end
