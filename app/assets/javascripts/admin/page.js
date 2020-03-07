$(function(){
    $('.btn-move-page').bind('click', function(){
        moveType = $(this).data('type');
        opts = moveType === 'bottom' ? $('body').height() : 0;
        console.log(opts);
        $("html, body").animate({
            scrollTop: opts
        }, 300);
        return false
    })
});
