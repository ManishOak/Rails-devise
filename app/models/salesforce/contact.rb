class Salesforce::Contact < ApplicationRecord
  include SalesforceModel
  self.table_name =  ENV['HEROKUCONNECT_SCHEMA'] + '.contact'
end
