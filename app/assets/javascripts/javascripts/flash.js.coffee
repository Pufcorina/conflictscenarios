window.crm = window.crm or {}
((flash, $) ->

  flash.flash = ->
    if $("#flash_alert .flash-content").length > 0
      $("#flash_alert").show()
      setTimeout (-> $("#flash_alert").fadeOut()), 3000

    $(document).on 'click', "#flash_alert .delete-flash", ->
      $("#flash_alert").fadeOut()
      false

    $(document).on 'click', "#modal-flash .modal-dismiss, #modal-flash .delete-flash", ->
      $("#modal-flash").fadeOut()
      false

    $(document).on 'click', "#round_changed_message .delete-flash", ->
      $("#round_changed_message").fadeOut()
      false


    $(document).on "ajax:before", "[data-remote=true][data_loading_box=true]", (et, e) ->
      window.show_loader()

    $(document).on "ajax:complete", "[data-remote=true][data_loading_box=true]", (et, e) ->
      window.hide_loader()

    window.show_flash = (content) ->
      $("#flash_alert .flash-message").remove()
      if content.indexOf("flash-message")
        $("#flash_alert .flash-content").empty()
        $("#flash_alert .flash-content").append(content)
      else
        $("#flash_alert .flash-content").html(content)
      $("#flash_alert .loader").addClass("hidden")
      $("#flash_alert").slideDown()

    window.hide_flash = ->
      setTimeout ->
        $("#flash_alert").fadeOut()
        $("#flash_alert .flash-content").empty()
      , 3000

    window.show_loader = ->
      $("#round_changed_message").hide()
      $("#flash_alert .flash-message").remove()
      $("#flash_alert .loader").removeClass("hidden")
      $("#flash_alert").slideDown()

    window.hide_loader = ->
      $("#flash_alert").fadeOut()
) window.crm.flash = window.crm.flash or {}, jQuery
