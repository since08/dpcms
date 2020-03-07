$(function(){
    $(".fre_way input[type='radio']").bind('change', function(){
        var id = this.value;
        new_url = document.URL.replace(/\/\d+$/,'\/' + id);
        history.pushState(null,null,new_url);
        $.ajax({
            url: "/shop/freights/"+id+"/change_view",
            type: "POST"
        });
    });
});
