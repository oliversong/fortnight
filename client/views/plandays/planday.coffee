Template.planday.rendered = ()->
  $(this.find('.planday')).droppable(
    activeClass: 'ui-state-hover'
    hoverClass: 'ui-state-active'
  )
