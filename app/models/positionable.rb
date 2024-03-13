module Positionable
  def set_position
    new_position = self.class.last.position + 1 if !self.class.last.nil? && !self.class.last.position.nil?
    self.position = new_position || 1
  end
end
