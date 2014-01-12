Template.planday.helpers(
  todayPlans: ()->
    me = this.parent.first[this.index]
    # `this` is the data object passed from day
    dayBeginning = me.timestamp
    dayEnd = me.timestamp + 86400
    # build query
    mongoQuery = { timestamp: { $gte: dayBeginning, $lt: dayEnd} }
    # find relevant tasks
    plans = Plans.find(mongoQuery, { sort: { timestamp: -1 } }).fetch()
    plans

  name: ()->
    me = this.parent.first[this.index]
    me.name
)

Template.planday.rendered = ()->
  me = this.data.parent.first[this.data.index]
  timestamp = me.timestamp
  $(this.find('.planday')).droppable(
    activeClass: 'ui-state-hover'
    hoverClass: 'ui-state-active'
    drop: (event, ui)->
      id = ui.draggable.attr('id')
      info =
        id: id
        timestamp: timestamp
      Meteor.call('makePlan', info, (error,id)->
        if error
          Errors.throw(error.reason)

          if error.error is 302
            Meteor.Router.to('home', error.details)
      )
  )
