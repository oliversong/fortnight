Template.registerPage.helpers
  showEmail: ->
    fields = Accounts.ui._options.passwordSignupFields

    _.contains([
      'USERNAME_AND_EMAIL',
      'USERNAME_AND_OPTIONAL_EMAIL',
      'EMAIL_ONLY'], fields)

  showUsername: ->
    fields = Accounts.ui._options.passwordSignupFields

    _.contains([
      'USERNAME_AND_EMAIL',
      'USERNAME_AND_OPTIONAL_EMAIL',
      'USERNAME_ONLY'], fields)

  showSignupCode: ->
    AccountsEntry.settings.showSignupCode

  logo: ->
    AccountsEntry.settings.logo

  privacyUrl: ->
    AccountsEntry.settings.privacyUrl

  termsUrl: ->
    AccountsEntry.settings.termsUrl

  both: ->
    AccountsEntry.settings.privacyUrl &&
    AccountsEntry.settings.termsUrl

  neither: ->
    !AccountsEntry.settings.privacyUrl &&
    !AccountsEntry.settings.termsUrl

Template.registerPage.events
  'submit #signUp': (event, t) ->
    event.preventDefault()

    username =
      if t.find('input[name="username"]')
        t.find('input[name="username"]').value
      else
        undefined

    email = ''

    password = t.find('input[name="password"]').value
    confirm = t.find('input[name="confirmPassword"]').value

    fields = Accounts.ui._options.passwordSignupFields

    trimInput = (val)->
      val.replace /^\s*|\s*$/g, ""

    usernameRequired = _.contains([
      'USERNAME_AND_EMAIL',
      'USERNAME_ONLY'], fields)

    if usernameRequired
      unless username
        Session.set('entryError', 'Username is required')
        return

    passwordErrors = do (password)->
      errMsg = []
      msg = false
      if password.length < 6
        errMsg.push "6 character minimum password."
      if password.search(/[a-z]/i) < 0
        errMsg.push "Password requires 1 letter."
      if password isnt confirm
        errMsg.push "Passwords do not match."

      if errMsg.length > 0
        msg = ""
        errMsg.forEach (e) ->
          msg = msg.concat "#{e}\r\n"

        Session.set 'entryError', msg
        return true

      return false

    if passwordErrors then return


    Meteor.call('accountsCreateUser', username, email, password, (err, data) ->
      if err
        Session.set('entryError', err.reason)
        return

      Meteor.loginWithPassword(username, password)
      Router.go AccountsEntry.settings.dashboardRoute
    )
