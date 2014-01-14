secondsPerDay = 86400
now = new Date()
start = new Date(now.getFullYear(), now.getMonth(), now.getDate())
# today's floored unix timestamp
timestamp = start / 1000
# today's day index
dayNumber = now.getDay()
# move this back to the last Sunday
sunday = timestamp - (dayNumber) * secondsPerDay
Session.set('firstDay', sunday)

# Returns an ordered list of name, timestamp hashes
buildData = ()->
  secondsPerDay = 86400
  now = new Date()
  start = new Date(now.getFullYear(), now.getMonth(), now.getDate())
  # today's floored unix timestamp
  today = start / 1000
  # get the target first day- should be reactive!
  firstDay = Session.get('firstDay')
  # make bucket for every day, but leave task aggregating to the days
  buckets = {
    'first': [
      {'name':'','timestamp':0,'today':false},
      {'name':'','timestamp':0,'today':false},
      {'name':'','timestamp':0,'today':false},
      {'name':'','timestamp':0,'today':false},
      {'name':'','timestamp':0,'today':false},
      {'name':'','timestamp':0,'today':false},
      {'name':'','timestamp':0,'today':false}
    ],
    'second': [
      {'name':'','timestamp':0,'today':false},
      {'name':'','timestamp':0,'today':false},
      {'name':'','timestamp':0,'today':false},
      {'name':'','timestamp':0,'today':false},
      {'name':'','timestamp':0,'today':false},
      {'name':'','timestamp':0,'today':false},
      {'name':'','timestamp':0,'today':false}
    ]
  }

  # add timestamps to buckets
  for count in [0..6]
    buckets['first'][count%7]['timestamp'] = firstDay + count * secondsPerDay
    if buckets['first'][count%7]['timestamp'] is today
      buckets['first'][count%7]['today'] = true

  for count in [7..13]
    buckets['second'][count%7]['timestamp'] = firstDay + count * secondsPerDay
    if buckets['second'][count%7]['timestamp'] is today
      buckets['second'][count%7]['today'] = true

  # add day names to buckets
  firstDayNames = getDayNames(buckets['first'][0]['timestamp']*1000)
  for day in [0..6]
    buckets['first'][day%7]['name'] = firstDayNames[day]
  secondDayNames = getDayNames(buckets['second'][0]['timestamp']*1000)
  for day in [0..6]
    buckets['second'][day%7]['name'] = secondDayNames[day]

  buckets

getDayNames = (mondayTimestamp)->
  msPerDay = 86400000
  msPerHour = 3600000
  msPerMinute = 60000
  weekdays = ["SUN", "MON", "TUES", "WED", "THUR", "FRI", "SAT"]
  dayNames = []
  currentDate = new Date(mondayTimestamp)

  for x in [0..6]
    dayName = weekdays[currentDate.getDay()]
    dayMonth = currentDate.getMonth() + 1
    dayDate = currentDate.getDate()
    name = dayName + " " + dayMonth + "/" + dayDate
    dayNames.push(name)
    # go to tomorrow
    newDate = new Date(currentDate.getTime() + msPerDay)
    # check for DST change
    if newDate.getTimezoneOffset() isnt currentDate.getTimezoneOffset()
      offset = newDate.getTimezoneOffset() - currentDate.getTimezoneOffset() # time different in minutes
    else
      offset = 0
    currentDate = new Date(currentDate.getTime() + msPerDay + offset * msPerMinute)

  dayNames

Template.homePage.helpers(
  data: ()->
    buildData()

  augmentedCountit: ->
    shit = []
    for i in [0..6]
      shit.push {'index':i}
    self = this
    _.map shit, (p) ->
      p.parent = self
      p

)

