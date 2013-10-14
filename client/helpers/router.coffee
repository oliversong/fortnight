Meteor.Router.add
  '/': (->
    if Meteor.user()
      return 'homePage'
    else
      return 'landingPage'
  )
  '/settings': 'settings'

Meteor.Router.filters
  'requireLogin':(page)->
    if Meteor.user()
      return page
    else if Meteor.loggingIn()
      return 'loading'
    else
      return 'accessDenied'
  'clearErrors': (page)->
    Errors.clearSeen()
    return page

Meteor.Router.filter('requireLogin', {only: ['settings','home']})
Meteor.Router.filter('clearErrors')
