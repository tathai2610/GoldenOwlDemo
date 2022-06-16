$(document).on("turbolinks:load", function() { 
  // subnav visibility 
  $("#toggle-subnav-btn").on("click", function() {
    if ($("#subnav").is(":visible")) {
      $("#subnav").hide()
      $(this).children("i").removeClass("fa-x")
      $(this).children("i").addClass("fa-bars")
    }
    else {
      $("#subnav").show()
      $(this).children("i").removeClass("fa-bars")
      $(this).children("i").addClass("fa-x")
    }
  })

  // categories visibility 
  $("#toggle-categories-btn").on("click", function() {
    if ($("#categories").is(":visible")) {
      $("#categories").hide()
      $(this).children("i").removeClass("fa-x")
      $(this).children("i").addClass("fa-caret-down")
    }
    else {
      $("#categories").show()
      $(this).children("i").removeClass("fa-caret-down")
      $(this).children("i").addClass("fa-x")
    }
  })
})