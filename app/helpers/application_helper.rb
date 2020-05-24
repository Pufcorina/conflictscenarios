module ApplicationHelper
  def logged_in?
    current_user.present?
  end

  def is_admin?
    current_user.try(:admin?)
  end

  def side_header_menu_active (key)
    new_key = params[:controller].split("/")[0] == "websites" ? "website" : params[:controller].split("/")[0]
    key.include?(new_key) ? "color_purple" : ""
  end

  def left_controller
    params[:controller].split("/")[0] == "websites" ? "website" : params[:controller].split("/")[0]
  end

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

  def options_for_gender
    [
        ["Feminine", "f"],
        ["Masculine", 'm']
    ]
  end

  def options_for_role
    [
        ["Admin", "admin"],
        ["User", 'employee']
    ]
  end

  def options_for_survey_questions
    [
        ['Free text', 'free_text'],
        ['Multiple choice', 'multiple_choice'],
        ['Multiple answers', 'multiple_answers']
    ]
  end

  def chart_schema_color
    [
        "#B48DF8", "#D32F2F", "#FFE0B2", "#536DFE", "#757575", "#E1BEE7", "#009688", "#4CAF50", "#FFC107", "#CDDC39", \
        "#673AB7", "#00BCD4", "#795548", "#607D8B", "#BDBDBD", "#FF9155", "#FFA58C", "#FFBFBE", "#A56B5D", "#FFBFBE", \
        "#FF8889", '#e6194b', '#3cb44b', '#ffe119', '#4363d8', '#f58231', '#911eb4', '#46f0f0', '#f032e6', '#bcf60c', \
        '#fabebe', '#008080', '#e6beff', '#9a6324', '#fffac8', '#800000', '#aaffc3', '#808000', '#ffd8b1', '#000075',
    ].uniq.shuffle
  end

end
