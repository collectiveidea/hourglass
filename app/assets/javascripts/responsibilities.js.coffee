class ResponsibilityList
  @init: ->
    new @

  constructor: ->
    @el = $(".responsibility-list")
    @table = @el.find(".responsibility-table")

    @listen()
    @initSortableRows()

  listen: ->
    @table.on "sortupdate", @saveOrder

  initSortableRows: ->
    @table.sortable
      axis: "y"
      handle: ".responsibility-row-drag-handle"
      items: ".responsibility-row"

  saveOrder: (event, ui) =>
    $row = ui.item

    id = $row.data("id")
    position = $row.index()

    $.ajax
      url: "/responsibilities/#{id}/reorder"
      method: "PUT"
      data:
        position: position

$ ->
  ResponsibilityList.init()
