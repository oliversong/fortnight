@Plans = new Meteor.Collection 'plans'

Plans.allow(
  update: ownsDocument
  remove: ownsDocument
)

Meteor.methods(
  makePlan: (planAttributes)->
    user = Meteor.user()

    # user must be logged in
    if not user
      throw new Meteor.Error(401, "You need to log in to create tasks")

    relatedTask = Tasks.findOne({_id:planAttributes.id})
    # update Task's reference list
    # Tasks.update(relatedTask,
    #   {$set:{planDates:planDates+plan}}
    # )
    plan =
      name: relatedTask.name
      taskId: planAttributes.id
      completed: false
      timestamp: planAttributes.timestamp
      userId: user._id
    planId = Plans.insert(plan)
    planId
)

