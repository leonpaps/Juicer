require 'ruby2d'

BASE_RADIUS = 150
WHITE_RADIUS = 55
ORANGE_RADIUS = 50
SOCKET_RADIUS = 5

class Feeder
  attr_accessor :cx, :cy, :angle
  attr_reader :sockets

  def initialize(cx, cy, initial_angle: 0.0)
    @cx = cx
    @cy = cy
    @angle = initial_angle  # Initial rotation

    # Base circle (stationary)
    @base = Circle.new(radius: BASE_RADIUS, color: 'orange')

    # Pivot circles at center
    @white = Circle.new(radius: WHITE_RADIUS, color: 'white')
    @orange = Circle.new(radius: ORANGE_RADIUS, color: 'orange')

    # Sockets: 3 small dark orange circles
    @socket_angles = [0, 2 * Math::PI / 3, 4 * Math::PI / 3] # 0°, 120°, 240°
    @sockets = @socket_angles.map do
      Circle.new(radius: SOCKET_RADIUS, color: '#e56717', z: 2)
    end
  end

  # Rotate feeder
  def rotate(direction, speed = 0.01)
    @angle += direction == :clockwise ? speed : -speed
  end

  # Draw feeder and sockets
  def draw
    # Pivot circles
    @white.x = @cx
    @white.y = @cy
    @orange.x = @cx
    @orange.y = @cy

    # Base circle
    @base.x = @cx
    @base.y = @cy

    # Update sockets positions along the edge
    @sockets.each_with_index do |socket, i|
      angle = @angle + @socket_angles[i]
      socket.x = @cx + BASE_RADIUS * Math.cos(angle)
      socket.y = @cy + BASE_RADIUS * Math.sin(angle)
    end
  end
end
