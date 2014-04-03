module ApplicationHelper
  def subdomain_title
    subdomain = "Admin" if admin?
    subdomain = "Psychic" if staff?

    "#{subdomain} Dashboard Login"
  end

  def page_title
    if @page_seo
      @page_seo.title
    else
      "I Heart Psychics"
    end
  end

  def page_description
    if @page_seo
      @page_seo.description
    else
      ""
    end
  end

  def limited_text(text, amount)
    if text.size > amount
      text[0..69] + "..."
    else
      text
    end
  end

  def page_keywords
    if @page_seo
      @page_seo.keywords
    else
      ""
    end
  end

  def nav_link(name, link, controllers=[], html = {})
    active = controllers.include?(controller_name)

    unless active
      active = (link == request.env['PATH_INFO'])
    end

    content_tag(:li, class: "nav-link#{active ? " active" : ""} #{html[:class]}") do
      link_to name, link
    end
  end

  def badge_link_to(items, label, link)
    badge = "<span class='badge badge-info'>#{items.count}</span>"
    link_to "#{label} #{badge}".html_safe, link
  end

  def link_to_remove_fields(name, f, options = {})
    function = options.delete(:function) || "remove_fields"
    f.hidden_field(:_destroy) + link_to_function(name, "#{function}(this)", options)
  end

  def link_to_add_fields(name, f, association, options = {})
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{ association }") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end

    element_finder = ""
    if element_finder = options.delete(:element_finder)
      element_finder = ", #{element_finder}"
    end

    link_to_function(name, "add_fields(this,
      \"#{ association }\",
      \"#{ escape_javascript(fields) }\"#{element_finder})", options)
  end

  def template_for_field(f, association, options = {})
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{ association }") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
  end

  def format_date(date)
    date.strftime("%b %d, %Y")
  end

  def format_datetime(date)
    date.strftime("%b %d, %Y %I:%M%P")
  end

  def localized(collection)
    if block_given?
      collection.each { |item| yield(item.localized) }
    else
      collection.map { |item| item.localized }
    end
  end

  def current_page
    if admin_controller?
      "admin_#{controller.controller_name}_#{action_name}".camelize
    else
      "#{controller.controller_name}_#{action_name}".camelize
    end
  end

  def provider_name(provider)
    if provider == :google_oauth2
      provider = :google
    end

    provider.to_s.titleize
  end

  def ihp_url
    "http://www.iheartpsychics.com"
  end

  def avatar_image_tag(image_id, overrides={})
    options = {
      width: 265,
      height: 265,
      crop: :thumb,
      gravity: 'faces:center',
      radius: :max
    }.merge(overrides)

    if image_id.present?
      cl_image_tag(image_id, options)
    else
      image_tag("avatar.png", {alt: "Edit Your Picture"}.merge(overrides))
    end
  end

  private

  def admin_controller?
    controller.class.name.split("::").first == "Admin"
  end

  def action_name
    case controller.action_name
    when "new", "create"
      "new"
    when "edit", "update"
      "update"
    else
      controller.action_name
    end
  end
end
