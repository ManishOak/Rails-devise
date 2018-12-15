class Salesforce::TransactionComment < ApplicationRecord
  include SalesforceModel
  self.table_name =  ENV['HEROKUCONNECT_SCHEMA'] + '.transaction_comments__c'
end
