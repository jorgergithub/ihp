require "csv_exportable"

class Subscriber < ActiveRecord::Base
  include CsvExportable

  validates_presence_of :email
  validates_uniqueness_of :email, message: "already subscribed"
end
