// GAME JQUERY
// Use this list to search for game code you need
//
// 1. MAIN MENU
// 2. NEW GAME
//    A. CLASS SELECTION
//    B. OPPONENET SELECTION
//    C. START BUTTON
//    D. CANCEL BUTTON
// 3. GAMEPLAY WINDOW
//    A. DECK CONTROLS
//    B. ADDING/REMOVING CARD TO HAND
//    C. PLAY BUTTON
// 4. POPUP BOXES
//    A. PLAY BUTTON CARD COUNT CHECK
// 10. ATTACK CARD CHOICE BUTTONS

//Global Variables
var player_one_class_id;
var opponent_class_id;
var card_count;
var new_game_start;
var player_setup;
var player_attacking;

// 1. MAIN MENU
$(document).on('click', '#main_menu_start', function() {
  $("#player_deck_show").dialog({
    autoOpen: false
  });
  $('#player_deck_show').dialog('destroy');
  // if ($("#player_deck_show[_dialogInitialized]").length == 1) {
  //   $('#player_deck_show').dialog('destroy');
  // }
  $('#main_screen_render').html("");
  $('#main_screen_render').load("/game/new_game_render");
});

$(document).on('click', '#my_profile_button', function() {
  if ($("#player_deck_show[_dialogInitialized]").length == 1) {
    $('#player_deck_show').dialog('destroy');
  }
  $('#main_screen_render').html("");
  $('#main_screen_render').load("/game/my_profile");
});

$(document).on('click', '#my_games_button', function() {
  if ($("#player_deck_show[_dialogInitialized]").length == 1) {
    $('#player_deck_show').dialog('destroy');
  }
  $('#main_screen_render').html("");
  $('#main_screen_render').load("/game/my_games");
});


// 2. NEW GAME
//                          A. CLASS SELECTION
//    Code for when a class is selected in the new game menu
//    Updates the class_card_panel with information about selected class
//

$(document).on('change', 'input[type=radio][name=class_options]', function(e) {
  player_one_class_id = $(this).val().replace("_select", "");
  console.log("button selection changed to " + player_one_class_id);

  var filters = {'class_selected': player_one_class_id}

  // ================================
  // GETTING CLASS SELECTED info
  // ================================
  var info_html_header = "";
  var info_html_notes = "";
  var info_html = ""
  $.getJSON('game/get_class_info', filters, function(data) {
    $.each(data, function(node_id, node_data) {
      if(node_id == 'created_at' || node_id == 'updated_at' || node_id == 'id') {
        return true;
      }

      switch (node_id) {
        case 'name':
          info_html_header += node_data
          break;
        case 'notes':
          info_html_notes += node_data + "<br>"
          break;
        case 'mp':
          info_html += "<br><div class='defense_list'>DEFENSES</div>"
          info_html += "<b class='defense_type'>MELEE PHYSICAL: </b>"
          info_html += node_data
          info_html += "<br>"
          break;
        case 'rp':
          info_html += "<b class='defense_type'>RANGED PHYSICAL: </b>"
          info_html += node_data
          info_html += "<br>"
          break;
        case 'ms':
          info_html += "<b class='defense_type'>MELEE SPELL: </b>"
          info_html += node_data
          info_html += "<br>"
          break;
        case 'rs':
          info_html += "<b class='defense_type'>RANGED SPELL: </b>"
          info_html += node_data
          info_html += "<br><br>"
          break;
        case 'ally':
          info_html += "<b>ALLY: </b>"
          info_html += node_data
          info_html += "<br>"
          break;
        case 'turn_priority':
          info_html += "<b>Turn Order: </b>"
          info_html += node_data
          info_html += "<br>"
          break;
        case 'health':
          info_html += "<b>HEALTH: </b>"
          info_html += node_data
          info_html += "<br>"
          break;

      }

      $('.class_card_header').html(info_html_header);
      $('.class_card_notes').html(info_html_notes);
      $('.class_card_body').html(info_html);
      $('#class_selected_cards').load("/game/selected_class_cards?" + $.param({class_selected_id:player_one_class_id}));
    });
  });

  $('#class_information').show();
});

