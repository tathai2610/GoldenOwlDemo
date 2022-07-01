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

  // select2 call 
  $('#product_category_ids').select2({
    tags: true,
    tokenSeparators: [',', ' '],
    placeholder: 'Choose product category'
  })

  // preview images before save 
  $("#product_images").on('change', function() {
    $("#product-images_preview").html('')
    for (let i = 0; i < $(this)[0].files.length; i++) {
      $("#product-images_preview").append('<img src="'+window.URL.createObjectURL(this.files[i])+'" class="product-images_preview"/>');
    }
  })

  // Change product-show-img when click other images
  $(".product-show_small-image").on('click', function() {
    let newSrc = $(this).attr('src')
    $(".product-show-img").attr('src', newSrc)
    $(".product-show_small-image").css('border-color', 'white')
    $(this).css('border-color', 'rgb(65, 98, 75)')
  })

  $(document).on('click', "#btn-remove-flash", function() {
    $("#flash").remove()
  })
})
