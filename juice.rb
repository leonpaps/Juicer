require 'ruby2d'

Dir[File.join(__dir__, 'components', '*.rb')].each { |file| require file }

debug = true
set width: 1780, height: 960, background: 'white'

# Grid
Grid.draw if debug

# Components
left_squeezer  = Squeezer.new(680, 600)
right_squeezer = Squeezer.new(1080, 600)

# Feeders with initial rotations
left_feeder    = Feeder.new(725, 300, initial_angle: Math::PI / 1.7)
right_feeder   = Feeder.new(1045, 300, initial_angle: Math::PI / 2.3)

# Feeder hitboxes (for stopping gravity before snapping)
left_feeder_hitbox  = FeederHitbox.new(left_feeder.cx, left_feeder.cy, 130)
right_feeder_hitbox = FeederHitbox.new(right_feeder.cx, right_feeder.cy, 130)

left_feeder_hitbox.draw
right_feeder_hitbox.draw

# Ground hitboxes
hitbox = Hitbox.new(1400, 800, 300, 50, debug: debug)

# Oranges
oranges = []
oranges << Orange.new(1500, 50)
oranges << Orange.new(1550, 100)

# Blade
blade = Blade.new(883, 360)
blade.draw

# Register draggables in DragHelper
DragHelper.set_draggables(oranges)

# Mouse events
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
    else
      o.update(Float::INFINITY)
    end
  end
  
  # Snap oranges to feeder sockets
  oranges.each do |o|
    next if o.following_socket # Already attached
    
    # Feeder hitbox ONLY disables falling
    if left_feeder_hitbox.collide?(o) || right_feeder_hitbox.collide?(o)
      o.stop_falling
    end
    
    [left_feeder, right_feeder].each do |f|
      f.sockets.each do |s|
        dx = o.x - s.x
        dy = o.y - s.y
        distance = Math.sqrt(dx*dx + dy*dy)
        if distance <= o.radius + s.radius
          o.following_socket = s
          o.stop_drag
          o.stop_falling
          break
        end
      end
    end
  end
  
  # --- Blade collision ---
  oranges.each do |o|
    next if o.deleted
    if blade.collide?(o)
      o.destroy
    end
  end
  
  # Remove deleted oranges from arrays + drag helper
  oranges.reject!(&:deleted)
  DragHelper.set_draggables(oranges)
  
  # Draw hitboxes (debug only)
  hitbox.draw
  left_feeder_hitbox.draw
  right_feeder_hitbox.draw
end

show
