module CsvExportable
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def to_csv
      CSV.generate do |csv|
        cols = column_names
        cols = cols + additional_csv_columns if respond_to?(:additional_csv_columns)

        csv << cols

        all.each do |s|
          line = s.attributes.values_at(*column_names)

          if respond_to?(:additional_csv_columns)
            additional_csv_columns.each do |c|
              line.push(s.send(c))
            end
          end

          csv << line
        end
      end
    end
  end
end
