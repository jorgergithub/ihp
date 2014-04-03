require 'ostruct'

module FormHelper
  def add_field(form, field_name, label=nil, options={})
    content_tag(:div, class: "control-group") do
      result = form.label field_name, label, class: "control-label"
      result << content_tag(:div, class: "controls") do
        yield
      end
      result.html_safe
    end
  end

  def add_text_field(form, field_name, label=nil, options={})
    input_options = options.delete(:input) if options
    input_options ||= {}

    add_field(form, field_name, label, options) do
      form.text_field(field_name, options.merge(input_options)).html_safe
    end
  end

  def add_date_field(form, field_name, label=nil, options={})
    options.merge! input: { class: "datepicker" }
    add_text_field(form, field_name, label, options)
  end

  def add_text_area(form, field_name, label=nil, options={})
    add_field(form, field_name, label, options) do
      form.text_area(field_name, options).html_safe
    end
  end

  def add_password_field(form, field_name, label=nil, options={})
    add_field(form, field_name, label, options) do
      form.password_field(field_name, options).html_safe
    end
  end

  def add_checkbox(form, field_name, label=nil, options={})
    content_tag(:div, class: "control-group") do
      content_tag(:div, class: "controls") do
        content_tag(:label, class: "checkbox") do
          result = form.check_box field_name
          result << (label || field_name.to_s.humanize)
        end
      end
    end
  end

  def add_yesno_field(form, field_name, label=nil, options={})
    add_field(form, field_name, label, options) do
      result = content_tag(:label, class: "radio") do
        r =  form.radio_button field_name, "true"
        r << "Yes"
      end
      result << content_tag(:label, class: "radio") do
        r =  form.radio_button field_name, "false"
        r << "No"
      end
    end
  end

  def add_select(form, field_name, values, label=nil, options={})
    options.merge!(include_blank: true)

    add_field(form, field_name, label, options) do
      form.select(field_name, values, options)
    end
  end

  def add_state_select(form, field_name, label=nil, options={})
    add_field(form, field_name, label, options) do
      form.select(field_name, us_states, include_blank: true)
    end
  end

  def add_file_field(form, object, field_name, label=nil, options={})
    add_field(form, field_name, label, options) do
      r = ""
      if object.resume?
        r << content_tag(:div, class: field_name) do
          object.resume.identifier
        end
      end
      r << form.file_field(field_name)
      r << form.hidden_field("#{field_name}_cache")
      r.html_safe
    end.html_safe
  end

  def signs
    [
      OpenStruct.new(name: 'Aries', figure: 'The Ram', start: 'March 21st', end: 'April 20th'),
      OpenStruct.new(name: 'Taurus', figure: 'The Bull', start: 'April 21st', end: 'May 21st'),
      OpenStruct.new(name: 'Gemini', figure: 'The Twins', start: 'May 22nd', end: 'June 21st'),
      OpenStruct.new(name: 'Cancer', figure: 'The Crab', start: 'June 22nd', end: 'July 22nd'),
      OpenStruct.new(name: 'Leo', figure: 'The Lion', start: 'July 23rd', end: 'August 23rd'),
      OpenStruct.new(name: 'Virgo', figure: 'The Virgin', start: 'August 24th', end: 'September 23rd'),
      OpenStruct.new(name: 'Libra', figure: 'The Scales', start: 'September 24th', end: 'October 23rd'),
      OpenStruct.new(name: 'Scorpio', figure: 'The Scorpion', start: 'October 24', end: 'November 22nd'),
      OpenStruct.new(name: 'Sagittarius', figure: 'The Archer', start: 'November 23rd', end: 'December 21st'),
      OpenStruct.new(name: 'Capricorn', figure: 'The Goat', start: 'December 22nd', end: 'January 20th'),
      OpenStruct.new(name: 'Aquarius', figure: 'The Water Bearer', start: 'January 21st', end: 'February 19th'),
      OpenStruct.new(name: 'Pisces', figure: 'The Fish', start: 'February 20th', end: 'March 20th')
    ]
  end

  def us_states
      [
        ['Alabama', 'AL'],
        ['Alaska', 'AK'],
        ['Arizona', 'AZ'],
        ['Arkansas', 'AR'],
        ['California', 'CA'],
        ['Colorado', 'CO'],
        ['Connecticut', 'CT'],
        ['Delaware', 'DE'],
        ['District of Columbia', 'DC'],
        ['Florida', 'FL'],
        ['Georgia', 'GA'],
        ['Hawaii', 'HI'],
        ['Idaho', 'ID'],
        ['Illinois', 'IL'],
        ['Indiana', 'IN'],
        ['Iowa', 'IA'],
        ['Kansas', 'KS'],
        ['Kentucky', 'KY'],
        ['Louisiana', 'LA'],
        ['Maine', 'ME'],
        ['Maryland', 'MD'],
        ['Massachusetts', 'MA'],
        ['Michigan', 'MI'],
        ['Minnesota', 'MN'],
        ['Mississippi', 'MS'],
        ['Missouri', 'MO'],
        ['Montana', 'MT'],
        ['Nebraska', 'NE'],
        ['Nevada', 'NV'],
        ['New Hampshire', 'NH'],
        ['New Jersey', 'NJ'],
        ['New Mexico', 'NM'],
        ['New York', 'NY'],
        ['North Carolina', 'NC'],
        ['North Dakota', 'ND'],
        ['Ohio', 'OH'],
        ['Oklahoma', 'OK'],
        ['Oregon', 'OR'],
        ['Pennsylvania', 'PA'],
        ['Puerto Rico', 'PR'],
        ['Rhode Island', 'RI'],
        ['South Carolina', 'SC'],
        ['South Dakota', 'SD'],
        ['Tennessee', 'TN'],
        ['Texas', 'TX'],
        ['Utah', 'UT'],
        ['Vermont', 'VT'],
        ['Virginia', 'VA'],
        ['Washington', 'WA'],
        ['West Virginia', 'WV'],
        ['Wisconsin', 'WI'],
        ['Wyoming', 'WY']
      ]
  end
end
