setTimeout(checkTurn, 1000);

$(document).on('click', "#enemy_board .empty", function() {

  if ((turn !== player) || (gameOngoing === false)) {
    return false;
  }

  var position = $(this).data('position');

  $.ajax({
       type: "PUT",
       contentType: "application/json; charset=utf-8",
       url: "/games/update",
       data : JSON.stringify({
         game: {
           id: gameId,      //  defined in view
           player: player,  //  defined in view
           position: position
         }
       }),
       dataType: "json",
       success: function (result) {
         $("#instructions").html("Waiting for other player!");
          updateBoard("enemy_board", result.board);
       },
       error: function (){
          console.log("games update fail");
       }
  });
});

function updateBoard(grid, array) {
  grid = $("#" + grid);
  for(var i = 0, len = array.length; i < len; i++) {
    var td =  grid.find("td[data-position='" + i +"']");
    var tdClass = (array[i] === null) ? "empty" : array[i];

    td.removeClass().addClass(tdClass);
  }
};

function checkTurn() {
  $.ajax({
       type: "GET",
       contentType: "application/json; charset=utf-8",
       url: "/games/check_turn?game[id]=" + gameId + "&game[player]=" + player,
       dataType: "json",
       success: function (result) {
         if (result.turn === player) {
           turn = player;
           updateBoard("own_board", result.board);
           $("#instructions").html("Your turn!");
         }

         if(result.winner > 0) {
           gameOngoing = false  //  instantiated in view
           // let the winner know
           gameOver(result.winner);
         } else {
           // continue to run turn checks
           setTimeout(checkTurn, 2000);
         }
       },
       error: function (){
         console.log("turn check fail");
       }
  });
};

function gameOver(winner) {
  var bodyClass = "loser";
  var instructionText = "You lose!"

  if(winner === player) {
    bodyClass = "winner";
    instructionText = "You win!"
  }

  $("body").addClass(bodyClass);
  $("#instructions").html(instructionText);
};
