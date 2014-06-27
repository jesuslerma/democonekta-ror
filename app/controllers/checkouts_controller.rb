class CheckoutsController < ApplicationController
  def index
  end

  def charge
  	begin
	  @charge = Conekta::Charge.create({
	    amount: params['chargeInCents'],
	    currency: "MXN",
	    description: "Pizza Delivery at CMPMX",
	    reference_id: "001-id-cmpmx-jlerma",
	    card: params[:conektaTokenId] 
		#"tok_a4Ff0dD2xYZZq82d9"
	  })
	  charge_n = Charge.new(id: @charge.id,
    	amount:  @charge.amount,
	    livemode: @charge.livemode,
	    created_at: @charge.created_at,
	    status: @charge.status,
	    currency: @charge.currency,
	    description: @charge.description,
	    reference_id: @charge.reference_id,
	    failure_code: @charge.failure_code,
	    failure_message: @charge.failure_message,
	    card_name: @charge.payment_method.name,
	    card_exp_month: @charge.payment_method.exp_month,
	    card_exp_year: @charge.payment_method.exp_year,
	    card_auth_code: @charge.payment_method.auth_code,
	    card_last4: @charge.payment_method.last4,
	    card_brand: @charge.payment_method.brand
		)
		if charge_n.save
			render 'checkouts/charge'	
		else
			respond_to raise
		end
		rescue Conekta::ValidationError => e
	  	puts e.message 
			#alguno de los parámetros fueron inválidos
		rescue Conekta::ProcessingError => e
	  	puts e.message 
			#la tarjeta no pudo ser procesada
		rescue Conekta::Error
	  	puts e.message 
		#un error ocurrió que no sucede en el flujo normal de cobros como por ejemplo un auth_key incorrecto
		end
  end
  def oxxo
  end
  def charge_oxxo
  	begin
	  @charge = Conekta::Charge.create({
	    amount: params[:chargeInCentsOxxo],
	    currency: "MXN",
	    description: "Compra en tienda breaking bad",
	    reference_id: "id_interno_de_orden",
	    cash: {
	      "type"=> "oxxo",
	      "expires_at"=> "2015-03-04"
	    }
	  })
   	charge_n = Charge.new(id: @charge.id,
    	amount:  @charge.amount,
	    livemode: @charge.livemode,
	    created_at: @charge.created_at,
	    status: @charge.status,
	    currency: @charge.currency,
	    description: @charge.description,
	    reference_id: @charge.reference_id,
	    failure_code: @charge.failure_code,
	    failure_message: @charge.failure_message
		)
		if charge_n.save
			render 'checkouts/charge'	
		else
			respond_to raise
		end
	  #redirect_to @charge.payment_method.barcode_url
	  
	rescue Conekta::ValidationError => e
	  puts e.message 
	#alguno de los parámetros fueron inválidos
	rescue Conekta::ProcessingError => e
	  puts e.message 
	#la tarjeta no pudo ser procesada
	rescue Conekta::Error
	  puts e.message 
	#un error ocurrió que no sucede en el flujo normal de cobros como por ejemplo un auth_key incorrecto
	end
  end
end
