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
    # don't allow two plans on the same day
    planWithSameDate = Plans.findOne(
      timestamp: planAttributes.timestamp
      taskId: planAttributes.id
    )
    if planWithSameDate
      console.log 'Plan already exists!'
      return
      # TODO: Gracefully handle error popups
      # throw new Meteor.Error(302, 'Plan already exists!', planWithSameDate._id)

    relatedTask = Tasks.findOne({_id:planAttributes.id})
    plan =
      name: relatedTask.name
      taskId: planAttributes.id
      completed: false
      timestamp: planAttributes.timestamp + 43200 # because DST
      userId: user._id
    planId = Plans.insert(plan)
    planId
  completePlan: (planId)->
    user = Meteor.user()
    if not user
      throw new Meteor.Error(401, "You need to login to complete a task")

    Plans.update({
      _id: planId
    },{
      $set: {completed: true}
    })

  uncompletePlan: (planId)->
    user = Meteor.user()
    if not user
      throw new Meteor.Error(401, "You need to login to uncomplete a task")

    Plans.update({
      _id: planId
    },{
      $set: {completed: false}
    })
  deletePlan: (planId)->
    user = Meteor.user()
    if not user
      throw new Meteor.Error(401, "You need to login to uncomplete a task")

    Plans.remove({_id: planId})
)

