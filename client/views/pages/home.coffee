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

