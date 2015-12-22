class GamesController < ApplicationController
  before_action :set_game, only: [:update, :check_turn]

  # GET /games
  # GET /games.json
  def index
  end

  # GET /games/1
  # GET /games/1.json
  def show
    redirect_to action: 'new' and return if params[:id].nil?
    @game = Game.find(params[:id])

    @game.player_count = @game.player_count + 1
    @game.save!

    @player = (@game.player_count % 2) == 1 ? 1 : 2
    @enemy_board = @game.return_enemy_board(@player)
    @own_board = @game.boards[@player - 1]
    @winner = @game.winner
    

  rescue ActiveRecord::RecordNotFound
     redirect_to action: 'new'
  end

  def check_turn
    player = params[:game][:player].to_i
    render json: {
        board: @game.boards[player - 1],
        turn: @game.player_turn,
        winner: @game.winner
      }
  end

  # GET /games/new
  def new
    @game = Game.new
    @game.save!
    redirect_to action: 'show', id: @game.id and return
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games
  # POST /games.json
  def create
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    player = params[:game][:player]
    # make shot
    @game.add_board_shot(player, params[:game][:position]) if player == @game.player_turn
    # set change player turn
    @game.player_turn = (player == 1) ? 2 : 1
    @game.save!
    render json: {
        board: @game.return_enemy_board(player)
      }
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:game][:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:id, :player, :player_turn, :position)
    end
end
