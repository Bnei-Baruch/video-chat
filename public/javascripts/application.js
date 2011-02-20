var PUBLISHER_WIDTH = 264;
var PUBLISHER_HEIGHT = 198;

var video_width = 264;
var video_height = 198;

$(function() {
    set_video_size();

    $(window).resize(function() {
        set_video_size();
    });
});

function set_video_size() {
    video_width = $('.videowrapper').width() / 5;
    video_height = video_width * 3 / 4;
    $('.videocontainer object').attr({width:video_width, height:video_height});
}

// Selection of chat-room
$(function() {
    show_menu();
});

function show_menu() {
    $.blockUI({
        message: $('#menu')
    });
}

function check_name() {
    var name = $("#name").val();

    if (name.length == 0) {
        $("#user_name_message").html('Please enter your name');
        return false;
    } else {
        return true;
    }
}

// Support for chat-room menu
$(function() {
    // create a convenient toggleLoading function
    var toggleLoading = function() {
        $("#loading").toggle();
    };
    var checkUserName = function() {
        var name = $("#name").val();
    }
    $("#menu a")
            .bind("ajax:before", checkUserName)
            .bind("ajax:loading", toggleLoading)
            .bind("ajax:complete", toggleLoading)
    //.bind("ajax:success", function(event, data, status, xhr) {
    //$("#content").html(data);
    //});
});

var chat_room_id = 0;
var last_read_message_id = 0;
var interval = 0;

function update_chat() {
    if (chat_room_id == 0) return;
    $.getJSON('/chats/' + chat_room_id + '?start=' + last_read_message_id + '&chat_room=' + chat_room_id, function(data) {
        $.each(data, function(key, val) {
            last_read_message_id = val.chat.id;
            var currentTime = new Date(Date.parse(val.chat.created_at));
            var hours = currentTime.getHours();
            var minutes = currentTime.getMinutes();
            if (minutes < 10) {
                minutes = "0" + minutes;
            }

            $('#chat').append("<div class='name'>" + val.chat.name + "</div><div class='date'>" + hours + ":" + minutes + "</div>");
            $('#chat').append("<div class='msg'>" + val.chat.message + "</div>");
        });
    });


}

function startChat(id) {
    // reset char room
    clearInterval(interval);

    last_read_message_id = 0;
    chat_room_id = id;
    chat_updated_room_id = chat_room_id;
    interval = setInterval(update_chat, 5000);
}
