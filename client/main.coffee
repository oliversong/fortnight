@tasksHandle = Meteor.subscribe 'tasks'
@plansHandle = Meteor.subscribe 'plans'

Meteor.subscribe 'notifications'

Deps.autorun ()->
  console.log 'There are ' + Tasks.find().count() + ' tasks'
  console.log 'There are ' + Plans.find().count() + ' plans'

