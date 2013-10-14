Template.day.helpers(
  heatmap: ()->
    # find sum of times of today's tasks
    # TODO: Is this redundant?
    # Can I store the tasks on the day object and reference that from here reactively?
    # I'm not sure.
    dayBeginning = this.timestamp
    dayEnd = this.timestamp + 86400
    mongoQuery = { dueDate: { $gte: dayBeginning, $lt: dayEnd} }
    tasks = Tasks.find(mongoQuery, { sort: { due: -1 } }).fetch()
    totalTime = 0
    for task in tasks
      totalTime += task.duration
    color = switch
      when totalTime is 0 then 'white'
      when totalTime < 3601 then 'green'
      when totalTime < 10801 then 'yellow'
      else 'red'
    color

  todayTasks: ()->
    # `this` is the data object passed from day
    dayBeginning = this.timestamp
    dayEnd = this.timestamp + 86400
    # build query
    mongoQuery = { dueDate: { $gte: dayBeginning, $lt: dayEnd} }
    # find relevant tasks
    tasks = Tasks.find(mongoQuery, { sort: { due: -1 } }).fetch()
    tasks

  today: ()->
    if this.today
      console.log "today!"
      ' Today!'
    else
      ''
)

swapBack = (e, which, timestamp)->
  if which is 'keypress'
    $day = $(e.currentTarget).parent().parent()
  else if which is 'cover'
    $day = $(e.currentTarget).parent()
  else
    console.log 'invalid'
    return

  $herp = $($day.children()[$day.children().length-3])
  $inputter = $($day.children()[$day.children().length-2])
  $cover = $($day.children()[$day.children().length-1])

  # get task info
  taskName = $inputter.children()[0].value
  taskDuration = $inputter.children()[2].value
  if taskName == ''
    # if no name, exit without doing anything
    $herp.show()
    $inputter.hide()
    $cover.hide()
  else
    if taskDuration == ''
      taskDuration = '1 hour'
    task =
      name: taskName
      dueDate: timestamp
      estimate: taskDuration

    # make a new task
    Meteor.call 'makeTask', task, (error, id)->
      if error
        Errors.throw(error.reason)

        if error.error is 302
          Meteor.Router.to('home', error.details)

    # task should be reactively inserted!! :O :O
    # heat should be reactively inserted!!

    # wrap up
    $herp.show()
    $inputter.hide()
    $($inputter.children()[0]).val('')
    $($inputter.children()[2]).val('')
    $cover.hide()

Template.day.events(
  'click .herp': (e)->
    $day = $(e.currentTarget).parent()
    $herp_el = $($day.children()[$day.children().length-3])
    $inputter = $($day.children()[$day.children().length-2])
    $cover = $($day.children()[$day.children().length-1])
    $herp_el.hide()
    $inputter.show()
    $inputter.children()[0].focus()
    $cover.show()

  'click .dayInputCover': (e)->
    swapBack(e, 'cover', this.timestamp)

  'keypress .checker': (e)->
    if (e.keyCode == 13)
      swapBack(e, 'keypress', this.timestamp)

)
