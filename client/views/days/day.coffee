Template.day.helpers(
)

swapBack = (which)->
  debugger
  if which is 'keypress'
    $day = $(event.currentTarget).parent().parent()
  else if which is 'click cover'
    $day = $(event.currentTarget).parent()
  else
    console.log 'invalid'
    return

  $herp = $($day.children()[$day.children().length-3])
  $inputter = $($day.children()[$day.children().length-2])
  $cover = $($day.children()[$day.children().length-1])

  # get task info
  task_name = inputter.children()[0].value
  task_duration = inputter.children()[2].value
  task_date = this_el.children()[0].innerHTML
  if task_name == ''
    # if no name, exit without doing anything
    herp.show()
    inputter.hide()
    cover.hide()
  else
    if task_duration == ''
      task_duration = '1 hour'
    task =
      name: task_name
      date: task_date
      length: task_duration
      completed: false
      id: -1
      name: task_name

    # make a new task
    Meteor.call 'makeTask', task, (error, id)->
      if error
        Meteor.Errors.throw(error.reason)

        if error.error is 302
          Meteor.Router.to('home', error.details)

    # insert task html before herp el
    # assign task the returned id from collection

    # update heatmap
    if new_task.details.estimate == undefined
      this.total_time += 3600
    else
      this.total_time += parseInt(new_task.details.estimate)
    this.update_heat()

    # wrap up
    herp.show()
    inputter.hide()
    $(inputter.children()[0]).val('')
    $(inputter.children()[2]).val('')
    cover.hide()

updateHeat = ()->
  color = switch
    when this.total_time is 0 then '#FFF'
    when this.total_time < 3601 then '#d6f5d8'
    when this.total_time < 10801 then '#f8f4ba'
    else '#f7aeae'
  this.$el.css('background-color',color)

Template.day.events(
  'click .herp': (e)->
    $day = $(event.currentTarget).parent()
    $herp_el = $($day.children()[$day.children().length-3])
    $inputter = $($day.children()[$day.children().length-2])
    $cover = $($day.children()[$day.children().length-1])
    $herp_el.hide()
    $inputter.show()
    $inputter.children()[0].focus()
    $cover.show()

  'click .inputCover': (e)->
    swapBack('click cover')

  'keypress .checker': (e)->
    if (e.keyCode == 13)
      swapBack('keypress')

)