//                         B. OPPONENET SELECTION
//    Code for when a class is selected in the new game menu
//    Updates the class_card_panel with information about selected class
//
$(document).on('change', 'input[type=radio][name=opponent_options]', function() {
  opponent_class_id = $(this).val().replace("_opponent", "");
  console.log("button selection changed to " + opponent_class_id);

  var filters = {'opponent_selected': opponent_class_id}

  // ================================
  //  GETTING OPPONENT INFO
  // ================================
  var info_html_header = "";
  var info_html_notes = "";
  var info_html = ""
  $.getJSON('game/get_opponent_info', filters, function(data) {
    $.each(data, function(node_id, node_data) {
      if(node_id == 'created_at' || node_id == 'updated_at') {
        return true;
      }

      switch (node_id) {
        case 'name':
          info_html_header += node_data
          break;
        case 'notes':
          info_html_notes += node_data + "<br>"
          break;
        case 'mp':
          info_html += "<br><div class='defense_list'>DEFENSES</div>"
          info_html += "<b class='defense_type'>MELEE PHYSICAL: </b>"
          info_html += node_data
          info_html += "<br>"
          break;
        case 'rp':
          info_html += "<b class='defense_type'>RANGED PHYSICAL: </b>"
          info_html += node_data
          info_html += "<br>"
          break;
        case 'ms':
          info_html += "<b class='defense_type'>MELEE SPELL: </b>"
          info_html += node_data
          info_html += "<br>"
          break;
        case 'rs':
          info_html += "<b class='defense_type'>RANGED SPELL: </b>"
          info_html += node_data
          info_html += "<br><br>"
          break;
        case 'ally':
          info_html += "<b>ALLY: </b>"
          info_html += node_data
          info_html += "<br>"
          break;
        case 'turn_priority':
          info_html += "<b>Turn Order: </b>"
          info_html += node_data
          info_html += "<br>"
          break;
        case 'health':
          info_html += "<b>HEALTH: </b>"
          info_html += node_data
          info_html += "<br>"
          break;

      }

      $('.opponent_card_header').html(info_html_header);
      $('.opponent_card_notes').html(info_html_notes);
      $('.opponent_card_body').html(info_html);
    });
  });
});

// C. START BUTTON
$(document).on('click', "#start_new_game", function(e) {
  new_game_start = true;
  player_setup = true;
  console.log("Oppenent selected: " + opponent_class_id);
  console.log("starting game with " + player_one_class_id);

  if(typeof opponent_class_id == 'undefined') {
    $( "#error_popup" ).html('Please select an opponent!');
    view_error_popup();
  } else if (typeof player_one_class_id == 'undefined') {
    $( "#error_popup" ).html('You need to select a class.');
    view_error_popup();
  } else {
    $('#main_screen_render').html("");
    $('#class_selected_cards').html("");
    $('#gameplay_info').html("");
    $('#main_screen_render').load("/game/setup_new_game?" + $.param({class_selected_id:player_one_class_id, opponent_selected_id:opponent_class_id}), function() {
      $('#opponent_play_cards').load("/game/setup_ai_play_hand?" + $.param({opponent_selected_id:opponent_class_id}));
      update_info_boxes();
    });
  }

});

//    D. CANCEL BUTTON
$(document).on('click', '#cancel_new_game', function() {
  $('#main_screen_render').html("");
  $('#class_selected_cards').html("");
  $('#gameplay_info').html("");
  $('#main_screen_render').load("/game/intro_page_render");
});



// ============================================
//         3. GAMEPLAY WINDOW
// ============================================

// A. DECK CONTROLS
//WHEN CLICKING THE CLASS CARD DECK
$(document).on('click', "#player_deck_stack", function() {
  if(player_setup == true) {
    view_player_deck();
  }
});

