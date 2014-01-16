Template.loginPage.events
  'submit #signIn': (event) ->
    event.preventDefault()
    Session.set('username', $('input[name="username"]').val())
    Session.set('password', $('input[name="password"]').val())

    Meteor.loginWithPassword(Session.get('username'), Session.get('password'), (error)->
      if error
        Session.set('entryError', error.reason)
      else
        Router.go AccountsEntry.settings.dashboardRoute
    )
