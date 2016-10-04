$ ->
  $("#assignments").on("cocoon:after-insert", (e, inserted) ->
    $(".chosen", inserted).chosen(width: "100%")
  )