Template.homePage.events(
  'click .chevron-left': (e)->
    secondsPerDay = 86400
    temp = Session.get('firstDay')
    Session.set('firstDay', temp - secondsPerDay*7)

  'click .chevron-right': (e)->
    secondsPerDay = 86400
    temp = Session.get('firstDay')
    Session.set('firstDay', temp + secondsPerDay*7)

  # take all the tasks in these two weeks
  # place them intelligently into plans for this week
  'click .autoplan': (e)->
    # get two weeks of tasks
    secondsPerDay = 86400
    now = new Date()
    start = new Date(now.getFullYear(), now.getMonth(), now.getDate())
    # today's floored unix timestamp
    timestamp = start / 1000
    # today's day index
    dayNumber = now.getDay()
    # move this back to the last Sunday
    weekBeginning = timestamp - (dayNumber) * secondsPerDay
    weekEnd = weekBeginning + 7*secondsPerDay

    nextBeginning = weekBeginning + 7*secondsPerDay
    nextEnd = weekEnd + 7*secondsPerDay

    # don't get tasks for days that are already past
    firstWeekQuery = { dueDate: { $gte: timestamp, $lt: weekEnd} }
    secondWeekQuery = { dueDate: { $gte: nextBeginning, $lt: nextEnd}}

    firstWeekTasks = Tasks.find(firstWeekQuery, { sort: { due: -1 } }).fetch()
    secondWeekTasks = Tasks.find(secondWeekQuery, {sort: { due: -1}}).fetch()

    # get this week's plans
    plansQuery = { timestamp: { $gte: timestamp, $lt: weekEnd} }
    currentPlans = Plans.find(plansQuery, {sort: { timestamp: -1 }}).fetch()

    # build buckets and put plans into the buckets
    buckets= []
    for i in [0..(6-dayNumber)]
      buckets.push(
        {timestamp:0,plans:[]}
      )
    bucketMap = {}
    for i in [0..(6-dayNumber)]
      ts = timestamp + i*secondsPerDay + 43200 # because daylight savings, offset by 12 hours so it won't make a difference
      buckets[i].timestamp = ts
      bucketMap[ts] = i
    for plan in currentPlans
      for bucket in buckets
        if plan.timestamp is bucket.timestamp
          bucket.plans.push(plan)

    # FIRST WEEK
    for task in firstWeekTasks
      # how many plans already exist?
      relevantPlans = []
      for plan in currentPlans
        if plan.taskId is task._id
          relevantPlans.push(plan)
      # is n*2 hours < estimated time of task?
      # if so, make another plan and place it according to the following heuristic
      # if buckets before due date are evenly full, place in earlier bucket
      # if buckets before due date are not evenly full, place in less full bucket
      while relevantPlans.length * 2 * 3600 < task.duration
        # check if the buckets before the due date are evenly full
        even = true
        leastFull = 0
        shortest = 10000
        for i in [0...bucketMap[task.dueDate]]
          len = buckets[i].plans.length
          if len isnt buckets[0].plans.length
            even = false
          if len < shortest
            shortest = len
            leastFull = i

        if even
          # prioritize earlier
          info =
            id: task._id
            timestamp: buckets[0].timestamp
          buckets[0].plans.push('new plan')
        else
          # prioritize least full
          info =
            id: task._id
            timestamp: buckets[leastFull].timestamp
          buckets[leastFull].plans.push('new plan')

        Meteor.call('makePlan', info, (error, id)->
          if error
            Errors.throw(error.reason)

            if error.error is 302
              Meteor.Router.to('home', error.details)
        )

        relevantPlans.push('new plan')

    # SECOND WEEK
    # fill in friday, saturday, sunday with big projects and monday, then fill up to the average of the week
    # find average plans / day in first week
    tot = 0
    if dayNumber < 5
      for i in [0..3]
        tot += buckets[i].plans.length
      avg = Math.max(Math.floor(tot / 4), 3)
    else
      for i in [0..6-dayNumber]
        tot += buckets[i].plans.length
      avg = Math.max(Math.floor(tot / (7-dayNumber)), 3)

    # find all monday tasks, then tasks >3 hours in second week
    queued = []
    for task in secondWeekTasks
      if task.dueDate is nextEnd or task.duration > 10800
        queued.push(task)
    while Math.floor((buckets[4].plans.length + buckets[5].plans.length + buckets[6].plans.length)/3) < avg and queued.length > 0
      thisTask = queued.shift()
      even = true
      leastFull = 0
      shortest = 10000
      for i in [4..6]
        len = buckets[i].plans.length
        if len isnt buckets[4].plans.length
          even = false
        if len < shortest
          shortest = len
          leastFull = i

      if even
        # prioritize earlier
        info =
          id: thisTask._id
          timestamp: buckets[4].timestamp
        buckets[4].plans.push('new plan')
      else
        # prioritize least full
        info =
          id: thisTask._id
          timestamp: buckets[leastFull].timestamp
        buckets[leastFull].plans.push('new plan')

      Meteor.call('makePlan', info, (error, id)->
        if error
          Errors.throw(error.reason)

          if error.error is 302
            Meteor.Router.to('home', error.details)
      )


    # fill in tasks until each day is up to the floored average
    # prioritize monday > early long > late long
)
