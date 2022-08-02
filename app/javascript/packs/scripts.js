$(document).on("turbolinks:load", function() { 
  window.displayPrice = function displayPrice(price) {
    return Number(price).toLocaleString('vi', {maximumFractionDigits: 0})
  }

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
    let cartTotalPrice = Number($(".cart-total-price").text().replaceAll('.', ''))
    let cartFinalItems = Number($(".cart-final-items").text())
    let items = $(this).closest(".container-fluid").find(".cart-item")
    let shopItemsSibings = $(this).closest(".shop-items").siblings()
    
    if (this.checked) {    
      let unchecked = []

      items.each(function() {
        if ($(this).find(".input-cart-item").is(":not(:checked)")) {
          unchecked.push($(this))
          cartTotalPrice += Number($(this).find(".item-total-price").text().replaceAll('.', ''))
          $(this).find(".input-cart-item").prop("checked", true)
        }
      })

      if (cartFinalItems + unchecked.length > 1) {
        $(".cart-final-items-postfix").text("s")
      }

      if ($("#btn-checkout").hasClass("disabled")) {
        $("#btn-checkout").removeClass("disabled")
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
        cartTotalPrice -= Number($(this).find(".item-total-price").text().replaceAll('.', ''))
      })

      if (cartFinalItems - items.length <= 1) 
        $(".cart-final-items-postfix").text("")

      if ($("#shop-all").prop("checked"))
        $("#shop-all").prop("checked", false)
      
      $(".cart-total-price").text(displayPrice(cartTotalPrice))
      $(".cart-final-items").text(cartFinalItems - items.length)
      $(this).closest(".container-fluid").find(".input-cart-item").prop("checked", false)

      if ($("input:checked").length == 0) 
        $("#btn-checkout").addClass("disabled")
    }
  })

  // Check cart item's checkbox 
  $('.input-cart-item').on('change', function() {
    let cartTotalPrice = Number($(".cart-total-price").text().replaceAll('.', ''))
    let cartFinalItems = Number($(".cart-final-items").text())
    let itemTotalPrice = Number($(this).closest('.container-fluid').find('.item-total-price').text().replaceAll('.', ''))
    let allItemsCurrentShop = $(this).closest('.cart-items').find('input').length
    let allItemsCurrentShopChecked = $(this).closest('.cart-items').find('input:checked').length
    let inputShopItems = $(this).closest(".shop-items").find(".input-shop-items")
    let shopItemsSibings = $(this).closest(".shop-items").siblings()

    if (this.checked) {
      if (cartFinalItems >= 1) 
        $(".cart-final-items-postfix").text("s")

      if (allItemsCurrentShopChecked == allItemsCurrentShop)
        inputShopItems.prop("checked", true)

      if ($("#btn-checkout").hasClass("disabled")) 
        $("#btn-checkout").removeClass("disabled")

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

      if ($("input:checked").length == 0) 
        $("#btn-checkout").addClass("disabled")

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
        cartTotalPrice += Number($(this).text().replaceAll('.', ''))
      })

      if (numberOfItems > 1)
        $(".cart-final-items-postfix").text("s")

      if ($("#btn-checkout").hasClass("disabled")) 
        $("#btn-checkout").removeClass("disabled")

      $(".cart-total-price").text(displayPrice(cartTotalPrice))
      $(".cart-final-items").text(numberOfItems)
      $("input").prop("checked", true)
      $("#btn-destroy-cart").toggleClass("disabled")
    }
    else {
      if (!$("#btn-checkout").hasClass("disabled")) 
        $("#btn-checkout").addClass("disabled")

      $("input").prop("checked", false)
      $(".cart-total-price").text("0.00")
      $(".cart-final-items").text(0)
      $(".cart-final-items-postfix").text("")
      $("#btn-destroy-cart").toggleClass("disabled")
    }
  })

  // Modify quantity in product show
  $("#add-btn").on('click', function() {
    let inStock = +$(".product-quantity").text()
    let currentQuantity = +$("#product-show-qtt").val()

    // If current quantity is less than in_stock number
    if (currentQuantity < inStock) {
      // Increase current desired quantity
      $("#product-show-qtt").val(currentQuantity + 1)
      // If after update, current desired quantity equals in_stock
      if (+$("#product-show-qtt").val() == inStock) {
        // Disable 'add-btn'
        $("#add-btn").prop("disabled", true)
      }
    }

    if ($("#sub-btn").is(":disabled")) {
      $("#sub-btn").prop("disabled", false)
    }
  })
  $("#sub-btn").on('click', function() {
    $("#product-show-qtt").val(Number($("#product-show-qtt").val()) - 1)

    // If desired quantity is 1, disable 'sub-btn'
    if ($("#product-show-qtt").val() == 1) {
      $("#sub-btn").prop("disabled", true)
    }
    // Else enable 'add-btn' if it is disabled
    else {
      $("#add-btn").prop("disabled", false)
    }
  })

  $("#product-show-qtt").on('change', function() {
    if (+$("#product-show-qtt").val() > +$(".product-quantity").text()) {
      $("#product-show-qtt").val(+$(".product-quantity").text())
      $("#add-btn").prop("disabled", true)
      $("#sub-btn").prop("disabled", false)
    }

    if (!Number.isInteger($("#product-show-qtt").val())) {
      $("#product-show-qtt").val(parseInt($("#product-show-qtt").val()))
    }
  })

  if (+$(".product-quantity").text() < 2) 
    $("#add-btn").prop("disabled", true)

  // Add product to cart ajax
  $("#btn-add-to-cart").on('click', function() {
    let form = $("#form-add-to-cart")
    let actionUrl = form.attr('action')

    $.ajax({
      type: "POST",
      url: actionUrl,
      data: form.serialize(),
      success: function(data) {
        const toast = new bootstrap.Toast(document.getElementById("success-add-to-cart"))

        toast.show()

        if (data.created_at == data.updated_at) {
          $(".cart-total-items").text(+$(".cart-total-items").text() + 1 )
        }
      } 
    })
  }) 
  
  // Update cart if there is a cart item checked 
  if ($(".input-cart-item:checked").length > 0) {
    let cartItem = $(".input-cart-item:checked").closest((".cart-item"))

    $(".cart-total-price").text(displayPrice(cartItem.find(".item-total-price").text().replaceAll('.', '')))
    $(".cart-final-items").text(1)

    if (cartItem.siblings().length == 0) {
      cartItem.closest(".shop-items").find(".input-shop-items").prop("checked", true)

      if (cartItem.closest(".shop-items").siblings().length == 0) {
        $("#shop-all").prop("checked", true)
      }
    }

    if ($("#btn-checkout").hasClass("disabled")) 
        $("#btn-checkout").removeClass("disabled")
  }

  $("#btn-checkout").on('click', function(e) {
    $(this).attr('href', function(index, href) {
      let itemsChecked = []

      $(".input-cart-item:checked").each(function() {
        itemsChecked.push($(this).closest(".cart-item").children().attr("cart-item-id"))
      })

      return href + "?cart_items_ids=" + itemsChecked.join()
    })
  })

  // Update collection of district when user select a city
  $(document).on('change', "#user_address_form_city", function() {
    changeDistrictCollection("#user_address_form_city", "#user_address_form_district", "#user_address_form_ward")
  })

  function changeDistrictCollection(cityInputId, districtInputId, wardInputId) {
    if ($(districtInputId).prop("disabled")) {
      $(districtInputId).prop("disabled", false)
    }

    let selectedCityId = $(cityInputId + " option:selected").val()
    $.ajax({
      type: "GET",
      url: `/addresses/cities/${selectedCityId}/districts`,
      success: function(data) {
        $(districtInputId + " option:not(:first-child)").remove()
        $(wardInputId + " option:not(:first-child)").remove()

        if (!$(wardInputId).prop("disabled")) {
          $(wardInputId).prop("disabled", true)
        }
        
        data.forEach(function(item) {
          let newOption = "<option value=" + item.id + ">" + item.name + "</option>"
          $(districtInputId).append(newOption)
        })
      }
    })
  }
  
  // Update collection of district when user select a city
  $(document).on('change', "#user_address_form_district", function() {
    changeWardCollection("#user_address_form_district", "#user_address_form_ward")
  })
  
  function changeWardCollection(districtInputId, wardInputId) {
    if ($(wardInputId).prop("disabled"))
      $(wardInputId).prop("disabled", false)

      let selectedDistrictId = $(districtInputId + " option:selected").val()
      $.ajax({
      type: "GET",
      url: `/addresses/districts/${selectedDistrictId}/wards`,
      success: function(data) {
        $(wardInputId + " option:not(:first-child)").remove()

        data.forEach(function(item) {
          let newOption = "<option value=" + item.id + ">" + item.name + "</option>"
          $(wardInputId).append(newOption)
        })
      }
    })
  }

  if ($("#user_addresses").is(":empty")) {
    $("#addressFormModal").modal('show')
  }

  $("#addressFormModal").on("shown.bs.modal", function(){
    $(ClientSideValidations.selectors.forms).validate()
  })

  if ($("#btn-place-order").length) {
    $("#new-address-form").enableClientSideValidations()
    
    let orderTotalPrice = 0

    $(".order-item").each(function() {
      orderTotalPrice += +$(this).find(".item-total-price").text().replaceAll('.','')
    })

    $(".order-total-price").text(displayPrice(orderTotalPrice))
    $(".order-final-price").text(displayPrice(orderTotalPrice + +$(".order-shipping-price").text().replace('.','')))
  }
  
  $("#shop_registration_form_city").on('change', function() {
    changeDistrictCollection("#shop_registration_form_city", "#shop_registration_form_district", "#shop_registration_form_ward")
  })

  $("#shop_registration_form_district").on('change', function() {
    changeWardCollection("#shop_registration_form_district", "#shop_registration_form_ward")
  })

  $("#form-create-order").on('submit', function(e) {
    addDetailsToOrderForm()
    return true
  })

  // Paypal button setup
  if ($("#btn-place-order").length) {
    paypal.Buttons({
      style: {
        layout: 'vertical'
      },
      env: "sandbox",
      createOrder: function() {
        addDetailsToOrderForm(1)
        return $.post("/orders/paypal/create_payment", 
                      $("#form-create-order").serialize()).then(function(data) {
                        return data.token
                      }) 
      },
      onApprove: function(data) {
        console.log(data)
        return $.post("/orders/paypal/execute_payment", {
          orderID: data.orderID
        }).then(function() {
          $("#order_payment_token").val(data.orderID)
          $("#form-finish-payment").submit()
        })
      }
    }).render('#paypal-button-container');
  }

  function addDetailsToOrderForm(paymentMethod = 0) {
    let items = []
    let userAddress = $(".user-address").first().attr("user-address-id")

    $(".order-item").each(function() {
      items.push($(this).children().attr("cart-item-id"))
    })

    $("<input />").attr("type", "hidden")
          .attr("name", "order[cart_items_ids]")
          .attr("value", items.join(','))
          .appendTo("#form-create-order");
    $("<input />").attr("type", "hidden")
          .attr("name", "order[user_address_id]")
          .attr("value", userAddress)
          .appendTo("#form-create-order");
    $("<input />").attr("type", "hidden")
          .attr("name", "order[payment_method]")
          .attr("value", paymentMethod)
          .appendTo("#form-create-order");
  }
})
