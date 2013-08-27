Meteor.publish 'tasks', ()->
  return Tasks.find(
    userId: @userId
  )
