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
	    amount: 51000,
	    currency: "MXN",
	    description: "Pizza Delivery",
	    reference_id: "id_interno_de_orden",
	    cash: {
	      "type"=> "oxxo",
	      "expires_at"=> "2015-03-04"
	    }
	  })
	  redirect_to @charge.payment_method.barcode_url
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
