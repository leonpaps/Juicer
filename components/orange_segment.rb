require 'ruby2d'

class OrangeSegment
  attr_accessor :x, :y, :radius, :vy, :locked
  attr_reader :image

  GRAVITY = 0.5

  def initialize(x, y, rotation = 0, radius: 30)
    @x = x
    @y = y
    @radius = radius
    @vy = 0
    @locked = false
    @rotation = rotation  # initial in degrees

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

    # Update image position
    @image.x = @x - @radius
    @image.y = @y - @radius

    # Apply rotation manually
    @image.rotate = @rotation
  end

  # Snap to a socket
  def snap_to(socket)
    @x = socket.x
    @y = socket.y
    @vy = 0
    @locked = true
  end

  # Check collision with a socket
  def collide_with_socket?(socket)
    dx = @x - socket.x
    dy = @y - socket.y
    Math.sqrt(dx*dx + dy*dy) <= @radius
  end

  # Optional: dynamically rotate the segment
  def rotate!(angle)
    @rotation += angle
  end
end
