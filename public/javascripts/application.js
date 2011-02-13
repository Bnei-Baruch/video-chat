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