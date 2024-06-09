class PublicController < ApplicationController

def purchase
    @lottery = Lottery.find(params[:id])
    # @member = Member.find_by(phone: params[:phone]) 
end 

def check_phone
    @member = Member.find_by(phone: params[:phone])
    if @member
        render json: { found: true, name: @member.name }
    else
        render json: { found: false }
    end
end
end