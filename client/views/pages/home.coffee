# Moves sunday back to last index
# 0 -> 6
# 1 -> 0
# 2 -> 1
# 3 -> 2, etc
moveSundayBack = (index)->
  if index is 0
    6
  else
    index - 1

# Input is an integer representing the target week.
# 0 -> current week
# 1 -> next week
# -1 -> last week
# Returns an ordered list of name, timestamp hashes
buildData = (which)->
  secondsPerDay = 86400
  now = new Date()
  start = new Date(now.getFullYear(), now.getMonth(), now.getDate())
  # today's floored unix timestamp
  timestamp = start / 1000
  # today's day index
  dayNumber = moveSundayBack(now.getDay())
  # move this back to the last monday
  mondayTimestamp = timestamp - (dayNumber) * secondsPerDay

  # make bucket for every day, but leave task aggregating to the days
  buckets = [
    {'name':'','timestamp':0},
    {'name':'','timestamp':0},
    {'name':'','timestamp':0},
    {'name':'','timestamp':0},
    {'name':'','timestamp':0},
    {'name':'','timestamp':0},
    {'name':'','timestamp':0}
  ]

  firstIndex = 0 + 7 * which
  lastIndex = firstIndex + 6

  # add timestamps to buckets
  for count in [firstIndex..lastIndex]
    buckets[count%7]['timestamp'] = mondayTimestamp + count * secondsPerDay

  # add day names to buckets
  dayNames = getDayNames(buckets[0]['timestamp']*1000)
  for day in [0..6]
    # TODO support negative week indices by adding to this modulus
    buckets[day%7]['name'] = dayNames[day]

  buckets

getDayNames = (mondayTimestamp)->
  debugger
  msPerDay = 86400000
  weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
  dayNames = []
  currentDate = new Date(mondayTimestamp)

  for x in [0..6]
    dayName = weekdays[moveSundayBack(currentDate.getDay())]
    dayMonth = currentDate.getMonth() + 1
    dayDate = currentDate.getDate()
    name = dayName + " " + dayMonth + "/" + dayDate
    dayNames.push(name)
    # go to tomorrow
    currentDate = new Date(currentDate.getTime() + msPerDay)

  dayNames


Template.homePage.helpers(
  # Return ordered list of day names and timestamps [{'name':'Monday 10/26','timestamp':'13244653982'},{},{}...]
  firstWeek: ()->
    buildData(0)

  secondWeek: ()->
    buildData(1)
)
