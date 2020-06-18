window.crm = window.crm or {}
((new_design_shared, $) ->
  new_design_shared.init_timeout = null
  new_design_shared.dropdown_list = []
  
  new_design_shared.nav_html = null
  
  new_design_shared.init_iChecks = (i_check_class, checkboxClass, radioClass)->
    $(i_check_class).icheck('destroy')
    $(i_check_class).icheck({
      checkboxClass: checkboxClass,
      radioClass: radioClass,
    })
    new_design_shared.bind_change(i_check_class)

  new_design_shared.iChecks = ->
    new_design_shared.init_iChecks(".i-checks", 'icheckbox_square-orange', 'iradio_square-orange')
    new_design_shared.init_iChecks(".i-checks-xs", 'icheckbox_square-orange btsp-icheck-xs', 'iradio_square-orange btsp-icheck-xs')

  new_design_shared.modaliChecks = (modal_id)->
    new_design_shared.init_iChecks("#{modal_id} .i-checks", 'icheckbox_square-orange', 'iradio_square-orange')
    new_design_shared.init_iChecks("#{modal_id} .i-checks-xs", 'icheckbox_square-orange btsp-icheck-xs', 'iradio_square-orange btsp-icheck-xs')

  new_design_shared.bind_change = (jquery_query) ->
    $(jquery_query).bind 'change', (e) ->
      $(@).icheck('updated')
      return 

  new_design_shared.toggleNavigationMenu = ->
    $(window).load ->
      new_design_shared.current_active_menu_item = $(".menu_items").find("li.active a").attr('data-nav-menu-id')
      
    $(document).on "hide.bs.collapse", ".collapse", ->
      menu_id = "#nav_league_menu"
      nav_menu_id = "#nav_league"
      if !$(menu_id).hasClass("closed")
        if $(".menu_items").find("li.active a").attr("id") != "nav_league"
          $(".menu_items").find("li.active").removeClass("active")
          $(".menu_items #nav_league").parent().addClass("active")
        $(menu_id).addClass("closed")
        $(menu_id).removeClass("opened")
        $(menu_id).slideUp()
        $(".save_bar").slideDown()
    
    $(document).on "click", "#menu-navbar-collapse a:not(.real-link), .close_navigation_menu_icon a, .top_menu_navbar .navbar-toggle, a.breadcrumb-menu-toggle", ->
      menu_id = "##{$(@).attr('data-nav-menu-id')}_menu"
      nav_menu_id = "##{$(@).attr('data-nav-menu-id')}"
      current_nav = new_design_shared.current_active_menu_item
      if menu_id != "#undefined_menu"
        if $(menu_id).hasClass("closed")
          $(".menu_items").find("li.active").removeClass("active")
          $(nav_menu_id).parent().addClass("active")
          if $(".navigation_menu .opened").attr("id") != undefined && $(menu_id).attr("id") != $(".navigation_menu .opened").attr("id")
            old_id = "##{$(".navigation_menu .opened").attr("id")}"
            $(old_id).slideUp ->
              $(menu_id).slideToggle()
              $(old_id).addClass("closed")
              $(old_id).removeClass("opened")
          else
            $(menu_id).slideToggle()

          $(menu_id).removeClass("closed")
          $(menu_id).addClass("opened")
          if !($(menu_id).attr("id") != $(".navigation_menu .opened").attr("id"))
            $(".save_bar").slideUp()
        else
          if $(".menu_items").find("li.active a").attr("id") != current_nav
            $(".menu_items").find("li.active").removeClass("active")
            $(".menu_items ##{current_nav}").parent().addClass("active")
          $(menu_id).addClass("closed")
          $(menu_id).removeClass("opened")
          $(menu_id).slideUp()
          $(".save_bar").slideDown()
      else
        old_id = "##{$(".navigation_menu .opened").attr("id")}"
        $(old_id).slideUp ->
          $(old_id).addClass("closed")
          $(old_id).removeClass("opened")

        
      return false

    $(window).on 'scroll', ->
      if $(".navigation_menu div.opened").length > 0
        if $(".save_bar").is(":hidden") && $(window).scrollTop() > 95
          $(".save_bar").slideDown()
        else if $(".save_bar").is(":visible") && $(window).scrollTop() <= 95
          $(".save_bar").slideUp()
        
  new_design_shared.autoCloseBtspTabs = ->
    $(document).on "click", ".btsp_custom_tabs_menu li", ->		
      if $("button.open_settings_menu").is(":visible")
        $(".btsp_custom_tabs_menu li.active").removeClass("active")		
        $(@).addClass("active")		
        $(@).closest("nav.navbar").find("button").click()

  new_design_shared.setNavigationMenuHeight = ->
    $(window).on 'resize', ->
      new_design_shared.setNavigationMenuHeightHelper()

    $(window).load ->
      if $(window).width() > 992
        $(".current_user_menu_dropdown a").unbind('click')
        actual_height = $(window).height()
        used_height = $(".header_navbar").outerHeight()
        if actual_height > 700
          used_height += $("#breadcrumb").height() + 2
        else
          used_height += 1
        $(".navigation_menu .odd").css("min-height", "#{actual_height - used_height}px")
        $(".navigation_menu .even").css("min-height", "#{actual_height - used_height}px")
  
  new_design_shared.setNavigationMenuHeightHelper = ->
    if $(window).width() > 992
      actual_height = $(window).height()
      used_height = $(".header_navbar").outerHeight() + 2
      if actual_height > 700
        used_height += $("#breadcrumb").height()
      else
        used_height += 1
      $(".navigation_menu .odd").css("min-height", "#{actual_height - used_height}px")
      $(".navigation_menu .even").css("min-height", "#{actual_height - used_height}px")
    else
      $(".navigation_menu .odd").css("min-height", "auto")
      $(".navigation_menu .even").css("min-height", "auto")
      
  new_design_shared.toggleCustomerNavigationMenu = ->
    $(window).load ->
      setTimeout ->
        new_design_shared.nav_html = $(".menu_items").html()
        dropdowns = ["nav_leagues_and_events", "nav_master_roster", "nav_settings", "nav_registration",  "nav_data_analysis", "nav_payments", "nav_managed_clubs"]
        dropdowns = dropdowns.filter (d) -> ($("##{d}").length > 0)
        new_design_shared.initCustomerMenuDropdowns(dropdowns, true)
        current_nav = $(".customer-navbar .menu_items .dropdown.current").attr("id")
        new_design_shared.dropdown_list = dropdowns
    
        $(window).resize ->
          # clearTimeout(new_design_shared.init_timeout) 
          # new_design_shared.init_timeout = setTimeout -> 
          $(".menu_items").html(new_design_shared.nav_html)
          new_design_shared.initCustomerMenuDropdowns(new_design_shared.dropdown_list, true)
          # , 200
        
        $(document).off "click", ".dropdown"
        $(document).on "click", ".dropdown", ->
          id = $(@).attr('id')
          left_navbar = ""
          if id != "nav_leagues_and_events"
            left_navbar = dropdowns[dropdowns.indexOf(id)-1]
          dropdown = ".#{id}_dropdown"
          if $(dropdown).hasClass("hidden")
            
            if $(".menu_tile:visible").length > 0
              previous_menu_id = $(".menu_tile:visible").data("navbar")
              $(".menu_tile:visible").addClass("hidden")
              $("##{previous_menu_id}").closest(".tile_content").removeClass("highlighted")
              $("##{previous_menu_id}").parent().removeClass("active")
              if previous_menu_id != "nav_leagues_and_events"
                previous_left_navbar = dropdowns[dropdowns.indexOf(previous_menu_id)-1]
                $("##{previous_left_navbar}").closest(".tile_content").addClass("right_dashed_border")
            else if id != current_nav
              $("##{current_nav}").parent().removeClass("active")
                
              
            $(dropdown).removeClass("hidden")
            $("##{id}").closest(".tile_content").addClass("highlighted")
            $("##{id}").parent().addClass("active")
            if id != "nav_leagues_and_events"
              $("##{left_navbar}").closest(".tile_content").removeClass("right_dashed_border")
              
          else
            if id != current_nav
              $("##{id}").parent().removeClass("active")
              $("##{current_nav}").parent().addClass("active")
            $(dropdown).addClass("hidden")
            $("##{id}").closest(".tile_content").removeClass("highlighted")
            if id != "nav_leagues_and_events"
              $("##{left_navbar}").closest(".tile_content").addClass("right_dashed_border")
      , 250
    
    new_design_shared.initCustomerMenuDropdowns = (dropdowns, append) -> 
      for drop in dropdowns
        tile = "##{drop}"
        dropdown = ".#{drop}_dropdown"
        if $(dropdown).length > 0
          fix = 2
          fixed_width = $(tile).closest(".tile_content").outerWidth() - fix
          $(tile).closest(".tile_content").css("width", fixed_width + fix)
          
      for drop in dropdowns
        tile = "##{drop}"
        dropdown = ".#{drop}_dropdown"
        if $(dropdown).length > 0
          fix = 2
          
          if append
            top_value = $(tile).offset().top + $(tile).height() + 5
            if drop == "nav_leagues_and_events"
              span_val = $(tile).text().trim()
              if span_val == "Trips"
                next_drop = dropdowns[1]
                next_tile = "##{next_drop}"
                top_value = $(next_tile).offset().top + $(next_tile).height() + 5
            $('body').append $(dropdown).css(
              position: 'absolute'
              left: parseInt(Math.round($(tile).closest(".tile_content").offset().left))
              top: top_value
              "min-width": $(tile).closest(".tile_content").width()* 1.5)
          else
            $(dropdown).css(
              left: parseInt(Math.round($(tile).closest(".tile_content").offset().left))
              top: $(tile).offset().top + $(tile).height() + 5
            )
          
          fixed_width = $(tile).closest(".tile_content").outerWidth() - fix
          $(dropdown).removeClass("hidden")
          $(dropdown + " .lower_li").width(fixed_width)
          margined_width = $(dropdown).outerWidth() - $(tile).closest(".tile_content").outerWidth() 
          styleElem = document.head.appendChild(document.createElement("style"));
          styleElem.innerHTML = "#{dropdown} .links:before {border-top: 1px solid #D8D8D8; content: '';display: block;margin-left: auto;width: #{margined_width}px;}";
          $(dropdown).addClass("hidden")

  new_design_shared.userAccountMenu = ->
    $(document).off "click", ".open_settings_menu"
    $(document).on "click", ".open_settings_menu", ->
      if $(@).find(".fa").hasClass("fa-caret-down")
        $(@).find(".fa").removeClass("fa-caret-down")
        $(@).find(".fa").addClass("fa-caret-up")
      else
        $(@).find(".fa").addClass("fa-caret-down")
        $(@).find(".fa").removeClass("fa-caret-up")
    $(document).off "click", ".current_user_menu_dropdown li:not(.dropdown_submenu_version) a:not(.sign_out_link)"
    $(document).on "click", ".current_user_menu_dropdown a:not(.sign_out_link)", ->
      if $(@).attr("href") != undefined
        if $(@).attr("target") != undefined
          window.open($(@).attr('href'), $(@).attr("target"))
        else
          window.location.href = $(@).attr('href')
      return false
    
  new_design_shared.resizeBreadcrumbArrows = ->
    $("#breadcrumb .arrow").each ->
      span_height = $(@).find("span").height()
      if span_height > 20
        $(@).css("width", "#{$(@).innerWidth() + span_height - 20}px")
  
  new_design_shared.initBootstrapDatePicker = ->
    $('.date-picker.past-picker').pickadate({
      selectMonths: true,
      selectYears: true,
      today: '',
      clear: '',
      close: '',
      format: 'mm/dd/yyyy',
      min: [1900, 1, 1],
      selectYears: 100,
      max: true,
      labelMonthNext: '',
      labelMonthPrev: '',
      labelMonthSelect: '',
      labelYearSelect: ''
    })
    
    $(".date-picker.future-picker").pickadate({
      selectMonths: true,
      selectYears: true,
      today: '',
      clear: '',
      close: '',
      format: 'mm/dd/yyyy',
      min: true,
      selectYears: 50,
      max: false,
      labelMonthNext: '',
      labelMonthPrev: '',
      labelMonthSelect: '',
      labelYearSelect: ''
    })
    
    $(".date-picker.all-picker").pickadate({
      selectMonths: true,
      selectYears: true,
      today: '',
      clear: '',
      close: '',
      format: 'mm/dd/yyyy',
      min: false,
      selectYears: 50,
      max: false,
      labelMonthNext: '',
      labelMonthPrev: '',
      labelMonthSelect: '',
      labelYearSelect: ''
    })
    
  new_design_shared.initBootstrapCheckboxes = ->
    $('.bootstrap-toggle').each  ->
      checked_tag = $(this).data("checked")
      unchecked_tag = $(this).data("unchecked")
      width = 0
      max = Math.max [checked_tag.length, unchecked_tag.length]...
      if max > 3
        width = 33 + 8.7*(max-3)
      $(this).bootstrapToggle({
        on: checked_tag,
        off: unchecked_tag  
      })
      $(this).closest(".toggle").width(width)
      return
      
    $('.simple-bootstrap-toggle').off "change"
    $('.simple-bootstrap-toggle').on "change", ->
      path = $(@).data("path")
      f = $(@).data("afunction")
      checked = $(@).prop("checked")
      if path != undefined
        $.ajax
          url: path
          dataType: "script"
      else if f != undefined
        eval(f)    
        
  new_design_shared.bootstrapToggleUpdate = ->
    $(".bootstrap-menu-toggle-update").off "change"
    $(".bootstrap-menu-toggle-update").on "change", ->
      path = $(@).data("path")
      available_functions = {}
      available_functions["defaultTournamentPopup"] = window.crm.layout.initBootstrapDefaultTournamentPopupAction
      f = $(@).data("afunction")
      checked = $(@).prop("checked")
      $.ajax
        url: path
        dataType: "script"
        success: ->
          $("#round_panel_selector").change();
          if f != undefined && available_functions[f] != undefined && checked
            available_functions[f]()
            
  new_design_shared.bootstrapMakeLeaguePublic = ->
    $(".bootstrap-toggle-visibility-update").off "change"
    $(".bootstrap-toggle-visibility-update").on "change", ->
      toggle_url = $(@).data("path")
      $.ajax
        url: toggle_url
        dataType: "json"
        type: "GET"
        complete: ->
          if $("#is_public").is(":checked")
            $("#make_league_public").modal("show")
            $("#make_league_public").appendTo("body")
    
    $(document).off "click", "#make_league_public .save_button"
    $(document).on "click", "#make_league_public .save_button", ->
      $("#make_league_public .save_button").text("Please wait...")
      url = $("input#is_public").data("websitePath")
      $.ajax
       url: url
       dataType: "json"
       type: "PATCH"
       complete: ->
        $("#make_league_public .save_button").text("All pages are now public.")
        setTimeout ->
          $("#make_league_public").modal("hide")
          window.location.reload()
        ,1500
  
  new_design_shared.submitSelectTournamentForm = ->
    $(document).off "click", "#select_default_tournament .save_button"
    $(document).on "click", "#select_default_tournament .save_button", ->
      $("form.default_tournament_mobile_score_entry").submit()
      
      l1 = window.location.href.length
      l2 = "/scorecards".length
      i1 = window.location.href.indexOf("/scorecards")
      
      if i1 > -1 && l1 - i1 == l2
        window.location.reload()
      else
        $(".select_default_tournament").modal("hide")
  
  new_design_shared.playingDivisionsModal = ->
    $(document).off "click", "#choose_divisions"
    $(document).on "click", "#choose_divisions", ->
      window.crm.new_design_shared.modaliChecks("#choose_playing_divisions_modal")
      $("#choose_playing_divisions_modal").modal("show")
      $("#choose_playing_divisions_modal").appendTo("body")

  new_design_shared.setContentFullHeight = (element, only_higher = "false") ->
    $(window).load ->
      window.crm.new_design_shared.computeAndApplyHeight(element, only_higher)
    $(window).on 'resize', -> 
      window.crm.new_design_shared.computeAndApplyHeight(element, only_higher)
      
  new_design_shared.computeAndApplyHeight = (element, only_higher = "false") ->
    actual_height = $(window).outerHeight(true)
    actual_width  = $(window).width()
    extra = 10
    menu_tabs_height = $(".btsp_custom_tabs_menu").outerHeight(true)
    if menu_tabs_height == 0
      menu_tabs_height = $(".btsp_custom_tabs_menu").parent().outerHeight(true)
    used_height = $(".header_navbar").outerHeight(true) + $("#breadcrumb").outerHeight(true) + menu_tabs_height + $(".alert.alert-dismissible.stick_to_breadcrumb").outerHeight(true) + $(".btsp_top_buttons_container").outerHeight(true) + $(".save_bar").outerHeight(true) + extra
    current_height = $(element).height()
    new_height = actual_height - used_height - 80
    if only_higher == "true"
      new_height = current_height
      
    $(element).height(new_height)

  new_design_shared.applyCustomScrollbar = (element, direction) ->
    setTimeout ->
      if direction == "vertical"
        $(element).perfectScrollbar({
          suppressScrollX: true
          })
      else if direction == "horizontal"
        $(element).perfectScrollbar({
          suppressScrollY: true
          })
      else
        $(element).perfectScrollbar({
          minScrollbarLength: 75
        })
    , 1500

  new_design_shared.changeActiveTab = ->
    $(document).off "click", ".btsp_custom_tabs_menu li"
    $(document).on "click", ".btsp_custom_tabs_menu li", ->
      container = $(@).closest(".btsp_custom_tabs")
      $(container).find("li.active").removeClass("active")
      $(container).find(".btsp_custom_tabs_container").scrollTop(0)
      $(container).find(".btsp_custom_tabs_container").perfectScrollbar('update')
      $(@).addClass("active")
      
  new_design_shared.applyFixedHeaderOnTable = (container_class, table_class) ->
    window.crm.new_design_shared.setContentFullHeight(container_class)
    window.crm.new_design_shared.applyCustomScrollbar(container_class)

    $(table_class).floatThead 
        position: "absolute"
        scrollTop: 85
        scrollContainer: ($table) ->
            return $(container_class)


  new_design_shared.refreshMembersTable = ->
    setTimeout ->
      $('.members_index_table').parent(".btsp_ps_container").scrollLeft($('.members_index_table').parent(".btsp_ps_container").scrollLeft() - 0.5)
      if $(".select_members_popup").length > 0
        window.crm.new_design_shared.modaliChecks(".select_members_popup")
    , 20
    $('.members_index_table').floatThead('reflow')
  
  new_design_shared.menuMatchHeight = ->
    if $(window).width() > 992
      $("#nav_league_menu .top_menu_match_height").matchHeight()
      $("#nav_golfers_menu .top_menu_match_height").matchHeight()
      $("#nav_calendar_menu .top_menu_match_height").matchHeight()
      $("#nav_rounds_menu .top_menu_match_height").matchHeight()
      $("#nav_apps_menu .top_menu_match_height").matchHeight()
      $("#nav_help_menu .top_menu_match_height").matchHeight()

  new_design_shared.toggleMarginForPoweredBy = ->
    $(window).load ->
      if $("#is_jobs_page").val() == "true"
        $(".powered_by_margin").remove()
      if $(".save_bar").length == 0
        if $(".powered_by_margin").hasClass("add-margin-bottom-90")
          $(".powered_by_margin").removeClass("add-margin-bottom-90")
          $(".powered_by_margin").addClass("add-margin-bottom-30")
        else if $(".powered_by_margin").hasClass("add-margin-bottom-120")
          $(".powered_by_margin").removeClass("add-margin-bottom-120")
          $(".powered_by_margin").addClass("add-margin-bottom-50")
      
      extra = 10
      $(".min_height_main_content").css("min-height", $(window).height() - $(".min_height_main_content").offset().top - $(".powered_by_margin").outerHeight(true) - extra)

  new_design_shared.computeMinWidthForBreadcrumb = ->
    $(window).load ->
      current_width = 25
      $("#breadcrumb .arrow").each ->
        current_width += $(@).outerWidth(true)
      $("#breadcrumb .breadcrumb").css("min-width", "#{current_width}px")

  new_design_shared.replaceBrokenImages = (link) ->
    $('img').error -> 
      if $(@).attr("src").length > 0
        $(@).attr('src', link)
  
  new_design_shared.setBorderForPageTitle = ->
    $(window).on 'resize', ->
      new_design_shared.computeAndApplyBorder()
    $(window).load ->
      new_design_shared.computeAndApplyBorder()
  
  
  new_design_shared.computeAndApplyBorder = ->
    i = 1
    $(".page_title").each -> 
      $(this).find(".text").addClass("after_text_#{i}")
      width = $(this).find(".text").width()
      styleElem = document.head.appendChild(document.createElement("style"));
      color = "#B48DF8"
      if $("#powered_by").is(":visible") || $("body").hasClass("usga")
        color = "#0088CE"
      else if $("body").hasClass('golf_advisor')
        color = "#74abb9"
      else if $("body").hasClass("orange")
        color = "#B48DF8"
      else if $("body").hasClass("spring")
        color = "#87b124"
      else if $("body").hasClass("green")
        color = "#369807"
      else if $("body").hasClass("legacy")
        color = "#4c9cb3"
      else if $("body").hasClass("lightskyblue")
        color = "#1053a4"
      else if $("body").hasClass("navylightskyblue")
        color = "#1E4164"
      else if $("body").hasClass("purple")
        color = "#87489c"
      else if $("body").hasClass("red")
        color = "#d8160b"
      else if $("body").hasClass("gray")
        color = "#4f4f4f"
             
      styleElem.innerHTML = ".after_text_#{i}:after {position: absolute; bottom: -1px; left: 0; width: #{width}px; border-bottom: 1px solid #{color}; content: ''}";
      i+=1

) window.crm.new_design_shared = window.crm.new_design_shared or {}, jQuery
