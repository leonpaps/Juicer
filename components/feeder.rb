require 'ruby2d'

BASE_RADIUS = 150
WHITE_RADIUS = 55
ORANGE_RADIUS = 50
DEFAULT_OFFSET = 5

class Feeder
  attr_accessor :cx, :cy

  def initialize(cx, cy, offset = DEFAULT_OFFSET)
    @cx = cx
    @cy = cy
    @offset = offset
    @angle = 0.0

    # Base circle (we will rotate this around the pivot)
    @base = Circle.new(radius: BASE_RADIUS, color: 'orange')

    # Small concentric circles at center (pivot)
    @white = Circle.new(radius: WHITE_RADIUS, color: 'white')
    @orange = Circle.new(radius: ORANGE_RADIUS, color: 'orange')
  end

  # Rotate base circle around pivot (small circles) — direction: :clockwise or :counterclockwise
  def rotate(direction, speed = 0.05)
    case direction
    when :clockwise
      @angle += speed
    when :counterclockwise
      @angle -= speed
    end
  end

  # Draw component
  def draw
    # Pivot center for small concentric circles
    @white.x = @cx
    @white.y = @cy
    @orange.x = @cx
    @orange.y = @cy

    # Rotate base circle around pivot
    offset_x = 0
    offset_y = -@offset

    cos_a = Math.cos(@angle)
    sin_a = Math.sin(@angle)

    rotated_x = cos_a * offset_x - sin_a * offset_y
    rotated_y = sin_a * offset_x + cos_a * offset_y

    @base.x = @cx + rotated_x
    @base.y = @cy + rotated_y
  end
end

# --- Standalone run ---
if __FILE__ == $0
  set width: 800, height: 800, background: 'white'

  feeder = Feeder.new(400, 400)

  update do
    feeder.rotate(:clockwise)
    feeder.draw
  end

  show
end
