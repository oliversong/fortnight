# Template.landingPage.rendered = ()->
#   BV = new $.BigVideo({useFlashForFirefox:false, container:$('#brocontainer')})
#   BV.init()
#   # BV.show('http://olli.es/clouds.mp4', {altSource:'http://olli.es/clouds.ogg', ambient:true})
#   BV.show('/clouds.mp4', {altSource:'/clouds.ogg', ambient:true})

Template.landingPage.rendered = ()->
  $('#brocontainer').append("""
    <video class="cloudsvid" preload autoplay loop>
      <source type="video/mp4" src="http://www.olli.es/clouds.mp4">
      <source type="video/ogg" src="http://www.olli.es/clouds.ogg">
    </video>
  """)

Template.landingPage.events(
  # 'click .learnbutton': (e)->
  #    $('html, body').animate(
  #      scrollTop: $("#scroll-target").offset().top
  #    , 2000)
)
