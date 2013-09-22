Template.plan.helpers(
  checked: ()->
    plan = Plans.findOne( { _id: @_id })
    if plan.completed is true
      'checked'
    else
      ''
)

Template.plan.events(
  'click .toggle': (e)->
    checked = $(event.currentTarget).next().hasClass('checked')

    unless checked
      # submit check
      Meteor.call('completePlan', @_id)
    else
      # submit uncheck
      Meteor.call('uncompletePlan', @_id)

  'click .deletePlan':(e)->
    Meteor.call('deletePlan', @_id)

)
