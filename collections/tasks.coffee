@Tasks = new Meteor.Collection 'tasks'

Tasks.allow(
  update: ownsDocument
  remove: ownsDocument
)