//      B. ADDING/REMOVING CARD TO HAND
//WHEN CLICKING A CARD IN THE DECK TO ADD TO PLAYER HAND
$(document).on('click', '#card_to_add_to_hand', function() {
  $('#player_hand_cards').load("/game/add_card_to_hand?" + $.param({add_to_hand: $(this).data('cardvalue')}), function() {
    $('#player_deck_all').load("/game/get_current_deck");
    card_count = parseInt($('#ready_play_button').data('count'));
    if(card_count == 3) {
      $('#ready_play_button').show();
    }
    refresh_player_deck();
  });
});
//WHEN CLICKING ON CARD IN HAND TO REMOVE, PRIOR TO PLAY
$(document).on('click', '#card_to_remove_from_hand', function() {
  $('#player_hand_cards').load("/game/remove_card_from_hand?" + $.param({remove_from_hand: $(this).data('cardvalue')}), function() {
    $('#player_deck_all').load("/game/get_current_deck");
    card_count = parseInt($('#ready_play_button').data('count'));
    if(card_count < 1) {
      $('#ready_play_button').hide();
    }
    refresh_player_deck();
  });
});

//        C. PLAY BUTTON
$(document).on('click', '#ready_play_button', function() {
  new_game_start = false;
  player_setup = false;
  if ($("#player_deck_show[_dialogInitialized]").length == 1) {
    $('#player_deck_show').dialog('destroy');
  }
  card_count = parseInt($(this).data('count'));
  card_ids = parseInt($(this).data('current_hand'));
  console.log("Playing with " + card_count);
  $('#player_hand_cards').load("/game/start_round?" + $.param({class_selected_id:player_one_class_id, opponent_selected_id:opponent_class_id, card_ids:card_ids}));
  update_info_boxes();
});

//       D. ATTACK BUTTON
$(document).on('click', "#attack_button", function(e) {
  player_attacking = true
  var attack_card_selected = $('input[type=radio][name=attack_selection]:checked').val().replace("_attack", "");
  $('#gameplay_middle_update').html("");

  $('#gameplay_middle_update').load("/game/determine_action?" + $.param({action_played:'attack', class_selected_id:player_one_class_id, opponent_selected_id:opponent_class_id, selected_card_id: attack_card_selected}), function() {
    update_info_boxes();
    $('#player_hand_cards').load("/game/update_player_hand?" + $.param({from_action: 'none'}));
    $('#opponent_play_cards').load("/game/update_ai_play_hand");
  });

});

//       E. DEFEND BUTTON
$(document).on('click', "#defend_button", function(e) {
  player_attacking = false
  var defend_card_selected = $('input[type=radio][name=defend_selection]:checked').val().replace("_attack", "");
  $('#gameplay_middle_update').html("");

  $('#gameplay_middle_update').load("/game/determine_action?" + $.param({action_played:'defend', class_selected_id:player_one_class_id, opponent_selected_id:opponent_class_id, selected_card_id: defend_card_selected}), function() {
    update_info_boxes();
    $('#player_hand_cards').load("/game/update_player_hand?" + $.param({from_action: 'none'}));
    $('#opponent_play_cards').load("/game/update_ai_play_hand");
  });

});

//       F. CONTINUE BUTTON
$(document).on('click', "#continue_round_button", function(e) {
  $('#gameplay_middle_update').html("");

  $('#gameplay_middle_update').load("/game/determine_action?" + $.param({action_played:'continue_round', class_selected_id:player_one_class_id, opponent_selected_id:opponent_class_id}), function() {
    update_info_boxes();
    if(player_attacking == true) {
      $('#player_hand_cards').load("/game/update_player_hand?" + $.param({from_action: 'defend'}));
    } else {
      $('#player_hand_cards').load("/game/update_player_hand?" + $.param({from_action: 'attack'}));
    }
  });

});

