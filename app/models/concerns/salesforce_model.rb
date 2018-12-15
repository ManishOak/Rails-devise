module SalesforceModel
  extend ActiveSupport::Concern

  def hc_errors
    HerokuconnectTriggerLog.where(:record_id => self.id, :state => 'FAILED').order("id DESC").all
  end

  def hc_last_error
    errs = hc_errors()
    errs[0] ? errs[0].sf_message : nil
  end

  def set_sfid
    self.sfid = SecureRandom.hex(5) if self.sfid.nil?
  end

  included do
    unless Rails.env.production?
      before_save :set_sfid
    end

    if Rails.env.test?
      establish_connection ENV['HEROKUCONNECT_URL_TEST']
    else
      establish_connection ENV['HEROKUCONNECT_URL']
    end
  end
end

class HerokuconnectTriggerLog < ActiveRecord::Base
  include SalesforceModel
  self.table_name = ENV['HEROKUCONNECT_SCHEMA'] + '._trigger_log'

  def self.pending
    HerokuconnectTriggerLog.where(:state => 'NEW').count
  end
end
