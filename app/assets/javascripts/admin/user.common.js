$(function(){
    $('.show_edit_user_info').bind('click', function(){
        var id = $(this).data('id');
        $.ajax({
            url: "/admin/users/"+id+"/user_profile",
            type: "GET"
        });
    })
});
