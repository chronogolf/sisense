class String
  def to_snake_case
    gsub(/::/, '/')
      .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
      .tr('-', '_')
      .downcase
  end

  def to_camel_case
    split('_').each_with_object([]).with_index do |(string_part, string_parts), index|
      string_part.capitalize! if index > 0
      string_parts << string_part
    end.join
  end
end
