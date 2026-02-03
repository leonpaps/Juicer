require 'ruby2d'

BASE_RADIUS = 150
WHITE_RADIUS = 55
ORANGE_RADIUS = 50
SOCKET_RADIUS = 5

class Feeder
  attr_accessor :cx, :cy, :angle, :sockets

  def initialize(cx, cy, initial_angle: 0.0)
    @cx = cx
    @cy = cy
    @angle = initial_angle  # Set initial rotation

    # Base circle (stationary, centered)
    @base = Circle.new(radius: BASE_RADIUS, color: 'orange')

    # Small concentric circles at center (pivot)
    @white = Circle.new(radius: WHITE_RADIUS, color: 'white')
    @orange = Circle.new(radius: ORANGE_RADIUS, color: 'orange')

    # 3 sockets (visual only)
    @socket_angles = [0, 2 * Math::PI / 3, 4 * Math::PI / 3]
    @sockets = @socket_angles.map do
      Circle.new(radius: SOCKET_RADIUS, color: '#e56717', z: 2)
    end
  end

  # Rotate feeder
  def rotate(direction, speed = 0.01)
    @angle += direction == :clockwise ? speed : -speed
  end

  # Draw everything
  def draw
    # Base pivot circles
    @white.x = @cx
    @white.y = @cy
    @orange.x = @cx
    @orange.y = @cy

    # Base circle (stationary at center)
    @base.x = @cx
    @base.y = @cy

    # Sockets rotate around the edge
    @sockets.each_with_index do |socket, i|
      angle = @angle + @socket_angles[i]
      socket.x = @cx + BASE_RADIUS * Math.cos(angle)
      socket.y = @cy + BASE_RADIUS * Math.sin(angle)
    end
  end
end

