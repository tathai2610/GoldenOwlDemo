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

  // Check shop's checkbox
  $('.input-shop-items').on('change', function() {
    let cartTotalPrice = Number($(".cart-total-price").text().replace(',', ''))
    let cartFinalItems = Number($(".cart-final-items").text())
    let items = $(this).closest(".container-fluid").find(".cart-item")
    let shopItemsSibings = $(this).closest(".shop-items").siblings()
    
    if (this.checked) {    
      let unchecked = []

      items.each(function() {
        if ($(this).find(".input-cart-item").is(":not(:checked)")) {
          unchecked.push($(this))
          cartTotalPrice += Number($(this).find(".item-total-price").text().replace(',', ''))
          $(this).find(".input-cart-item").prop("checked", true)
        }
      })

      if (cartFinalItems + unchecked.length > 1) {
        $(".cart-final-items-postfix").text("s")
      }

      $(".cart-total-price").text(displayPrice(cartTotalPrice))
      $(".cart-final-items").text(cartFinalItems + unchecked.length)

      // If all shops are checked, check select-all
      let selectAll = true
      for (x in shopItemsSibings) {
        if($(x).find(".input-shop-items").is(":not(:checked)")) {
          selectAll = false 
          break
        }
      }
      if (selectAll) {
        $("#shop-all").prop("checked", true)
      }

    }
    else {
      items.each(function() {
        cartTotalPrice -= Number($(this).find(".item-total-price").text().replace(',', ''))
      })

      if (cartFinalItems - items.length <= 1) 
        $(".cart-final-items-postfix").text("")

      if ($("#shop-all").prop("checked"))
        $("#shop-all").prop("checked", false)
      
      $(".cart-total-price").text(displayPrice(cartTotalPrice))
      $(".cart-final-items").text(cartFinalItems - items.length)
      $(this).closest(".container-fluid").find(".input-cart-item").prop("checked", false)
    }
  })

  // Check cart item's checkbox 
  $('.input-cart-item').on('change', function() {
    let cartTotalPrice = Number($(".cart-total-price").text().replace(',', ''))
    let cartFinalItems = Number($(".cart-final-items").text())
    let itemTotalPrice = Number($(this).closest('.container-fluid').find('.item-total-price').text().replace(',', ''))
    let allItemsCurrentShop = $(this).closest('.cart-items').find('input').length
    let allItemsCurrentShopChecked = $(this).closest('.cart-items').find('input:checked').length
    let inputShopItems = $(this).closest(".shop-items").find(".input-shop-items")
    let shopItemsSibings = $(this).closest(".shop-items").siblings()

    if (this.checked) {
      if (cartFinalItems >= 1) 
        $(".cart-final-items-postfix").text("s")

      if (allItemsCurrentShopChecked == allItemsCurrentShop)
        inputShopItems.prop("checked", true)

      $(".cart-total-price").text(displayPrice(cartTotalPrice + itemTotalPrice))
      $(".cart-final-items").text(cartFinalItems + 1)

      let selectAll = true
      for (x in shopItemsSibings) {
        if($(x).find(".input-shop-items").is(":not(:checked)")) {
          selectAll = false 
          break
        }
      }
      if (selectAll) {
        $("#shop-all").prop("checked", true)
      }
    }
    else {
      if (cartFinalItems <= 2) 
        $(".cart-final-items-postfix").text("")

      if (inputShopItems.prop("checked"))
        inputShopItems.prop("checked", false)
      
      if ($("#shop-all").prop("checked"))
        $("#shop-all").prop("checked", false)

      $(".cart-total-price").text(displayPrice(cartTotalPrice - itemTotalPrice))
      $(".cart-final-items").text(cartFinalItems - 1)
    }
  })

  // check select all 
  $("#shop-all").on('change', function() {
    let numberOfItems = $(".item-total-price").length
    let cartTotalPrice = 0
    
    if (this.checked) {
      $(".item-total-price").each(function(index) {
        cartTotalPrice += Number($(this).text().replace(',', ''))
      })

      if (numberOfItems > 1)
        $(".cart-final-items-postfix").text("s")

      $(".cart-total-price").text(displayPrice(cartTotalPrice))
      $(".cart-final-items").text(numberOfItems)
      $("input").prop("checked", true)
      $("#btn-destroy-cart").toggleClass("disabled")
    }
    else {
      $("input").prop("checked", false)
      $(".cart-total-price").text("0.00")
      $(".cart-final-items").text(0)
      $(".cart-final-items-postfix").text("")
      $("#btn-destroy-cart").toggleClass("disabled")
    }
  })

  // Modify quantity in product show
  $("#add-btn").on('click', function() {
    $("#product-show-qtt").val(Number($("#product-show-qtt").val()) + 1)

    if ($("#sub-btn").is(":disabled")) {
      $("#sub-btn").prop("disabled", false)
    }
  })
  $("#sub-btn").on('click', function() {
    $("#product-show-qtt").val(Number($("#product-show-qtt").val()) - 1)

    if ($("#product-show-qtt").val() == 1) {
      $("#sub-btn").prop("disabled", true)
    }
  })

  // Add product to cart ajax
  $("#btn-add-to-cart").on('click', function() {
    let form = $("#form-add-to-cart");
    let actionUrl = form.attr('action');

    $.ajax({
      type: "POST",
      url: actionUrl,
      data: form.serialize(),
      success: function(result) {
        const toast = new bootstrap.Toast(document.getElementById("success-add-to-cart"))

        toast.show()
        $(".cart-total-items").text(Number($(".cart-total-items").text()) + 1 )
      } 
    })
  }) 
  
  // Update cart if there is a cart item checked 
  if ($(".input-cart-item:checked").length > 0) {
    let cartItem = $(".input-cart-item:checked").closest((".cart-item"))

    $(".cart-total-price").text(cartItem.find(".item-total-price").text().replace(',', ''))
    $(".cart-final-items").text(1)

    if (cartItem.siblings().length == 0) {
      cartItem.closest(".shop-items").find(".input-shop-items").prop("checked", true)

      if (cartItem.closest(".shop-items").siblings().length == 0) {
        $("#shop-all").prop("checked", true)
      }
    }
  }

  window.displayPrice = function displayPrice(price) {
    return Number(price).toLocaleString(undefined, {minimumFractionDigits: 2, maximumFractionDigits: 2})
  }
})
