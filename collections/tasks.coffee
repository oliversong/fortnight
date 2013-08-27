@Tasks = new Meteor.Collections('tasks')

Tasks.allow(
  update: ownsDocument
  remove: ownsDocument
)
