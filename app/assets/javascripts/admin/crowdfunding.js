$(function(){
    $('.crowdfunding-mutil-infos li').sortable();

    $('.cf-category-li span').bind('click', function(){
        $('.cf-category-li span').attr('class', '');
        $(this).attr('class', 'color-blue');
        var target = '#cf-textarea-' + $(this).data('id');
        $('.has_many_container fieldset').hide();
        $(target).parents('fieldset.has_many_fields').show();
    })
});