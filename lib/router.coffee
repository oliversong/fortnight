Router.configure
  before: clearErrors
  loadingTemplate: 'loading'
  layoutTemplate: 'layout'
  # waitOn: ->
  #   return [Meteor.subscribe('notifications')]

Router.map ()->
  @route('landingPage', {
    layoutTemplate: 'layout'
    path: '/'
    action: ()->
      if Meteor.user()
        @render('homePage')
      else
        @render('landingPage')
  })

  @route('settings', {
    path: '/settings'
  })

  @route('not_found', {
    path: '*'
  })

clearErrors = ()->
  Errors.clearSeen()

requireLogin = ()->
  unless Meteor.user()
    if Meteor.loggingIn()
      @render @loadingTemplate
    else
      @redirect 'landingPage'

    @stop()

Router.before(requireLogin, {only: 'homePage'})
Router.before(()-> clearErrors())
