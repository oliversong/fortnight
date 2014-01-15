Template.landingPage.rendered = ()->
  console.log('loading')
  BV = new $.BigVideo({useFlashForFirefox:false, container:$('#brocontainer')})
  BV.init()
  BV.show('http://olli.es/clouds.mp4', {altSource:'http://olli.es/clouds.ogg', ambient:true})
  console.log("shit loaded")
