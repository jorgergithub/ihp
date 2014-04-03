module PhoneParser
  extend self

  def parse(value)
    if valid_for_parsing?(value)
      value = remove_dashes(value)
      value = set_us_international_code(value)
    end

    value
  end

  def localize(value)
    if value =~ /^\+(\d)(\d{3})(\d{3})(\d{4})$/
      "#{$2}-#{$3}-#{$4}"
    else
      value
    end
  end

  protected

  def set_us_international_code(value)
    "+1#{value}"
  end

  def remove_dashes(value)
    value.gsub("-", "")
  end

  def valid_for_parsing?(value)
    value =~ /\d{3}-\d{3}-\d{4}/
  end
end
