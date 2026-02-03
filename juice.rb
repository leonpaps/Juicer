require 'ruby2d'
require_relative 'components/squeezer'
require_relative 'components/grid'

debug = true   # Toggle this to show/hide the grid

set width: 1280, height: 960, background: 'white'

Grid.draw if debug

# Example squeezers
left  = Squeezer.new(280, 600)
right = Squeezer.new(680, 600)

update do
  left.rotate(:counterclockwise)
  right.rotate(:clockwise)

  left.draw
  right.draw
end

show
