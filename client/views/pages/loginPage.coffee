Template.loginPage.events
  'submit #signIn': (event) ->
    event.preventDefault()
    Session.set('email', $('input[name="email"]').val())
    Session.set('password', $('input[name="password"]').val())

    Meteor.loginWithPassword(Session.get('email'), Session.get('password'), (error)->
      if error
        Session.set('entryError', 'Incorrect email or password')
      else
        Router.go AccountsEntry.settings.dashboardRoute
    )
