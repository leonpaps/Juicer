module DragHelper
  @draggables = []
  @dragging_object = nil
  @offset_x = 0
  @offset_y = 0

  class << self
    attr_accessor :draggables

    # Set the objects to be draggable
    def set_draggables(objects)
      @draggables = objects
    end

    # Called from mouse events
    def mouse_down(x, y)
      @draggables.each do |obj|
        if obj.respond_to?(:contains_point?) && obj.contains_point?(x, y)
          @dragging_object = obj
          @offset_x = x - obj.x
          @offset_y = y - obj.y
          obj.start_drag if obj.respond_to?(:start_drag)
          break
        end
      end
    end

    def mouse_up
      if @dragging_object
        @dragging_object.stop_drag if @dragging_object.respond_to?(:stop_drag)
        @dragging_object = nil
      end
    end

    def mouse_move(x, y)
      if @dragging_object && @dragging_object.respond_to?(:drag_to)
        @dragging_object.drag_to(x - @offset_x, y - @offset_y)
      end
    end
  end
end
