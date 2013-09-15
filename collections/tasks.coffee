@Tasks = new Meteor.Collection 'tasks'

Tasks.allow(
  update: ownsDocument
  remove: ownsDocument
)

Meteor.methods(
  makeTask: (taskAttributes)->
    user = Meteor.user()

    # user must be logged in
    if not user
      throw new Meteor.Error(401, "You need to log in to create tasks")
    # task must have a name
    if not taskAttributes.name
      throw new Meteor.Error(422, "Please fill in task name")
    # this should not be possible
    if not taskAttributes.due
      throw new Meteor.Error(422, "How did you even do that?")
    # set default task estimate time
    if not taskAttributes.estimate
      taskAttributes.estimate = 3600

    task = _.extend(_.pick(postAttributes, 'name', 'due', 'estimate'),
      userId: user._id
      completed: false
      planDates: []
    )

    taskId = Tasks.insert(task)
    taskId
)
