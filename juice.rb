require 'ruby2d'

Dir[File.join(__dir__, 'components', '*.rb')].each { |file| require file }

debug =  false #true
set width: 1780, height: 960, background: 'white'

# Grid
Grid.draw if debug

# Components
left_squeezer  = Squeezer.new(680, 600)
right_squeezer = Squeezer.new(1080, 600)

juice_bursts = []  # can hold multiple juice bursts

# Feeders with initial rotations
left_feeder    = Feeder.new(725, 300, initial_angle: Math::PI / 1.7)
right_feeder   = Feeder.new(1045, 300, initial_angle: Math::PI / 2.3)

# Feeder hitboxes (for stopping gravity before snapping)
left_feeder_hitbox  = FeederHitbox.new(left_feeder.cx, left_feeder.cy, 130)
right_feeder_hitbox = FeederHitbox.new(right_feeder.cx, right_feeder.cy, 130)

left_feeder_hitbox.draw
right_feeder_hitbox.draw

# Ground shelf
shelf = Shelf.new(1400, 800, 300, 50, debug: debug)

# Oranges
oranges = []
$spawn_count = 0


orange_segments = []
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

# Update helper methods
def rotate_components(left_squeezer, right_squeezer, left_feeder, right_feeder)
  left_squeezer.rotate(:counterclockwise)
  right_squeezer.rotate(:clockwise)
  left_feeder.rotate(:clockwise)
  right_feeder.rotate(:counterclockwise)
end

def draw_components(left_feeder, right_feeder, left_squeezer, right_squeezer)
  left_feeder.draw
  right_feeder.draw
  left_squeezer.draw
  right_squeezer.draw
end

def update_oranges_gravity(oranges, shelf)
  oranges.each do |o|
    if shelf.collide?(o)
      o.y = shelf.y - o.radius
      o.vy = 0
    else
      o.update(Float::INFINITY)
    end
  end
end

def snap_oranges_to_sockets(oranges, left_feeder, right_feeder, left_feeder_hitbox, right_feeder_hitbox)
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
end

def handle_blade_collisions(oranges, blade, left_feeder, right_feeder, orange_segments, juice_bursts)
  oranges.each do |o|
    next if o.deleted
    
    if blade.collide?(o)
      # Find closest sockets from each feeder
      sockets = []
      [left_feeder, right_feeder].each do |feeder|
        closest_socket = feeder.sockets.min_by do |s|
          dx = o.x - s.x
          dy = o.y - s.y
          Math.sqrt(dx*dx + dy*dy)
        end
        sockets << { feeder: feeder, socket_index: feeder.sockets.index(closest_socket) } if closest_socket
      end

      # Spawn two segments, each locked to its socket
      orange_segments << OrangeSegment.new(
        863, 290,
        rotation: 0,
        target_feeder: sockets[0][:feeder],
        socket_index: sockets[0][:socket_index],
        initial_vx: -5
      )

      orange_segments << OrangeSegment.new(
        880, 300,
        rotation: Math::PI,
        target_feeder: sockets[1][:feeder],
        socket_index: sockets[1][:socket_index],
        initial_vx: 5
      )

      # Destroy orange
      o.destroy

      # Spawn new orange
      oranges << Orange.new(1450 + (rand * 50).to_i, 50)
      $spawn_count += 1

      # Spawn spanner after 2 oranges
      if $spawn_count > 2
        oranges << Spanner.new(1600, 0)
      end

      # Create juice burst
      juice_bursts << Juice.new(o.x, o.y, count: 30)
    end
  end
end

def update_orange_segments(orange_segments)
  orange_segments.each do |seg|
    seg.update
  end
end

def cleanup_destroyed_oranges(oranges)
  oranges.reject!(&:deleted)
  DragHelper.set_draggables(oranges)
end

def draw_hitboxes(shelf, left_feeder_hitbox, right_feeder_hitbox)
  shelf.draw
  left_feeder_hitbox.draw
  right_feeder_hitbox.draw
end

def update_juice_bursts(juice_bursts)
  juice_bursts.each { |j| j.update(Window.height) }
  juice_bursts.reject! { |j| j.drops.empty? }
end

update do
  draw_components(left_feeder, right_feeder, left_squeezer, right_squeezer)
  rotate_components(left_squeezer, right_squeezer, left_feeder, right_feeder)
  update_oranges_gravity(oranges, shelf)
  snap_oranges_to_sockets(oranges, left_feeder, right_feeder, left_feeder_hitbox, right_feeder_hitbox)
  
  handle_blade_collisions(oranges, blade, left_feeder, right_feeder, orange_segments, juice_bursts)
  update_orange_segments(orange_segments)
  cleanup_destroyed_oranges(oranges)
  
  draw_hitboxes(shelf, left_feeder_hitbox, right_feeder_hitbox)
  update_juice_bursts(juice_bursts)
end

show
