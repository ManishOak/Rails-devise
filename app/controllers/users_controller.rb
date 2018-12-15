class UsersController < ApplicationController
  # before_action :authenticate_user!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to root_path, :alert => "Access denied."
    end
  end

  def user_create

    User.invite!({:email => params[:sender_email]}) unless User.find_by_email(params[:sender_email]).present? && User.find_by_email(params[:sender_email]).invitation_accepted_at.present? 
    seller = Salesforce::Contact.find_or_initialize_by(email: params[:sender_email], lastname: "testing")
    if seller.new_record?
      seller.heroku_id__c = SecureRandom.hex(10)
    end
    seller.save

    User.invite!({:email => params[:buyer_email]}) unless User.find_by_email(params[:buyer_email]).present? && User.find_by_email(params[:buyer_email]).invitation_accepted_at.present?
    buyer = Salesforce::Contact.find_or_initialize_by(email: params[:buyer_email], lastname: "testing")
    if buyer.new_record?
      buyer.heroku_id__c = SecureRandom.hex(10)
    end
    buyer.save

    Salesforce::MiddleManTransaction.create(buyer_email__c: buyer.email, seller_email__c: seller.email, heroku_id__c: SecureRandom.hex(10))
    redirect_to root_path, :notice => "Begin Transaction successfully..!"
  end

  def total_transaction
    @buyes_records = Salesforce::MiddleManTransaction.where(buyer_email__c: current_user.email)
    @seller_records = Salesforce::MiddleManTransaction.where(seller_email__c: current_user.email)
  end

  def new_transaction
    @comments = Salesforce::TransactionComment.where(middlemantransactions__c: params[:id])
  end

  def create_transaction
    comment = Salesforce::TransactionComment.new(middlemantransactions__c: params[:middlemantransactions], comments__c: params[:comments__c])
    comment.save
    redirect_to new_transaction_path(:id => params[:middlemantransactions])
  end
end
