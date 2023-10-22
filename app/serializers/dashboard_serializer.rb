# frozen_string_literal: true

class DashboardSerializer
  include JSONAPI::Serializer
  attributes :user_info,
             :owner_loans,
             :borrower_loans
end
