$('#myTabs li').click(function (e) {
  e.preventDefault()
  $(this).tab('show')
})