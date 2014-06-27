# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
totalprice= 0
conektaSuccessResponseHandler = (token) ->
 $form = $("#card-form")

 ### Inserta el token_id en la forma para que se envíe al servidor ###
 $form.append $("<input type=\"hidden\" name=\"conektaTokenId\" />").val(token.id)

 ### and submit ###
 $form.get(0).submit()
 return
conektaErrorResponseHandler = (response) ->
 $form = $("#card-form")

 ### Muestra los errores en la forma ###
 $form.find(".card-errors").text response.message
 $form.find("button").prop "disabled", false
 return
toCents = (price)->
	price*100
fromCents= (price) ->
	price/100
jQuery ($) ->
	$('.product2store').on 'click', ->
		value= $(this).parent().parent().find('.panel-heading .price').html()
		clearval= toCents numeral().unformat(value)
		totalprice += clearval
		console.log totalprice
		$("input[name='chargeInCents']").val(totalprice)
		$("input[name='chargeInCentsOxxo']").val(totalprice)
	$('.price').each (i, it)->
		value = parseFloat $(this).html()
		$(this).html(numeral(fromCents value).format('$00[.]00'))
 $("#card-form").submit (event) ->
   $form = $(this)
   ### Previene hacer submit más de una vez ###
   $form.find("button").prop "disabled", true
   Conekta.token.create $form, conektaSuccessResponseHandler, conektaErrorResponseHandler

   ### Previene que la información de la forma sea enviada al servidor ###
   false
 return