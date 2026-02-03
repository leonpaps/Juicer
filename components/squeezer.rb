require 'ruby2d'

SIDE = 220
CAP_RADIUS = 64

SHADOW_OFFSET_X = 6
SHADOW_OFFSET_Y = 8
SHADOW_COLOR = [0, 0, 0, 0.25]

def rotate_point(x, y, a)
  [
    x * Math.cos(a) - y * Math.sin(a),
    x * Math.sin(a) + y * Math.cos(a)
  ]
end

def equilateral_vertices(side)
  h = Math.sqrt(3) * side / 2
  [
    [0, -2 * h / 3],
    [-side / 2,  h / 3],
    [ side / 2,  h / 3]
  ]
end

class Squeezer
  attr_accessor :cx, :cy

  def initialize(cx, cy, color = 'orange')
    @cx = cx
    @cy = cy
    @angle = 0.0

    # Triangle shadow
    @shadow_triangle = Triangle.new(color: SHADOW_COLOR, z: 0)
    @shadow_circles  = 3.times.map { Circle.new(radius: CAP_RADIUS, color: SHADOW_COLOR, z: 0) }

    # Main triangle
    @triangle = Triangle.new(color: color, z: 1)
    @circles  = 3.times.map { Circle.new(radius: CAP_RADIUS, color: color, z: 1) }
  end

  # Call from juice.rb to rotate the squeezer
  # direction = :clockwise or :counterclockwise
  def rotate(direction, speed = 0.01)
    case direction
    when :clockwise
      @angle += speed
    when :counterclockwise
      @angle -= speed
    end
  end

  # Draw at current angle
  def draw
    verts = equilateral_vertices(SIDE)
    world = verts.map do |x, y|
      rx, ry = rotate_point(x, y, @angle)
      [rx + @cx, ry + @cy]
    end

    # Shadow
    @shadow_triangle.x1, @shadow_triangle.y1 = world[0][0] + SHADOW_OFFSET_X, world[0][1] + SHADOW_OFFSET_Y
    @shadow_triangle.x2, @shadow_triangle.y2 = world[1][0] + SHADOW_OFFSET_X, world[1][1] + SHADOW_OFFSET_Y
    @shadow_triangle.x3, @shadow_triangle.y3 = world[2][0] + SHADOW_OFFSET_X, world[2][1] + SHADOW_OFFSET_Y

    @shadow_circles.each_with_index do |c, i|
      c.x = world[i][0] + SHADOW_OFFSET_X
      c.y = world[i][1] + SHADOW_OFFSET_Y
    end

    # Main triangle
    @triangle.x1, @triangle.y1 = world[0]
    @triangle.x2, @triangle.y2 = world[1]
    @triangle.x3, @triangle.y3 = world[2]

    @circles.each_with_index do |c, i|
      c.x = world[i][0]
      c.y = world[i][1]
    end
  end
end

# --- Standalone run ---
if __FILE__ == $0
  set width: 960, height: 960, background: 'white'

  left  = Squeezer.new(280, 600)
  right = Squeezer.new(680, 600)

  update do
    left.rotate(:counterclockwise)
    right.rotate(:clockwise)

    left.draw
    right.draw
  end

  show
end
