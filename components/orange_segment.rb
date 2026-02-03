require 'ruby2d'

class OrangeSegment
  attr_accessor :x, :y, :radius, :vy, :locked
  attr_reader :image

  GRAVITY = 0.5

  def initialize(x, y, radius: 30, rotation)
    @x = x
    @y = y
    @radius = radius
    @vy = 0
    @locked = false  # becomes true once it snaps to a socket

    # Image of segment
    @image = Image.new(
      './assets/segment.png',
      x: @x - @radius,
      y: @y - @radius,
      z: 1
    )
  end

  # Update each frame
  def update
    unless @locked
      @vy += GRAVITY
      @y += @vy
    end

    # Update graphics
    @image.x = @x - @radius
    @image.y = @y - @radius
  end

  # Snap to a socket
  def snap_to(socket)
    @x = socket.x
    @y = socket.y
    @vy = 0
    @locked = true
  end

  # Simple collision check with a socket
  def collide_with_socket?(socket)
    dx = @x - socket.x
    dy = @y - socket.y
    Math.sqrt(dx*dx + dy*dy) <= @radius
  end
end
