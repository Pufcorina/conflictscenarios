window.starterkitrails = window.starterkitrails or {}
((shared, $) ->
  shared.init = (scrollTo) ->
    window.crm.flash.flash()
    tinymce.remove('#editor')
    tinymce.remove('#editor_without_toolbar')
    setTimeout (-> $("#flash_alert").fadeOut()), 3000
#    $('.datepicker').datepicker()
    $('[data-toggle="tooltip"]').tooltip()

    tinymce.init
      selector: '#editor'
      mode: "textareas"
      menubar: false
      paste_as_text: true
      force_br_newlines: true
      paste_remove_spans: true
      statusbar: false
      branding: false
      browser_spellcheck: true
      forced_root_block: ""
      plugins: [
        'advlist autolink lists link image charmap print preview anchor',
        'searchreplace visualblocks code fullscreen',
        'insertdatetime media table paste code help wordcount'
      ]
      toolbar1: 'undo redo | formatselect fontselect styleselect fontsizeselect | bold italic link backcolor forecolor | alignleft aligncenter alignright alignjustify'

      toolbar2: 'bullist numlist outdent indent | removeformat |'
      setup: (editor) ->
        editor.on 'init', ->
        $('#loading_gfx').css 'display', 'none'
        return

    tinymce.init
      selector: '#editor_without_toolbar'
      mode: "textareas"
      menubar: false
      statusbar: false
      branding: false
      plugins: "preview",
      readonly : 1
      toolbar: false,


    myCustomInitInstance = () ->
      debugger
      console.log('after inint')

  return
) window.starterkitrails.shared = window.starterkitrails.shared or {}, jQuery
