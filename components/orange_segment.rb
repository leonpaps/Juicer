require 'ruby2d'

class OrangeSegment
  attr_accessor :x, :y, :radius, :locked
  attr_reader :image


  def initialize(x, y, target_feeder:, socket_index:, rotation: 0, radius: 30)
    @x = x
    @y = y
    @radius = radius
    @locked = false
    @rotation = rotation
    @current_feeder = target_feeder
    @socket_index = socket_index

    # Image
    @image = Image.new(
      './assets/segment.png',
      x: @x - @radius,
      y: @y - @radius,
      z: 1,
      rotate: @rotation
    )

    # Immediately lock to the socket
    snap_to_socket!
  end

  # Lock to socket
  def snap_to_socket!
    @locked = true
    update  # place image at socket immediately
  end

  def update
    return unless @locked

    # Follow the assigned socket
    socket = @current_feeder.sockets[@socket_index]
    @x = socket.x
    @y = socket.y

    # Update image position
    @image.x = @x - @radius
    @image.y = @y - @radius

    # Align rotation with feeder + initial rotation
    @image.rotate = @rotation + @current_feeder.angle
  end
end
