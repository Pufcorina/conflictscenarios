module ApplicationHelper

  def sortable(column, title = nil, status_view_demo_tracker = nil, demo_club_type_filter = nil)
    title ||= column.titleize
    if @default_sort.present?
      css_class = column == @default_sort ? "current icon-sort-asc" : "current icon-sort"
      direction = "desc"
    else
      css_class = column == sort_column ? "current icon-sort-#{sort_direction}" : "current icon-sort"
      direction = column == sort_column && sort_direction == "desc" ? "asc" : "desc"
    end
    if !Rails.env.test?
      link_to title, {:sort => column, :direction => direction, :status_view_demo_tracker => status_view_demo_tracker, :demo_club_type_filter => demo_club_type_filter}, {:class => css_class}
    end
  end

  def sortable_remote(column, title = nil, status_view_demo_tracker = nil, demo_club_type_filter = nil)
    title ||= column.titleize
    if @default_sort.present?
      if @default_sort == "orders.internal_id"
        css_class = column == @default_sort.to_s ? "current icon-sort-desc" : "current icon-sort"
        direction = "asc"
      else
        css_class = column == @default_sort.to_s ? "current icon-sort-asc" : "current icon-sort"
        direction = "desc"
      end
    else
      css_class = column == sort_column ? "current icon-sort-#{sort_direction}" : "current icon-sort"
      direction = column == sort_column && sort_direction == "desc" ? "asc" : "desc"
    end
    if !Rails.env.test?
      link_to title, {:sort => column, :direction => direction, :status_view_demo_tracker => status_view_demo_tracker, :demo_club_type_filter => demo_club_type_filter}, {:class => css_class, remote: true}
    end
  end

  def current_user
    warden.authenticate(scope: :user) rescue nil
  end

  def logged_in?
    current_user.present?
  end

  def is_admin?
    current_user.try(:admin?)
  end

  def side_header_menu_active (key)
    new_key = params[:controller].split("/")
    (key.include?(new_key[0]) && params[:action] != "admin_accounts_index") ? "active" : ""
  end

  def side_header_menu_hidden (key)
    new_key = params[:controller].split("/")
    (key.include? new_key[0]) ? "" : "hidden"
  end

  def side_menu_active (controller, method)
    if params[:controller].split("/")[0] == controller
      (method.include? params[:action]) ? "active" : ""
    end
  end
end
