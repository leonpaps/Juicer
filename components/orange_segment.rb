require 'ruby2d'

GRAVITY = 0.5

class OrangeSegment
  attr_accessor :x, :y, :radius, :locked
  attr_reader :image
  
  
  def initialize(x, y, target_feeder:, socket_index:, rotation: 0, radius: 30, initial_vx: 0)
    @x = x
    @y = y
    @radius = radius
    @locked = false
    @rotation = rotation
    @current_feeder = target_feeder
    @socket_index = socket_index
    @spawn_time = Time.now
    @detach_after = 4.2
    @vy = 0
    @vx = initial_vx
    
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
    if @locked
      # Snap to socket
      socket = @current_feeder.sockets[@socket_index]
      @x = socket.x
      @y = socket.y
      
      # Detach after timer
      if Time.now - @spawn_time >= @detach_after
        @locked = false
      end
    else
      # Falling + horizontal movement
      @vy += GRAVITY
      @y += @vy
      @x += @vx
    end
    
    # Update image position
    @image.x = @x - 30
    @image.y = @y - 30
  end
end
