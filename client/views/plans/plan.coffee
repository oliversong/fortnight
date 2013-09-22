Template.plan.helpers(
  checked: ()->
    task = Plans.findOne( { _id: @_id })
    if task.completed is true
      'checked'
    else
      ''
)
