class Category < ActiveRecord::Base
  has_many :faqs, dependent: :destroy

  validates :name, :presence => true

  accepts_nested_attributes_for :faqs, allow_destroy: true, reject_if: lambda { |attributes|
    attributes[:question].blank? || attributes[:answer].blank?
  }

  def to_slug
    name.split.map do |word|
      word.downcase.gsub(/[^A-Za-z0-9]/, "")
    end.join("-")
  end
end
