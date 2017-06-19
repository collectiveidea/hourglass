$ ->
  $("#assignments").on "cocoon:after-insert", (_, inserted) ->
    $(".select2", inserted).select2
      theme: "bootstrap"
