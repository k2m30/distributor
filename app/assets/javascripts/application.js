// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require_tree .
//= require jquery.ui.all
//= require best_in_place

function showSpin() {
    $('.row-fluid').hide();
    $('.spin').fadeIn("slow");
}

function hideSpin() {
    $('.row-fluid').show();
    $('.spin').hide();
}

$(document).ready(function () {
    $('.tooltip_cell').tooltip({container: 'body'});
    var spin = $('.spin');
    spin.hide();//css('background', '#444');
    $('.nav a:not(.no_spin)').on('click', showSpin);
    $('.tdfade').on('click', showSpin);
    $('.carousel').carousel({
        interval: 15000
    });
    $(window).bind("unload", function() {
        $('.spin').hide();
        $('.row-fluid').show();
    });


});

