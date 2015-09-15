class MessagesController < ApplicationController
  def new
  end

  def create    
    @phone_number = message_params[:phone_number]
    @message = message_params[:message]
  	if send_message(@phone_number, @message )
 		flash[:danger] = "Success!" 	
  	else
  		flash[:danger] = "The Phone number entered is invalid or not validated on Twillio!  Please Try a valid phone number or contact developer to validate your phone number on Twillio prior to sending message."
  		redirect_to :action => 'new'
  	end
  end

private
  def message_params
    params.require(:message).permit(:phone_number, :message)
  end

  def send_message(phone_number, message)
   	#require 'rubygems' # not necessary with ruby 1.9 but included for completeness 
	require 'twilio-ruby' 
	if valid?(phone_number)
		# put your own credentials here 
		account_sid = 'AC7e5a79732f34bf01650161e38025237d' 
		auth_token = 'fdd2c6af278529c928a37443533637d3' 
		 
		# set up a client to talk to the Twilio REST API 
		@client = Twilio::REST::Client.new account_sid, auth_token 
		 
		@client.account.messages.create({
			:from => '+16307556529', 
			:to => phone_number, 
			:body => message,  
		})
	else
		#flash[:danger] = "The Phone number entered is invalid!  Please Try a valid phone number."
		return false
	end 
  end


  def valid?(phone_number)

	# put your own credentials here 
	account_sid = 'AC7e5a79732f34bf01650161e38025237d' 
	auth_token = 'fdd2c6af278529c928a37443533637d3' 

	  lookup_client = Twilio::REST::LookupsClient.new(account_sid, auth_token)
	  begin
	    response = lookup_client.phone_numbers.get(phone_number)
	    response.phone_number #if invalid, throws an exception. If valid, no problems.
	    return true
	  rescue => e
	      return false
	end

end


end
