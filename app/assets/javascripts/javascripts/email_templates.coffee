window.gems = window.gems or {}
((email_templates, $) ->
  email_templates.init = (froala_key) ->

    validate_emails = (emails) ->
      if emails
        emails_arr = emails.split(',')
        rgx = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
        regex_data_fields = /\%(.*?)%/
        i = 0
        ok = true
        while (i < emails_arr.length) && ok
          if regex_data_fields.test(emails_arr[i].replace(/\s/g, ''))
            emails_arr[i] = emails_arr[i].replace(/%.*%/, '').replace(/\s/g, '')
          if emails_arr[i] != ""
            ok = rgx.test(emails_arr[i].replace(/\s/g, ''))
          i = i + 1
        return ok
      else
        return true


    # send survey - send email to selectors
    $(document).off 'click', '#checkbox_all_golfers, #checkbox_specific_golfers, #checkbox_select_by'
    $(document).on 'click', '#checkbox_all_golfers, #checkbox_specific_golfers, #checkbox_select_by', ->
      id = $(@).attr('id')
      if id ==  'checkbox_all_golfers'
        $('#specific_golfers_modal, #specific_members').val('') # for edit link
        $('#edit_select_by, #edit_specific_golfers').addClass('hidden')
        $('#active_filters').val('all')
        reset_members_modal()
      if id == 'checkbox_select_by' && $('#select_by_modal').val() != 'edit'
        $('#field_type').val(null).trigger('change')
        $('#action_filter').val("Include").trigger('change')
        $('#specific_golfers_modal, #specific_members, #specific_members').val('')
        $('#select_by_modal').val('edit')
        $(".email_select_by, #select_by_modal, #edit_select_by").removeClass('hidden')
        $(".email_select_golfers, #specific_golfers_modal, #edit_specific_golfers").addClass('hidden')
        $('#modalSelectMembers').modal({backdrop: 'static', keyboard: true});
        reset_members_modal()
      if id == 'checkbox_specific_golfers' && $('#specific_golfers_modal').val() != 'edit'
        $('#specific_golfers_modal').val('edit')
        $('#select_by_modal, #active_filters').val('')
        $('#members_filters_list').html('None')
        $(".email_select_by, #select_by_modal, #edit_select_by").addClass('hidden')
        $(".email_select_golfers, #specific_golfers_modal, #edit_specific_golfers").removeClass('hidden')
        $('#modalSelectMembers').modal({backdrop: 'static', keyboard: true});
      $('#checkbox_no_golfers, #checkbox_all_golfers, #checkbox_specific_golfers, #checkbox_select_by').prop('checked', false)
      $('#'+id).prop('checked', true)
      return

    #  open specific_golfers or select_by modal (edit mode)
    $(document).off 'click', '#edit_specific_golfers, #edit_select_by'
    $(document).on 'click', '#edit_specific_golfers, #edit_select_by', ->
      id = $(@).attr('id')
      if id == 'edit_select_by'
        $('#field_type').val(null).trigger('change')
        $('#action_filter').val("Include").trigger('change')
        $(".email_select_by, #select_by_modal").removeClass('hidden')
        $(".email_select_golfers, #specific_golfers_modal").addClass('hidden')
        $('#modalSelectMembers').modal({backdrop: 'static', keyboard: true});
      if id == 'edit_specific_golfers'
        $(".email_select_by, #select_by_modal").addClass('hidden')
        $(".email_select_golfers, #specific_golfers_modal").removeClass('hidden')
        $('#modalSelectMembers').modal({backdrop: 'static', keyboard: true});
      return

    # select golfers - check  /  uncheck member
    $(document).off 'change', '.select_member_checkbox'
    $(document).on 'change', '.select_member_checkbox', ->
      specific_members = $('#specific_members').val()
      member_id =  $(@).attr('id')
      if specific_members.includes(member_id)
        $('#specific_members').val(specific_members.replace(member_id, ''))
      else
        if specific_members != ''
          $('#specific_members').val(specific_members + ', '  + member_id)
        else
          $('#specific_members').val(member_id)

      return


    # send survey - add new filter
    $(document).off 'click', '#add_members_filter'
    $(document).on 'click', '#add_members_filter', ->
      if $('#members_filters_list').html()=="None"
        $('#members_filters_list').html('')
      in_out = $('#action_filter').val();
      metadatum_id =  $('#field_type').val().split('.')[1]
      metadatum_name = $('#field_type option:selected').text();
      value = $('#value_equal_to').val();
      active_filters = $('#active_filters').val();
      if metadatum_id && value
        filter_container = "<div data-filter='filter_"+metadatum_name+":"+in_out+"_"+metadatum_id+"_"+value+"'><b>"+in_out+"</b> golfers with <b>"+metadatum_name+"</b> equal to <b>"+value+"</b><a class='fa fa-trash-o delete_filter' style='color:red; padding-left: 5px'></a><div>"
        if active_filters == "all"
          $('#members_filters_list').html(filter_container)
          $('#active_filters').val("filter_"+metadatum_name+":"+in_out+'_'+metadatum_id+'_'+value);
        else
          $('#members_filters_list').append(filter_container)
          $('#active_filters').val(active_filters+",filter_"+metadatum_name+":"+in_out+'_'+metadatum_id+'_'+value);
        $('#field_type').val(null).trigger('change')
        $('#action_filter').val("Include").trigger('change')
      else
        alert("Please select both the custom field and the value")
        return false

      return

    # send survey - delete new filter
    $(document).off 'click', '.delete_filter'
    $(document).on 'click', '.delete_filter', ->
      filter = $(@).parent('div').attr('data-filter');
      $('#active_filters').val($('#active_filters').val().replace(filter, ""));
      $(@).parent('div').remove();
      if !$('#active_filters').val().includes('filter')
        $('#active_filters').val("all")
        $('#members_filters_list').html("None")

    $(document).off 'click', '.fa-trash.delete_row'
    $(document).on 'click', '.fa-trash.delete_row', ->
      row_index = $(@).attr('data-row')
      $('.col-12[data-row-form="'+row_index+'"').remove()



    $(document).off 'click', '#add_row'
    $(document).on 'click', '#add_row', ->
      $('.form_row.hidden').first().removeClass('hidden')
      $('.fa-trash.delete_row.hidden').first().removeClass('hidden')

    $(document).off 'click', '#assign'
    $(document).on 'click', '#assign', ->
      $('#assign_members').submit()

    # send survey metadatum values for selected metadatum
    $(document).off 'change', '#field_type'
    $(document).on 'change', '#field_type', ->
      field = $(@).val();
      $.ajax
        type: 'GET'
        contentType: 'application/json; charset=utf-8'
        url: '/customers/'+$('#customer_id').val()+'/surveys/get_member_metatum_values'
        data: {
          field: field
        }
        dataType: 'script'
        success: (result) ->
          return
        error: ->
          console.log('an error has occurred!')
          return
      return

    email_templates.get_brochure = ->
      brochure_id = $('#brochure').val()
      $.ajax
        type: 'POST'
        url: '/get_brochure'
        data: {
          brochure_id: brochure_id
        }
        dataType: 'html'
        success: (result) ->
          $('#brochure_form').html(result);
          return
        error: ->
          console.log('an error has occurred!')
          return
      return



  email_templates.emailTemplateSpecificMembersModal = ->
# reset search member in specific golfer modal
    $(document).off 'click', '#reset_search_members_email'
    $(document).on 'click', '#reset_search_members_email', ->
      reset_members_modal()
      return

    # on key pressed search member in specific golfer modal
    $(document).off 'input', '#search_members_input'
    $(document).on 'input', '#search_members_input', ->
      if $('#search_members_input').val() == ''
        reset_members_modal()
      else
        $('#search_members_email_form').submit()
      return

  reset_members_modal = () ->
    $('#search_members_email').val('')
    initial_href = $(location).attr("href").split('?')[0]
    window.history.pushState(null, null, initial_href)
    $.rails.handleRemote($(this))
    return

) window.gems.email_templates = window.gems.email_templates or {}, jQuery
