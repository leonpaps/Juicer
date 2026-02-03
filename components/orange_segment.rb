require 'ruby2d'

class OrangeSegment
  attr_accessor :x, :y, :radius, :vy, :locked, :current_socket
  attr_reader :image

  GRAVITY = 0.5

  def initialize(x, y, rotation = 0, radius: 30)
    @x = x
    @y = y
    @radius = radius
    @vy = 0
    @locked = false
    @rotation = rotation  # initial rotation in radians
    @current_socket = nil

    # Image
    @image = Image.new(
      './assets/segment.png',
      x: @x - @radius,
      y: @y - @radius,
      z: 1,
      rotate: @rotation
    )
  end

  def snap_to(feeder, socket_index)
    @current_feeder = feeder
    @socket_index = socket_index
    @locked = true
  end

  def update
    if @locked
      # Move to current socket
      socket = @current_feeder.sockets[@socket_index]
      @x = socket.x
      @y = socket.y

      # Update image position
      @image.x = @x - @radius
      @image.y = @y - @radius

      # Keep rotation aligned with feeder
      @image.rotate = @rotation + @current_feeder.angle
    else
      # Optionally handle falling logic if needed
    end
  end

  def collide_with_socket?(socket)
    dx = @x - socket.x
    dy = @y - socket.y
    Math.sqrt(dx*dx + dy*dy) <= @radius
  end

  # Optional: dynamically rotate the segment independently
  def rotate!(angle)
    @rotation += angle
  end
end
