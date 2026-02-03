require 'ruby2d'

Dir[File.join(__dir__, 'components', '*.rb')].each { |file| require file }

debug = true
set width: 1780, height: 960, background: 'white'

# Grid
Grid.draw if debug

# Components
left_squeezer  = Squeezer.new(680, 600)
right_squeezer = Squeezer.new(1080, 600)

# Feeders
left_feeder    = Feeder.new(725, 300)
right_feeder   = Feeder.new(1045, 300)

left_feeder_hitbox  = FeederHitbox.new(left_feeder.cx, left_feeder.cy, 130)
right_feeder_hitbox = FeederHitbox.new(right_feeder.cx, right_feeder.cy, 130)

left_feeder_hitbox.draw
right_feeder_hitbox.draw

# Hitbox
hitbox = Hitbox.new(1400, 800, 300, 50, debug: debug)
hitbox2 = Hitbox.new(800, 300, 150, 50, debug: debug)

# Oranges
oranges = []
oranges << Orange.new(1500, 50)
oranges << Orange.new(1550, 100)

# Blade
Blade.new(880, 400).draw

# Register draggables in DragHelper
DragHelper.set_draggables(oranges)

# Top-level event registration (required by Ruby2D)
on :mouse_down do |event|
  DragHelper.mouse_down(event.x, event.y)
end

on :mouse_up do |_|
  DragHelper.mouse_up
end

on :mouse_move do |event|
  DragHelper.mouse_move(event.x, event.y)
end

update do
  # Rotate squeezers and feeders
  left_squeezer.rotate(:counterclockwise)
  right_squeezer.rotate(:clockwise)
  left_feeder.rotate(:clockwise)
  right_feeder.rotate(:counterclockwise)

  # Draw everything
  left_feeder.draw
  right_feeder.draw
  left_squeezer.draw
  right_squeezer.draw

  # Update oranges with gravity
  oranges.each do |o|
    if hitbox.collide?(o)
      o.y = hitbox.y - o.radius
      o.vy = 0
    elsif hitbox2.collide?(o) 
      o.y = hitbox2.y - o.radius
      o.vy = 0
    else
      o.update(Float::INFINITY)
    end
  end

  oranges.each do |o|
    if left_feeder_hitbox.collide?(o)
        o.stop_falling
    elsif right_feeder_hitbox.collide?(o)
        o.stop_falling
    else
        o.update(Float::INFINITY) # gravity still applies
    end
  end

  # Draw hitbox (debug only)
  hitbox.draw
end

show
