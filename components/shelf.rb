require 'ruby2d'

class Shelf
  attr_accessor :x, :y, :width, :height
  
  def initialize(x, y, width, height, debug: false)
    @x = x
    @y = y
    @width = width
    @height = height
    @debug = debug
    
    @rect = Rectangle.new(
      x: @x,
      y: @y,
      width: @width,
      height: @height,
      color: 'green',
      z: 0
    )
    
  end
  
  # Check if an orange has hit this shelf
  def collide?(orange)
    ox, oy = orange.x, orange.y + orange.radius
    ox >= @x && ox <= (@x + @width) && oy >= @y && oy <= (@y + @height)
  end
  
  
  def draw
    if @debug && @rect
      @rect.x = @x
      @rect.y = @y
      @rect.width = @width
      @rect.height = @height
    end
  end
end
