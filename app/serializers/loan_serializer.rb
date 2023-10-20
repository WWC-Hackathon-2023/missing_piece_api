class LoanSerializer
  include JSONAPI::Serializer
  attributes :owner_id, 
             :borrower_id, 
             :puzzle_id, 
             :status
end