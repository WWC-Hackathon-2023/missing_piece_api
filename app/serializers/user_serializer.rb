# frozen_string_literal: true

class UserSerializer
  include JSONAPI::Serializer
  attributes :full_name,
             :email,
             :zip_code,
             :phone_number,
             :user_image_url
end