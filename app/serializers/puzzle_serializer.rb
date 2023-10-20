class PuzzleSerializer
  include JSONAPI::Serializer
  attributes :user_id, 
             :status, 
             :title, 
             :description, 
             :total_pieces, 
             :notes, 
             :puzzle_image_url
end