moveSundayBack = (index)->
  # 0 -> 6
  # 1 -> 0
  # 2 -> 1
  # 3 -> 2, etc
  if index is 0
    6
  else
    index - 1

getTasks = (which)->
  secondsPerDay = 86400
  now = new Date()
  start = new Date(now.getFullYear(), now.getMonth(), now.getDate())
  # today's floored unix timestamp
  timestamp = start / 1000
  # today's day index
  dayNumber = moveSundayBack(now.getDay())
  if which is 'first'
    firstDay = timestamp - (dayNumber)*secondsPerDay # monday of first week
    lastDay = firstDay + 6*secondsPerDay # sunday of first week
    firstIndex = 0
    lastIndex = 6
  else if which is 'second'
    firstDay = timestamp + (7-dayNumber)*secondsPerDay # monday of second week
    lastDay = firstDay + 6*secondsPerDay # sunday of second week
    firstIndex = 7
    lastIndex = 13
  else
    console.log "wat are you doing"

  # build query
  mongoQuery = { due: { $gte: firstDay, $lte: lastDay } }
  # find relevant tasks
  tasks = Tasks.find(mongoQuery, { sort: { due: -1 } }).fetch()
  # sort tasks in to their buckets, then return the buckets
  buckets = [{dayName: "", tasks:[]}, {dayName: "", tasks:[]}, {dayName: "", tasks:[]}, {dayName: "", tasks:[]}, {dayName: "", tasks:[]}, {dayName: "", tasks:[]}, {dayName: "", tasks:[]}]

  for task in tasks
    # get day index (timestamp - monday timestamp) / secondsPerDay
    dayIndex = (task.due - timestamp) / secondsPerDay
    # put task in the correct bucket for index
    buckets[dayIndex%7]['tasks'].push task

  # populate names of days
  dayNames = getDayNames()
  for day in [firstIndex..lastIndex]
    buckets[day%7]["dayName"] = dayNames[day]

  buckets

getDayNames = ()->
  weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
  msPerDay = 86400000
  date = new Date()
  start = new Date(date.getFullYear(), date.getMonth(), date.getDate())
  timestamp = start.getTime()
  dayIndex = moveSundayBack(start.getDay())
  # move this back to the last monday
  mondayTimestamp = timestamp - (dayIndex+1) * msPerDay
  currentDate = new Date(mondayTimestamp)
  dayNames = []

  for x in [0..13]
    dayName = weekdays[currentDate.getDay()]
    dayMonth = currentDate.getMonth()
    dayDate = currentDate.getDate()
    name = dayName + " " + dayMonth + "/" + dayDate
    dayNames.push(name)
    # go to tomorrow
    currentDate = new Date(currentDate.getTime() + msPerDay)

  dayNames


Template.homePage.helpers(
  firstWeekTasks: ()->
    getTasks("first")

  secondWeekTasks: ()->
    getTasks("second")

  weekdays: ()->
    ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

)

#buckets = (x for x in [firstDay...lastDay] by secondsPerDay)
    # dayZip =
    #   0: "Sunday"
    #   1: "Monday"
    #   2: "Tuesday"
    #   3: "Wednesday"
    #   4: "Thursday"
    #   5: "Friday"
    #   6: "Saturday"
