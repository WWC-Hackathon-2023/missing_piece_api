class UserSerializer
  include JSONAPI::Serializer
  attributes :full_name, 
             :email, 
             :zip_code, 
             :phone_number, 
             :user_image_url

  # There are two ways to write this syntax for Proc
  # OPTION 1: the value of xxxx_loans is an array of hashes
  attributes :owner_loans, if: Proc.new { |record, params| 
    if params[:action] == 'dashboard'
      LoanSerializer.new(record.owner_loans)
    end
  }

  attributes :borrower_loans, if: Proc.new { |record, params| 
    if params[:action] == 'dashboard'
      LoanSerializer.new(record.borrower_loans)
    end
  }

  # OPTION 2: the value of xxxx_loans is a hash with key of data that is an array of hashes
  # attributes :owner_loans, if: Proc.new { |record, params| params[:action] == 'dashboard' } do |object, params|
  #   LoanSerializer.new(object.owner_loans)
  # end

  # attributes :borrower_loans, if: Proc.new { |record, params| params[:action] == 'dashboard' } do |object, params|
  #   LoanSerializer.new(object.borrower_loans)
  # end

  # NOTE: on Proc.new
  # We are providing a block of code that returns true or false based on the condition params[:action] == "dashboard." 
  # The Proc acts as a callable object that the serializer can use to determine whether the attribute should be included 
  # or not. So, the Proc.new is used to properly encapsulate the conditional logic and return a boolean value, allowing 
  # the serializer to determine whether to include the :borrower_loans attribute based on the value of params[:action].
end