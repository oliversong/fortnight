Template.task.helpers(
  # return 'checked' if task is completed
  # return nothing is task is incomplete
  checked: ()->
    task = Tasks.findOne( { _id: @_id })
    if task.completed is true
      'checked'
    else
      ''

)

Template.task.events(
  'click .toggle': (e)->
    checked = $(event.currentTarget).next().hasClass('checked')

    unless checked
      # submit check
      Meteor.call('completeTask', @_id)
    else
      # submit uncheck
      Meteor.call('uncompleteTask', @_id)

  'dblclick .taskName': (e)->
    $this_el = $(event.currentTarget).parent()
    $task_name = $($this_el.children()[1])
    $edit_field = $($this_el.children()[2])
    $input_cover = $($this_el.children()[3])
    if $edit_field.css('dispay','none')
      $task_name.hide()
      $edit_field.show()
      $input_cover.show()
      $edit_field.focus()

  'click .taskInputCover': (e)->
    swapBack(this, 'cover')

  'keypress .nameEdit': (e)->
    if (e.keyCode == 13)
      swapBack(this, 'key')

  'keypress .estimateEdit': (e)->
    if (e.keyCode == 13)
      swapBack(this, 'key')

  'click .deleteTask':(e)->
    Meteor.call('deleteMe', @_id)
)

swapBack = (task, which)->
  if which is 'cover'
    $this_el = $(event.currentTarget).parent()
  else
    $this_el = $(event.currentTarget).parent().parent()

  ho = $this_el.children()
  $task_name = $(ho[1])
  $edit_fields = $(ho[2])
  $input_cover = $(ho[3])

  new_name = $($edit_fields.children()[0])
  new_estimate = $($edit_fields.children()[2])

  Meteor.call('update', task._id, new_name.val(), new_estimate.val())
  $task_name.show()
  $edit_fields.hide()
  $input_cover.hide()

Template.task.rendered = ()->
  $(this.find('.task')).draggable(
    revert: true
  )
