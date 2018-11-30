$ ->
  picker = $('.datepicker').pickadate(
    min: new Date(),
    max: 182,
    formatSubmit: 'yyyy-mm-dd',
    hiddenName: true,
    disable: [
      new Date(new Date().getFullYear(), 11, 25),
      new Date(new Date().getFullYear(), 11, 26),
    ]
    hiddenPrefix: 'datepicker_',
    onSet: (context) ->
      if moment(context.select).isSame(moment(), 'day') && !context.highlight
        console.log("Setting min")
        timepicker.set('min', if new Date().getHours() >= 12 then 12 else [15,0])
        timepicker.set('clear')
      else
        timepicker.set('min', [15,0])
  ).pickadate 'picker'

  timepicker = $('.timepicker').pickatime(
    format: 'H:i'
    interval: 15,
    min: [15,0],
    max: [21,0]
  ).pickatime 'picker'

  if picker && picker.$node.data('bookable-from')
    picker.set 'min', new Date(picker.$node.data('bookable-from'))

  $('.packages li').click ->
    # Handle selected class
    $('.packages li').removeClass 'selected'
    $(this).addClass 'selected'

    # Handle selected check
    $('.package-selected-check').fadeTo(100, 0)
    $(this).find('.package-selected-check').fadeTo(100, 1)

    # Check radio button
    $(this).find('.package-radio-button').prop 'checked', true

    if $(this).data('package') == 'valentijn-special'
      picker.set('select', [2017,1,14])
      picker.set('disable', true)
    else
      picker.set('clear') unless picker.get()
      picker.set('disable', false)


  $('.packages li').find('.package-radio-button:checked').trigger 'click'
