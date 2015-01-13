/*Onload:Dashboard*/
jQuery(function($){

    $.Claim({items: ['Track your team status and activity in efficient manner',
        'Generate & Download Status reports',
        'Get notified when team member updates status']
    });

    $('[data-toggle="tooltip"]').tooltip({
        template: '<div class="tooltip status-tootip"><div class="tooltip-arrow"></div><div class="tooltip-inner">Prashant Sahni</div></div>',
        title: function(){
            return statusHtml($(this).data("status"));
        }
    });

});


function statusHtml(data){
    
    if(data==null) return ;
    var yestarday = data.yesterday_plan,
        today = data.today_plan,
        tomorrow_plan = data.tomorrow_plan;

    var html =  "<h4>Yesterday</h4>" +
        yestarday +
        "<h4>Today</h4>" +
        today +
        "<h4>Tomorrow</h4>" +
        tomorrow_plan

    console.log(html);
    return html;

}
