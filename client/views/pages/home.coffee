Template.homePage.helpers(
  tasks: ()->
    secondsPerDay = 86400
    now = new Date()
    start = new Date(now.getFullYear(), now.getMonth(), now.getDate())
    # today's floored unix timestamp
    timestamp = start / 1000
    # today's day index
    dayNumber = now.getDay()
    # make sunday the last day
    if dayNumber is 0
      dayNumber = 7
    firstDay = (dayNumber-1)*secondsPerDay # first monday
    lastDay = mondayStamp + 13*secondsPerDay # next sunday
    # build query
    mongoQuery = { due: { $gte: firstDay, $lte: lastDay } }
    # find relevant tasks
    Tasks.find(mongoQuery, { sort: { due: -1 } })

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
