require 'ruby2d'
require_relative 'components/squeezer'

set width: 960, height: 960, background: 'white'

left  = Squeezer.new(280, 600)
right = Squeezer.new(680, 600)

rotating = true

update do
  if rotating
    left.rotate(:counterclockwise)
    right.rotate(:clockwise)
  end

  left.draw
  right.draw
end

show
