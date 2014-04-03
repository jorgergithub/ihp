class ClientPhone < ActiveRecord::Base
  include I18n::Alchemy

  belongs_to :client

  validates :number, presence: true, uniqueness: true
  validates :number, as_phone_number: true

  localize :number, using: PhoneParser
end
