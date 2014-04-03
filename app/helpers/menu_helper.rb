module MenuHelper
  def link(label, path, link_controller=nil)
    link_controller ||= send("#{label.downcase}_path")
    active = controller.controller_name == link_controller
    css    = active ? "active" : ""

    content_tag(:li, class: css) do
      link_to label, path
    end
  end

  def admin_link(label, path, options = {})
    resource = options.fetch(:resource, label.downcase)
    link label, path, send("admin_#{resource.to_s}_path").split("/").last
  end

  def dashboard_link
    link 'Dashboard', dashboard_path, 'dashboards'
  end
end
