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





//Global Variables
var class_selected;
var opponent_selected;
var player_one_class_id;
var opponent_class_id;
var deck_open = false;
var card_count;

// 1. MAIN MENU
$(document).on('click', '#main_menu_start', function() {
  $('#dialog').dialog('destroy');
  $('#main_screen_render').html("");
  $('#main_screen_render').load("/game/new_game_render");
});

$(document).on('click', '#my_profile_button', function() {
  $('#dialog').dialog('destroy');
  $('#main_screen_render').html("");
  $('#main_screen_render').load("/game/my_profile");
});

$(document).on('click', '#my_games_button', function() {
  $('#dialog').dialog('destroy');
  $('#main_screen_render').html("");
  $('#main_screen_render').load("/game/my_games");
});


// 2. NEW GAME
//                          A. CLASS SELECTION
//    Code for when a class is selected in the new game menu
//    Updates the class_card_panel with information about selected class
//

$(document).on('change', 'input[type=radio][name=class_options]', function(e) {
  console.log("button selection changed to " + $(this).val());
  class_selected = $(this).val();

  var filters = {'class_selected': class_selected}

  // ================================
  // GETTING CLASS SELECTED info
  // ================================
  var info_html_header = "";
  var info_html_notes = "";
  var info_html = ""
  $.getJSON('game/get_class_info', filters, function(data) {
    $.each(data, function(node_id, node_data) {
      if(node_id == 'created_at' || node_id == 'updated_at') {
        return true;
      }
      if(node_id == 'id') {
        console.log("id node " + node_data);
        player_one_class_id = node_data;
        $('#class_selected_cards').load("/game/selected_class_cards?" + $.param({class_selected_id:player_one_class_id}));
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
        case 'health':
          info_html += "<b>HEALTH: </b>"
          info_html += node_data
          info_html += "<br>"
          break;

      }

      $('.class_card_header').html(info_html_header);
      $('.class_card_notes').html(info_html_notes);
      $('.class_card_body').html(info_html);
    });
  });



  $('#class_information').show();
});

//                         B. OPPONENET SELECTION
//    Code for when a class is selected in the new game menu
//    Updates the class_card_panel with information about selected class
//
$(document).on('change', 'input[type=radio][name=opponent_options]', function() {
  opponent_selected = $(this).val();
  console.log("button selection changed to " + $(this).val());

  var filters = {'opponent_selected': opponent_selected}

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
      if(node_id == 'id') {
        console.log("id node " + node_data);
        opponent_class_id = node_data;
        $('#opponent_selected_cards').load("/game/opponent_class_cards?" + $.param({opponent_selected_id:opponent_class_id}));
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
  console.log("Oppenent selected: " + opponent_selected);
  console.log("starting game with " + class_selected);

  if(typeof opponent_selected == 'undefined') {
    $( "#error_popup" ).html('Please select an opponent!');
    view_error_popup();
  } else if (typeof class_selected == 'undefined') {
    $( "#error_popup" ).html('You need to select a class.');
    view_error_popup();
  } else {
    $('#main_screen_render').html("");
    $('#class_selected_cards').html("");
    $('#gameplay_info').html("");
    $('#main_screen_render').load("/game/setup_new_game?" + $.param({class_selected_id:player_one_class_id, opponent_selected_id:opponent_class_id}), function() {
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
  var card_count = parseInt($(this).data('count'));
  console.log("Playing with " + card_count);
  view_player_deck();
});

//      B. ADDING/REMOVING CARD TO HAND
//WHEN CLICKING A CARD IN THE DECK TO ADD TO PLAYER HAND
$(document).on('click', '#card_to_add_to_hand', function() {
  $('#player_hand_cards').load("/game/add_card_to_hand?" + $.param({add_to_hand: $(this).attr('title')}), function() {
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
  $('#player_hand_cards').load("/game/remove_card_from_hand?" + $.param({remove_from_hand: $(this).attr('title')}), function() {
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

  card_count = parseInt($(this).data('count'));
  console.log("Playing with " + card_count);
  if(card_count < 3) {
    $( "#error_popup" ).html('Must select 3 cards!');
    $( "#error_popup" ).dialog( "open" );
  } else {
    $( "#error_popup" ).html('Awesome, ready to play(soon!)');
    $( "#error_popup" ).dialog( "open" );
  }
});


// ============================================
//         4. POPUP BOXES
// ============================================

//         A. PLAY BUTTON CARD COUNT CHECK
function update_info_boxes() {
  $('#player_info').load("/game/update_player_info?" + $.param({class_selected_id:player_one_class_id}));
  $('#opponent_info').load("/game/update_opponent_info?" + $.param({class_selected_id:opponent_class_id}));
}

function view_error_popup() {
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
    $('#player_deck_show').load('/game/get_current_deck').dialog({
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
