window.crm = window.crm or {}
((policies, $) ->
  policies.init = ->
    $(document).off 'click', '#edit_policy_update_button'
    $(document).on 'click', '#edit_policy_update_button', ->
    $('#preview_policy').html(tinymce.get('#editor_without_toolbar').getContext());

) window.crm.policies = window.crm.policies or {}, jQuery
