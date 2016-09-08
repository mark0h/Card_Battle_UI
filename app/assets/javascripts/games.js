//Global Variables
var class_selected;
var player_one_class_id;

$(document).ready(function() {
  console.log("document ready! yea");
});

$(document).on('click', '#main_menu_start', function() {
  $('#main_screen_render').html("");
  $('#main_screen_render').load("/game/new_game_render");
});

$(document).on('click', '#my_profile_button', function() {
  $('#main_screen_render').html("");
  $('#main_screen_render').load("/game/my_profile");
});

$(document).on('click', '#my_games_button', function() {
  $('#main_screen_render').html("");
  $('#main_screen_render').load("/game/my_games");
});


$(document).on('click', '#cancel_new_game', function() {
  $('#main_screen_render').html("");
  $('#main_screen_render').load("/game/intro_page_render");
});


//                          CLASS SELECTION
//    Code for when a class is selected in the new game menu
//    Updates the class_card_panel with information about selected class
//
$(document).on('change', 'input[type=radio][name=class_options]', function(e) {
  console.log("button selection changed to " + $(this).val());
  class_selected = $(this).val();
  var filters = {'class_selected': class_selected}

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

$(document).on('click', "#start_new_game", function(e) {
  console.log("starting game with " + class_selected);
  $('#main_screen_render').html("");
  $('#class_selected_cards').html("");
  $('#main_screen_render').load("/game/setup_new_game?" + $.param({class_selected_id:player_one_class_id}));
});


// ============================================
//         GAMEPLAY WINDOW FUNCTIONS
// ============================================

$(document).on('click', "#player_deck_stack", function() {
  $('#player_deck_all').show();
});

$(document).on('click', "#close_player_deck", function() {
  $('#player_deck_all').hide();
})
