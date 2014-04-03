class PhoneFormatter
  def self.format(number)
    if number =~ /^\+(\d)(\d{3})(\d{3})(\d{4})$/
      "+#{$1}-#{$2}-#{$3}-#{$4}"
    else
      number
    end
  end

  def self.parse(number)
    number.gsub!("-", "")
    unless number =~ /^\+1/
      number = "+1#{number}"
    end
    number
  end
end
