$(function(){
    $(".order_price_modified").bind('click', function(){
        $(".change_price").show();
        $(".order_price").hide();
        $(".order_price_modified").hide();
    });

    $(".order_button_cancel").bind('click', function(){
        $(".change_price").hide();
        $(".order_price").show();
        $(".order_price_modified").show();
        return false;
    });

    $(".update_order_address").bind('click', function(){
        $(".ticket_order_edit").show();
        $(".update_order_address").hide();
        $(".ticket_order").hide();
    });

    $(".order_ticket_button_cancel").bind('click', function(){
        $(".ticket_order_edit").hide();
        $(".update_order_address").show();
        $(".ticket_order").show();
        return false;
    });

    $(".order_audit .audit_failed").bind('click', function(){
        $(".order_audit_hidden").show();
        $(".order_audit").hide();
    });

    $(".order_audit_hidden .cancel_audit").bind('click', function(){
        $(".order_audit").show();
        $(".order_audit_hidden").hide();
        return false
    });

    $(".operation input[type='submit']").bind('click', function(){
        if(!$(".operation input[data-status]").data('status')){
            alert('用户尚未通过实名审核!');
            return false;
        }
    })
});