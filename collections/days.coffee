# days keep track of
#
@Days = new Meteor.Collection 'days'

Days.allow(
  update: ownsDocument
  remove: ownsDocument
)

Days.deny(
  # days cannot be removed!
  remove: ()->
    return false
)

Meteor.methods(
)
