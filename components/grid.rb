require 'ruby2d'

module Grid
  GRID_SPACING = 50
  GRID_COLOR = '#505050'
  LABEL_COLOR = 'black'
  
  # Draw grid lines and coordinates
  def self.draw
    # vertical lines
    (0..Window.width).step(GRID_SPACING) do |x|
      Line.new(x1: x, y1: 0, x2: x, y2: Window.height, width: 1, color: GRID_COLOR)
      Text.new("#{x}", x: x + 2, y: 2, size: 12, color: LABEL_COLOR)
    end
    
    # horizontal lines
    (0..Window.height).step(GRID_SPACING) do |y|
      Line.new(x1: 0, y1: y, x2: Window.width, y2: y, width: 1, color: GRID_COLOR)
      Text.new("#{y}", x: 2, y: y + 2, size: 12, color: LABEL_COLOR)
    end
  end
end  

# --- Standalone run ---
if __FILE__ == $0
  set width: 960, height: 960, background: 'white'
  
  Grid.draw
  
  show
end
