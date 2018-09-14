class String
  def underscore
    gsub(/::/, '/')
      .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
      .tr('-', '_')
      .downcase
  end

  def camelize
    split('_').each_with_object([]).with_index do |(string_part, string_parts), index|
      string_part.capitalize! if index > 0
      string_parts << string_part
    end.join
  end
end
