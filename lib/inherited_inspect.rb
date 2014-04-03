module InheritedInspect
  def inspect
    string = "#<#{self.class.name}:#{self.object_id} [#{self.id}-#{self.full_name}] "
    fields = self.class.columns.map {|field| "#{field.name}: #{self.send(field.name).inspect}"}
    fields << self.user.class.columns.map {|field| "#{field.name}: #{self.user.send(field.name).inspect}"}
    string << fields.flatten.join(", ") << ">"
  end
end
