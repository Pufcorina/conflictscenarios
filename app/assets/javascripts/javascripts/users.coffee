window.crm = window.crm or {}
((users, $) ->

  users.init = ->
    $(document).off 'click', '#reset_search'
    $(document).on 'click', '#reset_search', ->
      $('#user_search_name, #user_search_email, #user_search_phone').val('')
      $('#user_search_admin, #user_search_manager, #user_search_employee').prop("checked", false)


) window.crm.users = window.crm.users or {}, jQuery
