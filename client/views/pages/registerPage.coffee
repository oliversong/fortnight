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

    email =
      if t.find('input[name="email"]')
        t.find('input[name="email"]').value
      else
        undefined

    username = ''

    password = t.find('input[name="password"]').value
    confirm = t.find('input[name="confirmPassword"]').value

    fields = Accounts.ui._options.passwordSignupFields

    trimInput = (val)->
      val.replace /^\s*|\s*$/g, ""

    email = trimInput email

    emailRequired = _.contains([
      'USERNAME_AND_EMAIL',
      'EMAIL_ONLY'], fields)

    if emailRequired && email.length is 0
      Session.set('entryError', 'Email is required')
      return

    if email.match(/[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/gi) is null
      Session.set('entryError', 'Invalid email')
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

      Meteor.loginWithPassword(email, password)
      Router.go AccountsEntry.settings.dashboardRoute
    )
