years = *(Date.today.year..Date.today.year+20)
years.map! { |y| OpenStruct.new(value: y, name: y) }

Rails.configuration.credit_card = {
  :months => [
    OpenStruct.new(value: "01", name: "01 - January"  ),
    OpenStruct.new(value: "02", name: "02 - February" ),
    OpenStruct.new(value: "03", name: "03 - March"    ),
    OpenStruct.new(value: "04", name: "04 - April"    ),
    OpenStruct.new(value: "05", name: "05 - May"      ),
    OpenStruct.new(value: "06", name: "06 - June"     ),
    OpenStruct.new(value: "07", name: "07 - July"     ),
    OpenStruct.new(value: "08", name: "08 - August"   ),
    OpenStruct.new(value: "09", name: "09 - September"),
    OpenStruct.new(value: "10", name: "10 - October"  ),
    OpenStruct.new(value: "11", name: "11 - November" ),
    OpenStruct.new(value: "12", name: "12 - December" )
  ],
  :years => years
}
