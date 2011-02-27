var PUBLISHER_WIDTH = 220;
var PUBLISHER_HEIGHT = 165;

var video_width = 264;
var video_height = 198;

$(function() {
    set_video_size();

    $(window).resize(function() {
        set_video_size();
    });
});

function set_video_size() {
    $('.videos').css('min-height', $(window).height() - 272);
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
    };
    $("#menu a")
            .bind("ajax:before", checkUserName)
            .bind("ajax:loading", toggleLoading)
            .bind("ajax:complete", toggleLoading)
    //.bind("ajax:success", function(event, data, status, xhr) {
    //$("#content").html(data);
    //});
});

var chat_member_id = 0;

function display_chat_message(chat, append) {
    if (arguments.length == 1)
        append = true;
    var currentTime = new Date(Date.parse(chat.created_at));
    var hours = currentTime.getHours();
    var minutes = currentTime.getMinutes();
    if (minutes < 10) {
        minutes = "0" + minutes;
    }

    if (append) {
        $('#chat').append("<div class='name'>" + chat.name + "</div><div class='date'>" + hours + ":" + minutes + "</div>");
        $('#chat').append("<div class='msg'>" + chat.message + "</div>");
        $('#chat').attr("scrollTop", $("#chat").attr("scrollHeight") - $('#chat').height());
    } else {
        $('#chat').prepend("<div class='name'>" + chat.name + "</div><div class='date'>" + hours + ":" + minutes + "</div>");
        $('#chat').prepend("<div class='msg'>" + chat.message + "</div>");
    }
}
function update_chat(chat_room_id) {
    if (chat_room_id == 0) return;
    $.getJSON('/chats/' + chat_room_id + '?chat_room=' + chat_room_id + '&member_id=' + chat_member_id,
            function(data) {
                $.each(data, function(key, val) {
                    display_chat_message(val.chat, true);
                });
            });
}
function all_members(members) {
    total_members = members.length;
    $("#members-on").html("" + total_members + " " + (total_members == 1 ? "member" : "members"));
    $("#members").html("");
    $.each(members, function(idx, member) {
        add_member(member);
    });
    $("#members").attr("scrollTop", $("#members").attr("scrollHeight") - $('#members').height());
}
function add_member(member) {
    user = member.chat_user;
    actor = user.id == chat_member_id ? ' (you)' : (user.is_broadcaster ? ' (host)' : ' (guest)')
    $("#members").append("<li id='member-" + user.id + "'>" + user.name + actor + "</li>");
    $("#members").attr("scrollTop", $("#members").attr("scrollHeight") - $('#members').height());
}
function remove_member(member) {
    user_id = member.chat_user.id;
    $("#member-" + user_id).remove();
    $("#members").attr("scrollTop", $("#members").attr("scrollHeight") - $('#members').height());
}

function startPusherChat(session_id, member_id) {
    // Enable pusher logging - don't include this in production
//    Pusher.log = function() {
//        if (window.console) window.console.log.apply(window.console, arguments);
//    };
//
//    // Flash fallback logging - don't include this in production
//    WEB_SOCKET_DEBUG = true;

    Pusher.channel_auth_endpoint = '/client/authenticate?user_id=' + member_id;
    var pusher = new Pusher('46ee62dcbfe82eb253a9');
    var channel = pusher.subscribe('channel-' + session_id);
    channel.bind('new_message_event', function(data) {
        display_chat_message(data);
    });

    var presenceChannel = pusher.subscribe('presence-' + session_id)
    presenceChannel.bind('pusher:subscription_succeeded', function(members) {
        all_members(members);
    });
    presenceChannel.bind('pusher:member_added', function(member) {
        add_member(member);
    });
    presenceChannel.bind('pusher:member_removed', function(member) {
        remove_member(member);
    });

    chat_member_id = member_id;

    update_chat(session_id);
}

$(function() {
// Enter key to send message
    $('#chat_message').live('keydown', function(event) {
        // Shift + Enter
        if (event.which == 13 && event.shiftKey) {
            event.shiftKey = false;
            $('#chat_message').trigger(event);
        }
        else if (event.keyCode == 13) {
            $('#new_chat').submit();
            return false;
        }
        return true;

    });

    var clearForm = function() {
        $('#chat_message').val('');
    };
    var checkNonempty = function() {
        return $('#chat_message').val() != '';
    };
    $("#new_chat")
            .live("ajax:before", checkNonempty)
        //.bind("ajax:loading", toggleLoading)
            .live("ajax:complete", clearForm)
    //.bind("ajax:success", function(event, data, status, xhr) {
    //$("#content").html(data);
    //});
});