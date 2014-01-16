Template.landingPage.rendered = ()->
  BV = new $.BigVideo({useFlashForFirefox:false, container:$('#brocontainer')})
  BV.init()
  # BV.show('http://olli.es/clouds.mp4', {altSource:'http://olli.es/clouds.ogg', ambient:true})
  BV.show('/clouds.mp4', {altSource:'/clouds.ogg', ambient:true})

Template.landingPage.events(
  # 'click .learnbutton': (e)->
  #    $('html, body').animate(
  #      scrollTop: $("#scroll-target").offset().top
  #    , 2000)
)
