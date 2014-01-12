Template.homeLayout.events(
  'click .previousWeek': (e)->
    secondsPerDay = 86400
    temp = Session.get('firstDay')
    Session.set('firstDay', temp - secondsPerDay*7)

  'click .nextWeek': (e)->
    secondsPerDay = 86400
    temp = Session.get('firstDay')
    Session.set('firstDay', temp + secondsPerDay*7)

)
