module PsychicsHelper
  def speciality_class(psychic, speciality)
    psychic.send("#{speciality.split(" ").map(&:capitalize).join.underscore}?") ? "highlighted" : ""
  end

  def turn_psychic_availability_link(psychic)
    if psychic.available?
      link_to '<i class="icon-pause"></i>'.html_safe, unavailable_admin_psychic_path(psychic)
    else
      link_to '<i class="icon-play"></i>'.html_safe, available_admin_psychic_path(psychic)
    end
  end

  def psychic_state psychic
    case psychic.current_state.to_s
    when "available"
      "I'm available"
    when "on_a_call"
      "I'm on a call"
    when "unavailable"
      "I'm offline"
    end
  end

  def psychic_prices
    values = Array(3.upto(9))

    values.inject([]) do |h, v|
      h << [number_to_currency(v), number_with_precision(v)]
      h
    end
  end

  def rating_for(psychic, options={})
    filled_icon = options[:filled_icon] || "icon-star"
    empty_icon = options[:empty_icon] || "icon-star"

    result = ""
    psychic.rating.to_i.times do
      result << "<i class='#{filled_icon} star-filled'></i> "
    end

    psychic.rating.to_i.upto(4) do
      result << "<i class='#{empty_icon} star-empty'></i> "
    end

    result << "(#{psychic.reviews.count})"
    result.html_safe
  end

  def random_avatar
    gender, count = { male: 13, female: 4 }.to_a.sample
    "psychic-avatar-#{gender}-#{"%02d" % (rand(count)+1).to_i}"
  end

  def week_days_from_today
    week_days = []
    7.times do |index|
      week_days << (Date.today + index.days).strftime("%a")
    end
    week_days
  end
end
