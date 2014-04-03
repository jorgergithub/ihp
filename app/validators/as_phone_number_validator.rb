class AsPhoneNumberValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\+1\d{3}\d{3}\d{4}/
      record.errors.add(attribute, :invalid)
    end
  end
end
