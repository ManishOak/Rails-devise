class Salesforce::MiddleManTransaction < ApplicationRecord
  include SalesforceModel
  self.table_name =  ENV['HEROKUCONNECT_SCHEMA'] + '.middlemantransaction__c'
end
