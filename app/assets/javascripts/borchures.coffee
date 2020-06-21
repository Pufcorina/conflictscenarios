window.crm = window.crm or {}
((brochures, $) ->
  brochures.init = () ->
  
    $('[data-toggle="tooltip"]').tooltip();


    # edit title / description
    $(document).off 'click', '#btn_edit_title, #btn_edit_description, #btn_edit_subdescription'
    $(document).on 'click', '#btn_edit_title, #btn_edit_description, #btn_edit_subdescription', ->
      type = $(@).attr("data-type")
      object_type = $(@).closest("."+type)
      $('#'+type).addClass('background_grey').removeClass('background_light_grey')
      $('#btn_save_'+type).removeClass('hidden')
      object_type.addClass("editing")
      object_type.removeClass("previewing")



    # save title / description
    $(document).off 'click', '#btn_save_title, #btn_save_description, #btn_save_subdescription'
    $(document).on 'click', '#btn_save_title, #btn_save_description, #btn_save_subdescription', ->

      type = $(@).attr("data-type")
      object_type = $("#"+type)
      object_type.addClass('background_light_grey').removeClass('background_grey')
      $('#btn_save_'+type).addClass('hidden')
      object_type.removeClass("editing")
      object_type.addClass("previewing")

      if type == 'title'
        if $('#brochure_title').val() != ""
          newtitle = $('#brochure_title').val()
        else
          newtitle = "brochure Title"
        $('#title_text_content').html(newtitle)
      else
        if $("#brochure_#{type}").val() != ""
          newdescription = $("#brochure_#{type}").val()
        else
          newdescription = ""
          hide_description_fields(type)
        $("##{type}_text_content").html(newdescription)

      return

    # show description edit fields
    $(document).off 'click', '#btn_description, #btn_subdescription'
    $(document).on 'click', '#btn_description, #btn_subdescription', ->
      type = $(@).attr("data-type")
      description = $("##{type}")
      description.removeClass("empty_description")
      description.addClass("editing")
      $("#btn_#{type}").addClass('hidden')
      $("#btn_save_#{type}").removeClass('hidden')
      $("##{type}").removeClass('background_light_grey').addClass('background_grey')
      return

#    # hide description edit fields
    $(document).off 'click', '#btn_delete_description, #btn_delete_subdescription'
    $(document).on 'click', '#btn_delete_description, #btn_delete_subdescription', ->
      type = $(@).attr("data-type")
      hide_description_fields(type)
      $("#brochure_#{type}").val('')
      return

    hide_description_fields = (type)->
      description = $("##{type}")
      description.addClass("empty_description")
      description.removeClass("editing").removeClass("previewing")
      $("#btn_#{type}").removeClass('hidden')
      $("#btn_save_#{type}").addClass('hidden')
      $("##{type}").removeClass('background_light_grey').removeClass('background_grey')


    $(document).off 'click', '#add_survey'
    $(document).on 'click', '#add_survey', ->
      $($('#surveys .hidden')[0]).removeClass('hidden')

    $(document).off 'click', '.remove_survey_brochure'
    $(document).on 'click', '.remove_survey_brochure', ->
      index = $(@).attr('data-index')
      $("#survey_#{index}").val('0')
      $("#select2-survey_#{index}-container").html("Te rog selecteaza un scenariu.").attr('title', 'Te rog selecteaza un scenariu.')

      $($('#surveys').children()[index]).addClass('hidden')


    # brochure validation
    $(document).off 'click', '#btn_save_brochure'
    $(document).on 'click', '#btn_save_brochure', ->
      
      if $('#brochure_title').val() == ""
        alert("Titlul brosurii nu poate fi gol!")
        return false

    $('.custom_pagination a').click (e)->
      window.history.pushState(null, null, this.href)
      $.rails.handleRemote($(this))
      return false
    return
) window.crm.brochures = window.crm.brochures or {}, jQuery
