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

    $.getJSON('/chat/' + chat_room_id + '?start=' + last_read_message_id + '&chat_room=' + chat_room_id, function(data) {
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
    $('#chat').html('<div id="message">' +
            '<form method="post" data-remote="true" action="/chat/" accept-charset="UTF-8">' +
            '<div style="margin: 0pt; padding: 0pt; display: inline;">' +
            '<input type="hidden" value="✓" name="utf8">' +
            '<input type="hidden" value="4KTOq0IrsFccDBBES95FGHDQhYyUV/Un4DcfqpxDxMA=" name="authenticity_token">' +
            '</div>' +
            '<textarea rows="4" name="chat[message]" id="_chat_new.6_message" cols="50"></textarea>' +
            '<input type="hidden" name="chat[room]" value="' + chat_room_id + '"/>' +
            '<input type="hidden" name="chat[name]" value="' + $("#name").val() + '"/>' +
            '<input type="submit" value="Post message"/>' +
            '</form></div>'
            );

    chat_updated_room_id = chat_room_id;
    interval = setInterval(update_chat, 5000);
}