# encoding: UTF-8
module Shoulda
  module Matchers
    module ActiveModel
      # Ensure that the record has as_phone_number validator on a specific attribute
      #
      # Examples:
      #   it { should validate_as_phone_number(:phone) }
      def validate_as_phone_number(attribute)
        ValidationAsPhoneNumber.new(attribute)
      end

      class ValidationAsPhoneNumber < ValidationMatcher
        def initialize(attribute)
          @attribute = attribute
        end

        def description
          "require #{@attribute} to be validated by as_phone_number"
        end

        def matches?(subject)
          @subject = subject

          has_validator?(AsPhoneNumberValidator)
        end

        def failure_message
          "Expected #{@attribute} to be validated by as_phone_number"
        end

        private

        def has_validator?(validator)
          modal_class.validators_on(@attribute).map(&:class).include?(validator)
        end

        def modal_class
          @subject.class
        end
      end
    end
  end
end
