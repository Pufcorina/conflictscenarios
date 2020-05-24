window.crm = window.crm or {}
((surveys, $) ->
  surveys.init = () ->
  
    $('[data-toggle="tooltip"]').tooltip();

    $(document).off 'click', '#btn_logo'
    $(document).on 'click', '#btn_logo', ->
    $('#logo').removeClass('hidden')
    $('#btn_logo').addClass('hidden')

    $(document).off 'click', '#btn_edit_logo'
    $(document).on 'click', '#btn_edit_logo', ->
      $('#btn_delete_logo').css('display', 'block')
      $('#logo_object').removeClass('logo_image_hover')
      $('#btn_select_logo, #btn_save_logo').removeClass('hidden')

    $(document).off 'click', '#btn_delete_logo'
    $(document).on 'click', '#btn_delete_logo', ->
      $('#btn_delete_logo').css('display', 'none')
      $('#logo').addClass('hidden')
      $('#btn_logo').removeClass('hidden')
      document.getElementById("logo_title").style.color = "rgb(102,102,102)!important"

      elem = document.createElement("img")
      elem.setAttribute("src", "noimage.png")
      elem.setAttribute("alt", "NoImage");
      document.getElementsByClassName("logo_image_survey").appendChild(elem)
      return

    $(document).off 'change', '.fileupload-new'
    $(document).on 'change', '.fileupload-new', ->
      document.getElementById("logo_title").style.color = "white"


    #question + index in case of removing
    item_global = null
    index_global = null
    item_next_global = null
    item_prev_global = null


    #get selected question for removing
    $(document).off 'click', '.btn_delete_question'
    $(document).on 'click', '.btn_delete_question', ->
      item_global = $(@)[0].parentElement.parentElement.parentElement
      index_global = $('#question_list').find($('#'+item_global.id)).index()
      item_next_global = item_global.nextElementSibling
      item_prev_global = item_global.previousElementSibling
      return

    #wait for removing question and reset questions order 
    $("#survey_container").on "cocoon:after-remove", (e, rule)->
      console.log("delete:"+ index_global)

      $('#' + item_global.id).removeClass('question').removeClass('question_sortable_default_class').removeClass('ui-sortable-handle')
      $('#' + item_global.id).css('display', 'none')
      old_item = $('#' + item_global.id)[0]
      item_global.remove()
      $('#question_list').append(old_item)

      if item_next_global
        update_order_questions_next(item_next_global, index_global+1)
      if item_prev_global
        update_order_questions_previous(item_prev_global, index_global)
      return

    $(document).off 'click', '.change'
    $(document).on 'click', '.change', ->
      $('#logo').addClass('hidden')
      $('#btn_logo').removeClass('hidden')

    #rank for questions
    if ($('.question').length <= 1) then rank = 1 else rank = $('.question').length

    # question setup ids, when adding a new question
    $("#survey_container").on "cocoon:after-insert", (e, rule)->
      last_q = $('.question:last')
      rank = rank + 1
      order = $('.question').length
      console.log("insert:"+ rank)
      last_q.find('.question_rank_title').html('Q'+order)
      last_q.find('.order_number').val(order)
      last_q.find('.btn_save_question').attr('id', 'btn_save_'+rank)
      last_q.find('.btn_edit_question').attr('id', 'btn_edit_'+rank)
      last_q.find('.btn_delete_question').attr('id', 'btn_delete_'+rank)
      last_q.find('.question_type').attr('id', 'question_type_'+rank)
      last_q.find('.question_text').attr('id', 'question_text_'+rank)
      last_q.find('.question_select').attr('id', 'question_select_'+rank)
      last_q.find('.free_text').attr('id', 'free_text_question_option_'+rank)
      last_q.find('.question_title_text_form').attr('id', 'question_title_text_form'+rank)
      last_q.attr('id', 'question_'+rank)
      $('.select2').select2({})

    # option setup ids, when adding a new option
    $(".question").on "cocoon:after-insert", (e, rule)->
      question_rank = this.id.replace('question_', '')
      if $('#question_type_'+question_rank).val() == 'multiple_choice'
        option_type = this.getElementsByClassName('multiple_choice_fields')[0]
      else
        option_type = this.getElementsByClassName('multiple_answers_fields')[0]

      option_list = option_type.getElementsByClassName('option_form')
      last_o = option_list[option_list.length - 1]
      rank = option_list.length
      last_o.id = last_o.id+rank
      if $('#question_type_'+question_rank).val() == 'multiple_choice'
        last_o.getElementsByClassName('radio_button')[0].id = 'radio_'+question_rank+'_option_'+rank
        last_o.getElementsByClassName('radio_button_tag')[0].id = 'radio_'+question_rank+'_option_button_option_'+rank
      else
        last_o.getElementsByClassName('checkbox_option')[0].id = 'checkbox_'+question_rank+'_option_'+rank
      last_o.getElementsByClassName('glyphicon-trash')[0].id = 'btn_delete_'+question_rank+'_option_'+rank

    # updates selector views for question type (multiple choice, multiple answers, free text)
    $(document).off 'change', '.question_type'
    $(document).on 'change', '.question_type', ->
      if $(@).val() == "free_text"
        $(@).closest(".question").find(".free_text_field").removeClass("hidden")
        $(@).closest(".question").find(".multiple_choice_fields").addClass("hidden")
        $(@).closest(".question").find(".multiple_answers_fields").addClass("hidden")
      else if $(@).val() == "multiple_choice"
        $(@).closest(".question").find(".free_text_field").addClass("hidden")
        $(@).closest(".question").find(".multiple_choice_fields").removeClass("hidden")
        $(@).closest(".question").find(".multiple_answers_fields").addClass("hidden")
      else if $(@).val() == "multiple_answers"
        $(@).closest(".question").find(".free_text_field").addClass("hidden")
        $(@).closest(".question").find(".multiple_choice_fields").addClass("hidden")
        $(@).closest(".question").find(".multiple_answers_fields").removeClass("hidden")
      else
        $(@).closest(".question").find(".free_text_field").addClass("hidden")
        $(@).closest(".question").find(".multiple_choice_fields").addClass("hidden")
        $(@).closest(".question").find(".multiple_answers_fields").addClass("hidden")


    $(document).off 'change', '#logo_on'
    $(document).on 'change', '#logo_on', ->
      if $("#logo_on").prop('checked')
        $('.logo_container_display').css('display', 'block')
        $('#body_container_item').css('width', '50%').css('padding','0px 15px 0px 15px')
      else
        $('.logo_container_display').css('display', 'none')
        $('#body_container_item').css('width', '102%').css('padding','0px 100px 0px 100px')
      return

    # edit title / description
    $(document).off 'click', '#btn_edit_title, #btn_edit_description'
    $(document).on 'click', '#btn_edit_title, #btn_edit_description', ->
      type = $(@).attr("data-type")
      object_type = $(@).closest("."+type)
      $('#'+type).addClass('background_grey').removeClass('background_light_grey')
      $('#btn_save_'+type).removeClass('hidden')
      object_type.addClass("editing")
      object_type.removeClass("previewing")



    # save title / description
    $(document).off 'click', '#btn_save_title, #btn_save_description'
    $(document).on 'click', '#btn_save_title, #btn_save_description', ->
      type = $(@).attr("data-type")
      object_type = $("#"+type)
      object_type.addClass('background_light_grey').removeClass('background_grey')
      $('#btn_save_'+type).addClass('hidden')
      object_type.removeClass("editing")
      object_type.addClass("previewing")

      if type == 'title'
        if $('#survey_title').val() != ""
          newtitle = $('#survey_title').val()
        else
          newtitle = "Survey Title"
        $('#title_text_content').html(newtitle)
      else
        if $('#survey_description').val() != ""
          newdescription = $('#survey_description').val()
        else
          newdescription = ""
          hide_description_fields()
        $('#description_text_content').html(newdescription)

      return

    # show description edit fields
    $(document).off 'click', '#btn_description'
    $(document).on 'click', '#btn_description', ->
      description = $("#description")
      description.removeClass("empty_description")
      description.addClass("editing")
      $('#btn_description').addClass('hidden')
      $('#btn_save_description').removeClass('hidden')
      $('#description').removeClass('background_light_grey').addClass('background_grey')
      return

#    # hide description edit fields
    $(document).off 'click', '#btn_delete_description'
    $(document).on 'click', '#btn_delete_description', ->
      hide_description_fields()
      $('#survey_description').val('')
      return

    hide_description_fields = ->
      description = $("#description")
      description.addClass("empty_description")
      description.removeClass("editing").removeClass("previewing")
      $('#btn_description').removeClass('hidden')
      $('#btn_save_description').addClass('hidden')
      $('#description').removeClass('background_light_grey').removeClass('background_grey')

    # edit question
    $(document).off 'click', '.btn_edit_question'
    $(document).on 'click', '.btn_edit_question', ->
      question = $(@).closest(".question")

      #toggle grey shade
      question.removeClass('background_light_grey').addClass('background_grey')

      #toggle question mode: viewing/editing
      question.addClass("editing")
      question.removeClass("previewing")



    # save question
    $(document).off 'click', '.btn_save_question'
    $(document).on 'click', '.btn_save_question', ->

      question = $(@).closest(".question")
      question_type = question.find(".question_type").val()
      title_text = question.find(".question_name_input").val()

      #validate title
      if title_text == ""
        alert("Question title cannot be empty!")
        return false
      else
        #validate question options
        if (question_type == "multiple_choice" || question_type == "multiple_answers")
          options_filled = 0
          question.find(".#{question_type}_fields .option_input").each ()->
            option_title = $(@).val()
            if option_title != ""
              options_filled = options_filled + 1

          if (options_filled < 2)
            alert("The question must have at least two valid options!")
            return false
        #toggle grey shade
        question.addClass('background_light_grey').removeClass('background_grey')

        #clone question title
        question.find(".question_title_preview").html(title_text)

        #clone multipe inputs to labels or remove blank options from selected type
        question.find(".#{question_type}_fields .option_input").each ()->
          option_title = $(@).val()
          if option_title != ""
            $(@).parent().find("span.preview").html(option_title)
          else
            $(@).closest(".option_form").remove()

        #toggle question mode: viewing/editing
        question.removeClass("editing")
        question.addClass("previewing")

        #reset options
        if question_type == "multiple_choice"
          question.find(".multiple_answers_fields").find('.option_input').each ->
            $(this).val("")
            id = $(this)[0].id
            id_destroy = id.replace('title', '_destroy')
            $('#'+id_destroy).val(1)
        else
          if question_type == "multiple_answers"
            question.find(".multiple_choice_fields").find('.option_input').each ->
              $(this).val("")
              id = $(this)[0].id
              id_destroy = id.replace('title', '_destroy')
              $('#'+id_destroy).val(1)
          else
            question.find(".multiple_answers_fields, .multiple_choice_fields").find('.option_input').each ->
              $(this).val("")
              id = $(this)[0].id
              id_destroy = id.replace('title', '_destroy')
              $('#'+id_destroy).val(1)
              
      return true

    # survey validation
    $(document).off 'click', '#btn_save_survey'
    $(document).on 'click', '#btn_save_survey', ->
      
      if $('#survey_title').val() == ""
        alert("Survey title cannot be empty!")
        return false

      if $('.question').length == 0
        alert("Please add at least one question")
        return false

      if $('.question.editing').length > 0
        alert("Please save all questions")
        return false


    #update next questions
    update_order_questions_next = (item, next_index) ->
      id_moved_element = item.id
      if id_moved_element != "disable_sortable_new_question_btn" && $('#'+id_moved_element).hasClass('question')
        $("#"+id_moved_element).find('.order_number').val(next_index)
        $("#"+id_moved_element).find('.question_rank_title').html("Q"+next_index)
        next_index = next_index + 1

      if item.nextElementSibling
        item = item.nextElementSibling
        update_order_questions_next(item, next_index)
      return

    #update previous questions
    update_order_questions_previous = (item, prev_index) ->
      id_moved_element = item.id
      if id_moved_element != "disable_sortable_new_question_btn" && $('#'+id_moved_element).hasClass('question')
        $("#"+id_moved_element).find('.order_number').val(prev_index)
        $("#"+id_moved_element).find('.question_rank_title').html("Q"+prev_index)
        prev_index = prev_index - 1

      if item.previousElementSibling
        item = item.previousElementSibling
        update_order_questions_previous(item, prev_index)
      return

    # drag and drop questions
    $("#question_list").sortable 
      items: '.question_sortable_default_class'
      start: (event, ui) ->
        ui.item.data 'start_pos', ui.item.index()
        return
      stop: (event, ui) ->
        start_pos = ui.item.data('start_pos')
        if start_pos != ui.item.index()
          # the item got moved
        else
          # the item was returned to the same position
        return
      update: (event, ui) ->
        index_moved_element = ui.item.index() + 1
        item = ui.item[0]
        id_moved_element = item.id

        if id_moved_element != "disable_sortable_new_question_btn"
          $("#"+id_moved_element).find('.order_number').val(index_moved_element)
          $("#"+id_moved_element).find('.question_rank_title').html("Q"+index_moved_element)
          if item.nextElementSibling
            item_next = item.nextElementSibling
            update_order_questions_next(item_next, index_moved_element + 1)

          if item.previousElementSibling
            item_prev = item.previousElementSibling
            update_order_questions_previous(item_prev, index_moved_element - 1)
        return

    $('.custom_pagination a').click (e)->
      window.history.pushState(null, null, this.href)
      $.rails.handleRemote($(this))
      return false
    return
) window.crm.surveys = window.crm.surveys or {}, jQuery
