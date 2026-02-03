require 'ruby2d'
require_relative 'components/squeezer'
require_relative 'components/feeder'
require_relative 'components/grid'

debug = true   # Toggle this to show/hide the grid

set width: 1780, height: 960, background: 'white'

Grid.draw if debug

left_squeezer  = Squeezer.new(680, 600)
right_squeezer = Squeezer.new(1080, 600)

left_feeder  = Feeder.new(700, 300)
right_feeder = Feeder.new(1060, 300)

update do
  left_squeezer.rotate(:counterclockwise)
  right_squeezer.rotate(:clockwise)

  left_feeder.rotate(:clockwise)
  right_feeder.rotate(:counterclockwise)

  left_feeder.draw
  right_feeder.draw
  left_squeezer.draw
  right_squeezer.draw
end

show
