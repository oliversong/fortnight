Handlebars.registerHelper "modAcctButtons", ->
    return new Handlebars.SafeString(Template.modAcctButtons())

Template.modAcctButtons.helpers
  profileUrl: ->
    return false unless AccountsEntry.settings.profileRoute
    AccountsEntry.settings.profileRoute

  wrapLinks: ->
    AccountsEntry.settings.wrapLinks
