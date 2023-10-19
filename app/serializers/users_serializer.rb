class UsersSerializer
  include JSONAPI::Serializer
  attributes :full_name, :email, :zip_code, :phone_number, :user_image_url

  # NOTE: I think we can add the other attributes to the user without having to create a different serializer
  # when calling on a different controller action: like an unrestful route called "dashboard" possibly

  # attributes: :puzzles do |object, params|
  #   if params[:action] == "dashboard"
  #     PuzzleSerializer.new(object.puzzles)
  #   end
  # end
end