Meteor.publish 'tasks', ()->
  return Tasks.find(
    userId: @userId
  )

Meteor.publish 'plans', ()->
  return Plans.find(
    userId: @userId
  )
