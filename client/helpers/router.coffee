Meteor.Router.add
  '/': 'index'
  '/home': 'home'
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
    Meteor.Errors.clear()
    return page

Meteor.Router.filter('requireLogin', {only: ['settings','home']})
Meteor.Router.filter('clearErrors')
