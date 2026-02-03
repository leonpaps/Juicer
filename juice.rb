require 'ruby2d'

set width: 960, height: 960, background: 'white'

SIDE = 220
CAP_RADIUS = 64

SHADOW_OFFSET_X = 6
SHADOW_OFFSET_Y = 8
SHADOW_COLOR = [0, 0, 0, 0.25]

def rotate(x, y, a)
  [
    x * Math.cos(a) - y * Math.sin(a),
    x * Math.sin(a) + y * Math.cos(a)
  ]
end

def equilateral_vertices(side)
  h = Math.sqrt(3) * side / 2
  [
    [ 0, -2 * h / 3],
    [-side / 2,  h / 3],
    [ side / 2,  h / 3]
  ]
end

class MushroomTriangle
  def initialize(cx, cy, direction)
    @cx = cx
    @cy = cy
    @dir = direction
    @angle = 0.0

    @shadow_triangle = Triangle.new(color: SHADOW_COLOR, z: 0)
    @shadow_circles  = 3.times.map { Circle.new(radius: CAP_RADIUS, color: SHADOW_COLOR, z: 0) }

    @triangle = Triangle.new(color: 'orange', z: 1)
    @circles  = 3.times.map { Circle.new(radius: CAP_RADIUS, color: 'orange', z: 1) }
  end

  def update
    @angle += 0.01 * @dir

    verts = equilateral_vertices(SIDE)
    world = verts.map do |x, y|
      rx, ry = rotate(x, y, @angle)
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

    # Main
    @triangle.x1, @triangle.y1 = world[0]
    @triangle.x2, @triangle.y2 = world[1]
    @triangle.x3, @triangle.y3 = world[2]

    @circles.each_with_index do |c, i|
      c.x = world[i][0]
      c.y = world[i][1]
    end
  end
end

# Base positions
center_y = 600
left_x   = 480 - 110 - 100   # moved 100px further left
right_x  = 480 + 110 + 100   # moved 100px further right

left  = MushroomTriangle.new(left_x,  center_y, -1) # CCW
right = MushroomTriangle.new(right_x, center_y,  1) # CW

update do
  left.update
  right.update
end

show