//       G. SKIP ATTACK
$(document).on('click', "#skip_attack_button", function(e) {
  var opponent_skipped = $('#opponent_attack').data('opponentskipped');
  console.log("opponent_skipped: " + opponent_skipped);
});

//       G. SKIP DEFEND
$(document).on('click', "#skip_defend_button", function(e) {
  var opponent_skipped = $('#opponent_attack').data('opponentskipped');
  var html_value = ""
  html_value += "<div class='row'>"
  html_value += "<div class='col-sm-2'><small><b>Opponent skipped</b</small></div>"
  html_value += "<div class='col-sm-3'></div>"
  html_value += "<div class='col-sm-4'><b>Player skipped</b></div>"
  html_value += "<div class='col-sm-2'><br><br><br><div class='btn btn-small btn-success' id='next_round_button'>End Round</div></div>"
  html_value += "</div>"
  $('#gameplay_middle_update').html(html_value);
  $('#player_hand_cards').load("/game/determine_action?" + $.param({action_played:'new_round', class_selected_id:player_one_class_id, opponent_selected_id:opponent_class_id}), function() {
    $('#player_hand_cards').load("/game/update_player_hand?" + $.param({from_action: 'none'}));
    update_info_boxes();
  });
});


// ============================================
//         4. POPUP BOXES
// ============================================

//         A. PLAY BUTTON CARD COUNT CHECK
function update_info_boxes() {
  $('#player_info').load("/game/update_player_info?" + $.param({class_selected_id:player_one_class_id}));
  $('#opponent_info').load("/game/update_opponent_info?" + $.param({opponent_selected_id:opponent_class_id}));
  console.log("updating round info with new_game_start value: " + new_game_start);
  $('#round_info').load("/game/update_round_info?" + $.param({new_game_start:new_game_start}));
}

function view_error_popup() {
  console.log("error popped up!");
  $('#error_popup').dialog({
      title: 'ERROR' ,
      // modal: 'true',
      maxWidth:500,
      maxHeight: 210,
      width: 500,
      height: 210,
      show: 'scale',
      hide: 'scale',
      cache: false });
}

function view_player_deck() {
    $('#player_deck_show').load('/game/get_current_deck').attr("_dialogInitialized", "yes").dialog({
        title: 'DECK' ,
        // modal: 'true',
        maxWidth:1200,
        maxHeight: 320,
        width: 1200,
        height: 320,
        position: 'center',
        show: 'scale',
        hide: 'scale',
        cache: false });
}

function refresh_player_deck(){
  $('#dialog').dialog('destroy');
  view_player_deck();
}

// ============================================
//         5. GAMEPLAY MIDDLE WINDOW
// ============================================

//update after opponent attacks
function update_gameplay_middle_opponent(attack_card) {
  $('#opponent_play_cards').load("/game/update_ai_play_hand");
  $('#gameplay_middle_update').load("/game/update_gameplay_middle?" + $.param({player_attacking:false, attack_card_id:attack_card}), function() {
    update_info_boxes();
  });
}

//update after opponent attacks
function update_gameplay_middle_player(attack_card) {
  $('#opponent_play_cards').load("/game/update_ai_play_hand");
  $('#gameplay_middle_update').load("/game/update_gameplay_middle?" + $.param({player_attacking:true, attack_card_id:attack_card}), function() {
    update_info_boxes();
  });
}

// ============================================
//         6. GAMEPLAY TICKER
// ============================================
function update_gameplay_ticker(info_string) {
  $('#gameplay_info').append("<small>" + info_string + "</small><br><br>");
}

// ============================================
//         10. ATTACK CARD CHOICE BUTTONS
// ============================================
$(document).on('change', 'input[type=radio][name=attack_selection]', function(e) {
  var attack_card_selected = $(this).val().replace("_attack", "");
  console.log("attacking with " + attack_card_selected);

});
