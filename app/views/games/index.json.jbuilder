json.array!(@games) do |game|
  json.extract! game, :id, :boards, :player_count, :player_turn
  json.url game_url(game, format: :json)
end
