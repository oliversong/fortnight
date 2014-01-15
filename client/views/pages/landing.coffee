Template.landingPage.rendered = ()->
  console.log('loading')
  BV = new $.BigVideo({useFlashForFirefox:false, container:$('#brocontainer')})
  BV.init()
  BV.show('/clouds.mp4', {altSource:'/clouds.ogg', ambient:true})
  console.log("shit loaded")
