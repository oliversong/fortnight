@tasksHandle = Meteor.subscribe 'tasks'

Meteor.subscribe 'notifications'

Deps.autorun ()->
  console.log 'There are' + Tasks.find().count() + ' tasks'
