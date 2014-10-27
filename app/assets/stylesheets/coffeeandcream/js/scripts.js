jQuery(document).ready(function ($) {


  setTimeout(hashScroll, 1300);

  $('.scroller').localScroll();
  $('.topper').scrollTo('html');
  function hashScroll(){ $.localScroll.hash(); }

  /* fader links */
  $('img.fader, .fader img')
    .css('opacity', .6)
    .on('mouseenter', function(){
    $(this).stop(true, true).fadeTo(800, 1);
  })
    .on('mouseleave', function(){
    $(this).stop(true, true).fadeTo(400, .6);
  });



  /* Parallax */
  if($('.parallax').length !== 0){
    $('.parallax').each(function (){

      var parallaxSpeed = $(this).attr('data-speed');

      $(this).parallax("50%", parallaxSpeed);
    });
  }


  //Swiper initialize

  function swiperSliderInit() {
    var device = $('body').attr('data-device');
    if(device === "phone" || device === 'tablet') {
      $('.swiper-container').css('display', 'block');
      $('.swiper-top').css('display', 'block');

      // var topSlide = $('.swiper-top').swiper({
      //   mode:'horizontal',
      //   visibilityFullFit: true,
      //   calculateHeight: true
      // });

      // Swiper init is not working with a common class hence
      // initing separately
      $('.swiper-container:eq(0)').swiper({
        mode:'horizontal',
        loop: true,
        visibilityFullFit: true,
        calculateHeight: true
      });

      $('.swiper-container:eq(1)').swiper({
        mode:'horizontal',
        loop: true,
        visibilityFullFit: true,
        calculateHeight: true
      });

    } else {
      $('.swiper-container').css('display', 'none');
      $('.swiper-top').css('display', 'none');
    }
  }




  //delaying events on window resize
  var waitForFinalEvent = (function () {
    var timers = {};
    return function (callback, ms, uniqueId) {
      if (!uniqueId) {
        uniqueId = "Don't call this twice without a uniqueId";
      }
      if (timers[uniqueId]) {
        clearTimeout (timers[uniqueId]);
      }
      timers[uniqueId] = setTimeout(callback, ms);
    };
  })();


  $(window).resize(function () {
    // waitForFinalEvent(function (){
      o_conditional_scripts();
      // swiperSliderInit();
    // }, 0, "conditionalscripts");
  });
  setTimeout(o_conditional_scripts, 5);


  // Flexslider
  if($('.flexslider').length !== 0){
    $('.flexslider').each(function (){
      var controlNav = $(this).data('controlnav');
      var directionNav = $(this).data('directionnav');
      var prevText = $(this).attr('data-prevtext');
      var nextText = $(this).attr('data-nexttext');
      var animationSpeed = $(this).data('animationspeed');
      var slideshow = $(this).data('slideshow');
      var slideshowSpeed = $(this).data('slideshowspeed');
      $(this).flexslider({
        controlNav: controlNav,
        slideshow: slideshow,
        directionNav: directionNav,
        slideshowSpeed: slideshowSpeed,
        animationSpeed: animationSpeed,
        pauseOnHover: true,
        prevText: prevText,
        nextText: nextText
      });
    });
  }


  //sticky nav
  var stickyHeader = $('#header').height();

  $(window).scroll(function(){

    var device = $('body').attr('data-device');
      if(device === 'computer'){

      do_sticky_nav(stickyHeader);

    }

  }).scroll();


  function do_sticky_nav(stickyHeader){

   /* var device = $('body').attr('data-device');
      if(device === 'computer'){

        if($('#header').hasClass('menu-mixed')){

          // adds the height of previous widgets
          //var heightbefore = 30;
          var heightbefore = 53;
          $('#header').prev('.o-widget').each(function(){
            heightbefore += $(this).height();
          });


        if( $(window).scrollTop() > heightbefore ) {
          $('#header').addClass('scrolled');
          $('body').css('margin-top', stickyHeader);
        } else {
          $('#header').removeClass('scrolled');
          $('body').css('margin-top', 0);
        }

      }else if($('#header').hasClass('menu-fixed')){

          $('body').css('margin-top', stickyHeader);

      }*/

      o_nav_height();
      $('ul.nav, div.nav > ul').o_dd_nav();

   /* }else{

        $('#header').removeClass('scrolled');
        $('body').css('margin-top', 0);


    }*/

  }

  function onDeviceRemoveElemnts() {
    var device = $('body').attr('data-device');
    if(device === "phone" || device === "tablet") {
      $('#o_revolution_widget-2, .desktop, .bottom-scroller, #mobilenavtrigger').css("display", "none");
    } else {
      $('#o_revolution_widget-2, .desktop, .bottom-scroller').css("display", "block");
    }
  }


  // splash widget : 100% height
  countsplash=0;
  $('.widget_o_splash_widget').each(function(){

    var $currentwidget = $(this);

    var windowheight = $(window).height();
      if(countsplash === 0){ var headerheight = $('#header').height(); } else { headerheight = 0; }
      countsplash++;
      if(!$('body').hasClass('computer')){ headerheight = 0; }
      var splashheight = windowheight - headerheight;

      $('.splash-container', this).css('height', splashheight + 'px');
      $('.text-middle', this).each(function(){
        var splaschontentheight = $(this).height();
        var splaschontentmargintop = (splashheight - splaschontentheight) / 2;
        $(this).css('top', splaschontentmargintop + 'px');
      });


      if($('body').hasClass('computer')){

        var video = $('>div', this).data('video');
        if(video){


          var $player = $('>div', this);
          $player.mb_YTPlayer();

          var $playstopbtn = $('.videoplay', this);

          $playstopbtn.click(function(e){
            e.preventDefault();

            if($(this).hasClass('currentlyplaying')){
              $('.glyphicons', this).removeClass('pause').addClass('play');
              $(this).toggleClass('currentlyplaying');
              $player.pauseYTP();
            }else{
              $('.glyphicons', this).removeClass('play').addClass('pause');
              $(this).toggleClass('currentlyplaying');
              $player.playYTP();
            }

          });


          if($('.scroller a', $currentwidget) !== 0){
            $('.scroller a', $currentwidget).click(function(e){

              e.preventDefault();

              $player.pauseYTP();
              if($playstopbtn.hasClass('currentlyplaying')){
                $playstopbtn.removeClass('currentlyplaying');
                $playstopbtn.find('.glyphicons').removeClass('pause').addClass('play');
              }

            });
          }
        }
      }
  });


  //ie CSS background cover fix
  if($('.iebgcover').length !== 0){
    $('.iebgcover').css({backgroundSize: "cover"});
  }

  //mobile nav
  if($('#sidr').length !== 0){

    $('#pagenav').removeClass('hidden');
    $('#sitenav, #mobilenav').hide();
    $('#menutrigger').sidr({side: 'right', speed: 0});
    $('#sidr a.navclose').click(function(e){ e.preventDefault(); $.sidr('close'); });
    $('#sidr ul li.scroller a').click(function(e) {
      e.preventDefault();
      $.sidr('close');

    });
  }

  /* scrollers */
  if($('.scroller a').length !== 0){

    $('.scroller a').each(function(){

      var originalpage = $(this).attr('rel');
      if(originalpage){

        var pageclass = 'page-id-' + originalpage;
        if(! $('body').hasClass(pageclass)){

          var href = $(this).attr('href');

          // fix the safari bug of loosing the hash after redirect.
          // dirty but efficient. Any better fix is welcome!
          if ( $.browser.webkit == false ) {

            href = '?p=' + originalpage + href;

          } else {

            var hash = href.replace('#', '');
            href = '?p=' + originalpage + '&hash=' + hash + href;

          }



          $(this).attr('href', href);

        }

      }


    });

  }


  // adding nav support for mobile devices
  $('.selectnav ul.nav, .selectnav div.nav > ul').o_mobile_nav();
  $('.cssnav ul.mobinav, .cssnav div.mobinav > ul').o_mobilecss_nav();


  //delaying events on window resize
  var waitForFinalEvent = (function () {
    var timers = {};
    return function (callback, ms, uniqueId) {
      if (!uniqueId) {
        uniqueId = "Don't call this twice without a uniqueId";
      }
      if (timers[uniqueId]) {
        clearTimeout (timers[uniqueId]);
      }
      timers[uniqueId] = setTimeout(callback, ms);
    };
  })();


  // top of page (show link)
  $(window).scroll(function () {
    var scrollPosition = $(window).scrollTop();
    var position = 300;

    if(scrollPosition >= position) {
      $('#scrolltop').fadeIn();
    } else {
      $('#scrolltop').fadeOut();
    }
  });



    //responsive slider
    /* more info on this slider here : http://responsiveslides.com/ */
    if($('.rslides').length !== 0){
      $(".rslides").each(function(){
        var auto = parseInt($(this).data('auto'));
        var timeout = parseInt($(this).data('timeout')) * 1000;
        $(this).responsiveSlides({
          auto: auto, // Boolean: Animate automatically, true or false
          timeout: timeout, // Integer: Time between slide transitions, in milliseconds
          speed: 800, // Integer: Speed of the transition, in milliseconds
          nav: false, // Boolean: Show navigation, true or false
          pager: true // Boolean: Show pager, true or false
        });
      });
    }


    // Isotope
  if($('.o-items-container').length !== 0){

    $('.o-items-container').addClass('no-transition');

    $.Isotope.prototype._getMasonryGutterColumns = function () {
        var gutter = this.options.masonry && this.options.masonry.gutterWidth || 0;
        containerWidth = this.element.width();

        this.masonry.columnWidth = this.options.masonry && this.options.masonry.columnWidth ||
        // or use the size of the first item
        this.$filteredAtoms.outerWidth(true) ||
        // if there's no items, use size of container
        containerWidth;

        this.masonry.columnWidth += gutter;

        this.masonry.cols = Math.floor((containerWidth + gutter) / this.masonry.columnWidth);
        this.masonry.cols = Math.max(this.masonry.cols, 1);
    };

    $.Isotope.prototype._masonryReset = function () {
        // layout-specific props
        this.masonry = {};
        // FIXME shouldn't have to call this again
        this._getMasonryGutterColumns();
        var i = this.masonry.cols;
        this.masonry.colYs = [];
        while (i--) {
            this.masonry.colYs.push(0);
        }
    };

    $.Isotope.prototype._masonryResizeChanged = function () {
        var prevSegments = this.masonry.cols;
        // update cols/rows
        this._getMasonryGutterColumns();
        // return if updated cols/rows is not equal to previous
        return (this.masonry.cols !== prevSegments);
    };



    $(window).smartresize(function (){

      if($('.isotope').length > 0){var waitingTime = 1; $('.isotope').removeClass('no-transition'); }else{var waitingTime = 500; }

      waitForFinalEvent(function (){

            $('.o-items-container').each(function (){

          var $container  = $(this);
          var $items    = $container.find('.o-item');

          $container.imagesLoaded(function (){

            var nbCols  = parseInt($container.attr('data-cols'));
            var maxCols = parseInt($('body').attr('data-maxcols'));

            if(nbCols > maxCols){ nbCols = maxCols; }

            var gutterWidth = parseInt($container.attr('data-gutters')) || 0;

            var columnWidth = ($container.width() - ((nbCols - 1)*gutterWidth)) / nbCols;

            $items.each(function (){
              var $this = $(this);
              var cols = $this.data('cols') || 1;

              if(cols > maxCols){cols = maxCols}


              boxWidth = (columnWidth * cols) - 1 ;

              $this[ 'css' ]({ width: boxWidth, 'height': 'auto' }, { queue: false });
              if($container.hasClass('o-gallery')){ $this[ 'css' ]({ 'margin-bottom': gutterWidth }, { queue: false }); }

            });


            $items.fadeIn();

            if($container.hasClass('format-grid')){
              $container.isotope({
                itemSelector : '.o-item',
                resizable: false,
                layoutMode: 'fitRows',
                masonry: {
                  columnWidth: columnWidth
                }
              });
            }else{
              $container.isotope({
                itemSelector : '.o-item',
                resizable: false,
                masonry: {
                  columnWidth: columnWidth,
                  gutterWidth: gutterWidth
                }
              });
              }




          });



          var id = $(this).attr('id');
          if($('[data-target="' + id + '"]').length != 0){

            var startfilter = $('[data-target="' + id + '"]').find('.active a').attr('data-filter');
            $('#' + id).isotope({ filter: startfilter });


          }

        });

      }, waitingTime, "isotope");

    }).smartresize();

  }



  // filter items when filter link is clicked
  $('.o-filters a').click(function (){
    var targetcontainerID = $(this).parent().parent().attr('data-target');
    $('.isotope').removeClass('no-transition');
    var $container = $(this).parent().parent();
    $container.find('li').removeClass('active');
      var selector = $(this).attr('data-filter');
      $('#' + targetcontainerID).isotope({ filter: selector });
      $(this).parent('li').addClass('active');
      return false;
  });

  //elastislides

  function resetSlides() {
    $('.o-carousel').each(function () {

      var displaycount = $('ul',this).data('count');
      var maxCols = parseInt($('body').attr('data-maxcols'));
      if(displaycount >= maxCols ){ minItems = maxCols; } else { minItems = displaycount; }
      var margin = $('li', this).css('marginRight');
      margin = parseInt(margin.replace('px',''));
      var carousel = $(this).find('.es-carousel');
      carousel.elastislide({
        minItems  : minItems,
        margin    : margin
      });

    });
  }

  $(".logoimage,.logolink").on("click", function(e){
    e.preventDefault();
    $(this).scrollTo( '0px', 0 );
  });


  $(document).on('submit', '.contact-form', function(event) {

    event.preventDefault();
    var sendemail = 1;



    $(this).find('input.mandatory,textarea.mandatory').each(function(){
      var fieldvalue = trim($(this).val());
      var errorfield = $(this).next('.error-message');

      if(fieldvalue == ''){
        $(this).addClass('error');
        errorfield.show();
        sendemail = 0;
      }else{
        if($(this).attr('name') == 'form-email'){
          var email_regex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
          if(!email_regex.test(fieldvalue)){
            $(this).addClass('error');
            errorfield.show();
            sendemail = 0;
          } else {
            $(this).removeClass('error');
            errorfield.hide();
          }
        } else {
          $(this).removeClass('error');
          errorfield.hide();
        }
      }

    });

    if($('#recaptcha_widget_div').length !== 0){
      //console.log('doing recaptcha validation');
      captchavalidation = validateCaptcha();

      if(captchavalidation){
        //console.log('captcha validation: success');
        $("#recaptcha .error-message").hide();
      }else{
        //console.log('captcha validation: error');
        $("#recaptcha .error-message").show();
        sendemail = 0;
      }
    }

    if(sendemail != 0){
      var form = $(this);
      var emailurl = $(this).attr('data-form-action');
      var confirmbox = $(this).find('.email-confirmation');
      var errorbox = $(this).find('.email-error');
      //console.log($(form).serialize());

      $.ajax({
        url: emailurl,
        data: $(form).serialize(),
        type: 'POST'
      })
      .done(function() {
        confirmbox.fadeIn(500).delay(5000).fadeOut(500);
        $('.contact-form input, .contact-form textarea').each(function(){
          $(this).val('');
        });
      })
      .fail(function() { errorbox.fadeIn(500).delay(5000).fadeOut(500); });
    }

  });


  // Pricing tables same height
  function o_pt_menu(){
    if($('.pt-with-menu').length !== 0){

      $('.pt-with-menu').each(function(){

        $('.pricingtable-head', this).o_equal_height();
        var priceheight = $('.pricingtable-price', this).o_equal_height();

        if($('.pricing-menu', this) !== 0){ $('.pricing-menu', this).css('margin-top', priceheight + 60 + 'px');  }

        for(i=1; i<=10; i++){
          if( $('.pricingtable-lines li:nth-child(' + i + ')', this ) !== 0 ){ $('.pricingtable-lines li:nth-child(' + i + ')', this ).o_equal_height(); }
        }

      });

    }
  }
  // Call to action button vertical centering
  function o_cta_btn(){
    if($('.leftorright').length !== 0){

      $('.leftorright').each(function(){
        $('.col', this).o_equal_height();
      });
    }
  }


  /* SHORTCODES */

  //tabs
  if($('.tabs').length !== 0){
    $('.tabs').each(function (){
      var tabdiv = $(this);
      var links = $('.tabstitle a', this);
      var contents = $('.tabscontent div', this);

      links.first().addClass('active');
      contents.first().show();

      links.each(function (i) {

        $(this).click(function (e){

          e.preventDefault();

          var target = tabdiv.find('.tabscontent div:eq('+i+')');
          tabdiv.find('.tabscontent div').hide();
          target.show();
          links.removeClass('active');
          $(this).addClass('active');

        });

      });

    });
  }

  //toggle
  if($('.toggle a.toggletitle').length !== 0){
    $('.toggle a.toggletitle').click(function (e){
      e.preventDefault();
      $('.glyphicons', this).toggleClass('circle_plus').toggleClass('circle_minus');
      $(this).next('.togglecontent').slideToggle(200,'easeInExpo');
    });
  }

  //accordion
  if($('.accordion').length!=0){
    $('.accordion').each(function (){

      var accordion = $(this);
      var links = $('a.accordiontoggler', this);

      /* open first accordion */
      links.first().next('.accordioncontent').show();
      links.first().find('.glyphicons').toggleClass('circle_plus').toggleClass('circle_minus');

      links.each(function (i) {

        $(this).click(function (e){

          e.preventDefault();

          var target = $(this).next('.accordioncontent');
          var opened = accordion.find('.accordioncontent:visible');

          if(!target.is(':visible')){
            opened.slideToggle(200,'easeInExpo');
            opened.prev('a.accordiontoggler').find('.glyphicons').toggleClass('circle_plus').toggleClass('circle_minus');
          }
          target.slideToggle(200,'easeInExpo');
          $('.glyphicons', this).toggleClass('circle_plus').toggleClass('circle_minus');


        });

      });

    });
  }



  /******** FUNCTIONS ********/


    //Google Recaptcha ajax validation
    function validateCaptcha()
      {

        ajaxvalidationurl = $('#recaptcha').data('ajaxurl');

          challengeField = $("input#recaptcha_challenge_field").val();
          responseField = $("input#recaptcha_response_field").val();

          var html = $.ajax({
            type: "POST",
            url: ajaxvalidationurl,
            data: { recaptcha_response_field: responseField, recaptcha_challenge_field: challengeField },
            async: false
          }).responseText;

          //console.log(html);

          if (html.replace(/^\s+|\s+$/, '') == "success")
          {
              return true;
          }
          else
          {
              Recaptcha.reload();
              return false;
          }
      }

    // Fix Nav Height regarding the logo height
    function o_nav_height(){

      $("#sitenav .nav > li a, #menutrigger").css('line-height', $('#logo').outerHeight() + 'px');
      $("#mobilenavtrigger").css('height',  $('#logo').outerHeight() + 'px');
      if($('.logobaseline').lenght !== 0){ $('.logobaseline').css('line-height', $('#logo').outerHeight());}

    }



    // trim function for fields parsing
    function trim (myString){return myString.replace(/^\s+/g,'').replace(/\s+$/g,'')}

    //direct scroll to an element from url hashtag
    function hashScroll(){

          if ( $.browser.webkit == false ) {

              var el = window.location.hash.substring(1); // the hash


          } else {

            var el = window.location.href.split("?hash=").pop();

          }

          var test = el.indexOf("#");

        if(test != -1) {
          var targetScroll = '#' + el;

          if($(targetScroll).length !== 0){

          var offset = -115;
          var documentBody = (($.browser.chrome)||($.browser.safari)) ? document.body : document.documentElement;
            $(documentBody).stop().animate({scrollTop: $(targetScroll).offset().top + offset}, 1000,'easeInExpo');

          }

         }
     }



    // Conditional Scripts loading
    function o_conditional_scripts() {


      $window = $(window);
      var device = $('body').attr('data-device');
      var newWidth = $(window).width();
      //alert(newWidth);
      var screenSize = '';

      if(newWidth <= 320){var newDevice = "phone"; var maxCols = 2;}
      else if(newWidth > 320 && newWidth <=480){var newDevice = "phone"; var maxCols = 3;}
      else if(newWidth > 480 && newWidth <=767){var newDevice = "tablet"; var maxCols = 3;}
      else if(newWidth > 767 && newWidth <980){var newDevice = "computer"; var maxCols = 4; var screenSize = 'smallscreen';}
      else if(newWidth >= 980 && newWidth <1200){var newDevice = "computer"; var maxCols = 6;}
      else if(newWidth >= 1200){var newDevice = "computer"; var maxCols = 6; var screenSize = 'widescreen';}

      $('body').removeClass('computer tablet phone smallscreen widescreen').addClass(newDevice).addClass(screenSize);
      $('body').attr('data-device', newDevice);
      $('body').attr('data-maxcols', maxCols);


      if($('.hoveractions').length > 0){ $('.hoveractions').o_hoveractions(); }

      if($('.o-carousel').length !== 0){
        resetSlides();
      }

      do_sticky_nav(stickyHeader);
      o_pt_menu();
      o_cta_btn();
      onDeviceRemoveElemnts();
      swiperSliderInit();

      //change from device

      if(device != newDevice){

        //scripts for computer only
        if(newDevice == 'computer'){


          if($('.lightbox').length > 0){

            $lbparam = $('#lightbox_params');

            var animation_speed = $lbparam.data('speed');
            var slideshow = $lbparam.data('slideshow'); if(slideshow  == 'no'){ slideshow = false;}
            var autoplay = $lbparam.data('autoplay'); if(autoplay  == 'no'){ autoplay = false;}else{ autoplay = true; }
            var theme = $lbparam.data('theme');
            var gallery = $lbparam.data('gallery'); if(gallery  == 'no'){ gallery = false;}else{ gallery = true; };
            var sharing = $lbparam.data('sharing');
            var tw = '<div class="twitter"><a href="http://twitter.com/share" class="twitter-share-button" data-count="none">Tweet</a><script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script></div>';
            var fb = '<div class="facebook"><iframe src="http://www.facebook.com/plugins/like.php?locale=en_US&href='+location.href+'&amp;layout=button_count&amp;show_faces=true&amp;width=500&amp;action=like&amp;font&amp;colorscheme=light&amp;height=23" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:500px; height:23px;" allowTransparency="true"></iframe></div>';
            if(sharing == 'none'){ var social_tools = false}
            else if(sharing == 'both'){ var social_tools = '<div class="pp_social">' + tw + fb + '</div>'}
            else if(sharing == 'twitter'){ var social_tools = '<div class="pp_social">' + tw + '</div>'}
            else if(sharing == 'facebook'){ var social_tools = '<div class="pp_social">' + fb + '</div>'}

            $('.lightbox:not(.iframe)').unbind("click").prettyPhoto(
              {
                animation_speed: animation_speed, /* fast/slow/normal */
                slideshow: slideshow, /* false OR interval time in ms */
                autoplay_slideshow: autoplay, /* true/false */
                opacity: 0.80, /* Value between 0 and 1 */
                deeplinking: false,
                theme: theme, /* pp_default / light_rounded / dark_rounded / light_square / dark_square / facebook */
                overlay_gallery: gallery, /* If set to true, a gallery will overlay the fullscreen image on mouse over */
                social_tools: social_tools /* html code or false to disable */
              }
            );
            //see http://www.no-margin-for-errors.com/projects/prettyphoto-jquery-lightbox-clone/documentation/ for more possible configs

            $('.lightbox.iframe').unbind("click").prettyPhoto(
              {
                animation_speed: animation_speed, /* fast/slow/normal */
                slideshow: slideshow, /* false OR interval time in ms */
                autoplay_slideshow: autoplay, /* true/false */
                opacity: 0.80, /* Value between 0 and 1 */
                deeplinking: false,
                theme: theme, /* pp_default / light_rounded / dark_rounded / light_square / dark_square / facebook */
                overlay_gallery: gallery, /* If set to true, a gallery will overlay the fullscreen image on mouse over */
                social_tools: social_tools, /* html code or false to disable */
                default_width: $window.width() * .7,
                default_height: $window.height() * .6
              }
            );
            //see http://www.no-margin-for-errors.com/projects/prettyphoto-jquery-lightbox-clone/documentation/ for more possible configs

          }

         //scripts for mobile only
        }else{

          if($('.lightbox').length > 0){

            $('.lightbox:not(.iframe)').unbind("click").photoSwipe();

            $lbparam = $('#lightbox_params');
            var animation_speed = $lbparam.data('speed');
            var slideshow = $lbparam.data('slideshow'); if(slideshow  == 'no'){ slideshow = false;}
            var autoplay = $lbparam.data('autoplay'); if(autoplay  == 'no'){ autoplay = false;}else{ autoplay = true; }
            var theme = $lbparam.data('theme');
            var gallery = $lbparam.data('gallery'); if(gallery  == 'no'){ gallery = false;}else{ gallery = true; };
            var sharing = $lbparam.data('sharing');
            var tw = '<div class="twitter"><a href="http://twitter.com/share" class="twitter-share-button" data-count="none">Tweet</a><script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script></div>';
            var fb = '<div class="facebook"><iframe src="http://www.facebook.com/plugins/like.php?locale=en_US&href='+location.href+'&amp;layout=button_count&amp;show_faces=true&amp;width=500&amp;action=like&amp;font&amp;colorscheme=light&amp;height=23" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:500px; height:23px;" allowTransparency="true"></iframe></div>';
            if(sharing == 'none'){ var social_tools = false}
            else if(sharing == 'both'){ var social_tools = '<div class="pp_social">' + tw + fb + '</div>'}
            else if(sharing == 'twitter'){ var social_tools = '<div class="pp_social">' + tw + '</div>'}
            else if(sharing == 'facebook'){ var social_tools = '<div class="pp_social">' + fb + '</div>'}

            $('.lightbox.iframe').unbind("click").prettyPhoto(
              {
                animation_speed: animation_speed, /* fast/slow/normal */
                slideshow: slideshow, /* false OR interval time in ms */
                autoplay_slideshow: autoplay, /* true/false */
                opacity: 0.80, /* Value between 0 and 1 */
                deeplinking: false,
                theme: theme, /* pp_default / light_rounded / dark_rounded / light_square / dark_square / facebook */
                overlay_gallery: gallery, /* If set to true, a gallery will overlay the fullscreen image on mouse over */
                social_tools: social_tools, /* html code or false to disable */
                default_width: $window.width() * .8,
                default_height: $window.height() * .8
              }
            );
            //see http://www.no-margin-for-errors.com/projects/prettyphoto-jquery-lightbox-clone/documentation/ for more possible configs


          }

        }

      }


    }







});



/******* OCHOLABS PLUGINS ********/

  // Give same height to a group of elements
  (function ($){

    $.fn.o_equal_height = function (options){

      options = $.extend({
        add : 0,
        remove : 0
      },options);

      var maxHeight = 0;

      this.each(function (){

        $(this).height('auto');
        var elementHeight = $(this).height();
        if(elementHeight > maxHeight) { maxHeight = elementHeight; }

      });

      $(this).height(maxHeight);
      return maxHeight;
    }

  })(jQuery);



  // Hover Effect
  (function ($){

    $.fn.o_hoveractions = function (){

      return this.each(function (){


        //adding the overlay + action links
        if(!$(this).hasClass('overlay-done')){

          //var group = $(this).data('group');
          var group = 'cnc';
          var zoomimg = $(this).data('zoomimg');
          var zoomvideo = $(this).data('zoomvideo')
          var zoomtitle = $(this).data('zoomtitle');
          var zoomi18n = $(this).data('zoomi18n');
          var readmorelink = $(this).data('readmorelink');
          var readmorei18n = $(this).data('readmorei18n');
          var readmorelinktarget = $(this).data('readmorelinktarget') || '_self';
          var thumbstyle = '';
          if($(this).hasClass('img-rounded')){thumbstyle = 'img-rounded'};
          if($(this).hasClass('img-circle')){thumbstyle = 'img-circle'};

          if(zoomimg || readmorelink || zoomvideo){

            var overlay = '<div class="overlay ' + thumbstyle + '" style=""><div class="actions">';

            if(zoomimg){
              overlay+= '<a href="' + zoomimg + '" class="lightbox" rel="prettyPhoto[' + group + ']" title="' + zoomtitle + '"><span class="glyphicons zoom_in" title="' + zoomi18n + '"><i></i></span></a>';
            }

            if(zoomvideo){
              overlay+= '<a href="' + zoomvideo + '" class="lightbox iframe" rel="prettyPhoto[' + group + ']"><span class="glyphicons play" title="' + zoomi18n + '"><i></i></span></a>';
            }

            if(readmorelink){
              overlay+= '<a href="' + readmorelink + '" target="' + readmorelinktarget + '" title="' + readmorei18n + '"><span class="glyphicons link"><i></i></span></a>';
            }

            overlay+= '</div></div>';

            $(this).append(overlay).find('.overlay').css('opacity',0);
            $(this).find('.actions').hide();
            $(this).addClass('overlay-done');

          }

        }

        if(zoomimg || readmorelink || zoomvideo){

          $(this).hover(
            function (){
              $('.actions', this).show();
              $('.overlay, .actions', this).height($('img', this).height()).width($('img', this).width());
              $('.overlay', this).css('opacity',0).stop().animate({'opacity':1}, 400, 'easeInOutCubic');
            },
            function (){
              $('.overlay', this).stop().animate({'opacity':0}, 200, 'easeInOutCubic' );
              $('.actions', this).hide();
            }
          );

        }



      });

    }

  })(jQuery);


  // Dropdown main navigation
  (function ($){

    $.fn.o_dd_nav = function (options){

      options = $.extend({
        //add : 0,
        //remove : 0
      },options);

      var $nav = $(this);

      this.each(function (){

        $('ul', $nav).each(function (){
          $(this).css({'top':$(this).parent().outerHeight(),'left':0});
        });

        $('ul ul', $nav).each(function (){
          $(this).css({'top':0,'left':180});
        });

        var $items = $('li', this);
        $items.unbind('hover').hover(
          function (){  $('>ul', this).stop(true, true).slideDown('100'); },
          function (){  $('>ul', this).stop(true, true).hide(); }
        );


      });

    }

  })(jQuery);

  // Mobile Navigation
  (function ($){

    $.fn.o_mobile_nav = function (options){

      options = $.extend({
        target : '#mobilenavselect',
        indent : '&mdash;'
      },options);

      return this.each(function (){

        var $mainNavigation = $(this);
        var $selectMenu = $(options.target);
        var navigationText = $selectMenu.attr('data-i18n');

        $selectMenu.append('<option value="#">' + navigationText +' </option>');

        // populating the mobile nav with primary nav items
        $mainNavigation.find(' > li').each(function () {

          var href = $(this).children('a').attr('href');
          var text = $(this).children('a').text();

          $selectMenu.append('<option value="'+href+'">' + text+'</option>');

          if ($(this).children('ul').length > 0) {
            $(this).children('ul').children('li').each(function () {

              var href2 = $(this).children('a').attr('href');
              var text2 = $(this).children('a').text();

              $selectMenu.append('<option value="'+href2+'">' + options.indent + ' '+text2+'</option>');

              if ($(this).children('ul').length > 0) {
                $(this).children('ul').children('li').each(function () {

                  var href3 = $(this).children('a').attr('href');
                  var text3 = $(this).children('a').text();

                  $selectMenu.append('<option value="'+href3+'">' + options.indent + options.indent + ' '+text3+'</option>');
                });
              }


            });
          }

        });

        // pre select current page
        var currentmenu = $mainNavigation.find('.current-menu-item a').attr('href');
        $selectMenu.find('option').each(function (){
          if($(this).attr('value') == currentmenu){ $(this).attr('selected','selected'); }
        });

        // change page location
        $selectMenu.change(function () {location = this.options[this.selectedIndex].value;});

      });

    }

  })(jQuery);


  // Mobile CSS Navigation (no select)
  (function ($){

    $.fn.o_mobilecss_nav = function (options){

      return this.each(function (){

        var $mobinav = $(this);
        $('li', $mobinav).has('ul').each(function(){
          $(this).addClass('ddmobinav');
          var $ddmobilink = '<a href="#" class="ddmobilink"><span class="glyphicons circle_plus"><i></i></span></a>';
          $(this).append($ddmobilink);
          var $subnav = $('>ul', this);
        });


        $('.ddmobilink').click(function(e){
          e.preventDefault();
          var $target = $(this).parent().find('>ul');
          $('.glyphicons', this).toggleClass('circle_plus').toggleClass('circle_minus');
          $target.slideToggle(300,'easeInExpo');
        });

        $('#mobilenavtrigger a').click(function(e){
          e.preventDefault();
          $('#mobilenav').slideToggle(400,'easeInExpo');
        });

        $("#mobilenavtrigger").css('height',  $('#logo').outerHeight() + 'px');

      });

    }

  })(jQuery);


/* **** extra plugins for smooth local scrolling *****/

/**
 * Copyright (c) 2007-2012 Ariel Flesler - aflesler(at)gmail(dot)com | http://flesler.blogspot.com
 * Dual licensed under MIT and GPL.
 * @author Ariel Flesler
 * @version 1.4.3.1
 */
;(function($){var h=$.scrollTo=function(a,b,c){$(window).scrollTo(a,b,c)};h.defaults={axis:'xy',duration:parseFloat($.fn.jquery)>=1.3?0:1,limit:true};h.window=function(a){return $(window)._scrollable()};$.fn._scrollable=function(){return this.map(function(){var a=this,isWin=!a.nodeName||$.inArray(a.nodeName.toLowerCase(),['iframe','#document','html','body'])!=-1;if(!isWin)return a;var b=(a.contentWindow||a).document||a.ownerDocument||a;return/webkit/i.test(navigator.userAgent)||b.compatMode=='BackCompat'?b.body:b.documentElement})};$.fn.scrollTo=function(e,f,g){if(typeof f=='object'){g=f;f=0}if(typeof g=='function')g={onAfter:g};if(e=='max')e=9e9;g=$.extend({},h.defaults,g);f=f||g.duration;g.queue=g.queue&&g.axis.length>1;if(g.queue)f/=2;g.offset=both(g.offset);g.over=both(g.over);return this._scrollable().each(function(){if(e==null)return;var d=this,$elem=$(d),targ=e,toff,attr={},win=$elem.is('html,body');switch(typeof targ){case'number':case'string':if(/^([+-]=)?\d+(\.\d+)?(px|%)?$/.test(targ)){targ=both(targ);break}targ=$(targ,this);if(!targ.length)return;case'object':if(targ.is||targ.style)toff=(targ=$(targ)).offset()}$.each(g.axis.split(''),function(i,a){var b=a=='x'?'Left':'Top',pos=b.toLowerCase(),key='scroll'+b,old=d[key],max=h.max(d,a);if(toff){attr[key]=toff[pos]+(win?0:old-$elem.offset()[pos]);if(g.margin){attr[key]-=parseInt(targ.css('margin'+b))||0;attr[key]-=parseInt(targ.css('border'+b+'Width'))||0}attr[key]+=g.offset[pos]||0;if($(targ).find('.icon-container').length!==0){attr[key]-=($(targ).find('.icon-container').outerHeight()/2)};if($('.menu-mixed').length!==0 || $('.menu-fixed').length!==0){attr[key]-=$('#header').height();}if(g.over[pos])attr[key]+=targ[a=='x'?'width':'height']()*g.over[pos]}else{var c=targ[pos];attr[key]=c.slice&&c.slice(-1)=='%'?parseFloat(c)/100*max:c}if(g.limit&&/^\d+$/.test(attr[key]))attr[key]=attr[key]<=0?0:Math.min(attr[key],max);if(!i&&g.queue){if(old!=attr[key])animate(g.onAfterFirst);delete attr[key]}});animate(g.onAfter);function animate(a){$elem.stop().animate(attr,f,g.easing,a&&function(){a.call(this,e,g)})}}).end()};h.max=function(a,b){var c=b=='x'?'Width':'Height',scroll='scroll'+c;if(!$(a).is('html,body'))return a[scroll]-$(a)[c.toLowerCase()]();var d='client'+c,html=a.ownerDocument.documentElement,body=a.ownerDocument.body;return Math.max(html[scroll],body[scroll])-Math.min(html[d],body[d])};function both(a){return typeof a=='object'?a:{top:a,left:a}}})(jQuery);
/**
 * jQuery.LocalScroll - Animated scrolling navigation, using anchors.
 * Copyright © 2007-2009 Ariel Flesler - aflesler(at)gmail(dot)com | http://flesler.blogspot.com
 * Dual licensed under MIT and GPL.
 * Date: 3/11/2009
 * @author Ariel Flesler
 * @version 1.2.7
 **/
;(function($){var l=location.href.replace(/#.*/,'');var g=$.localScroll=function(a){$('body').localScroll(a)};g.defaults={duration:1e3,axis:'y',event:'click',stop:true,target:window,reset:true};g.hash=function(a){if(location.hash){a=$.extend({},g.defaults,a);a.hash=false;if(a.reset){var e=a.duration;delete a.duration;$(a.target).scrollTo(0,a);a.duration=e}i(0,location,a)}};$.fn.localScroll=function(b){b=$.extend({},g.defaults,b);return b.lazy?this.bind(b.event,function(a){var e=$([a.target,a.target.parentNode]).filter(d)[0];if(e)i(a,e,b)}):this.find('a,area').filter(d).bind(b.event,function(a){i(a,this,b)}).end().end();function d(){return!!this.href&&!!this.hash&&this.href.replace(this.hash,'')==l&&(!b.filter||$(this).is(b.filter))}};function i(a,e,b){var d=e.hash.slice(1),f=document.getElementById(d)||document.getElementsByName(d)[0];if(!f)return;if(a)a.preventDefault();var h=$(b.target);if(b.lock&&h.is(':animated')||b.onBefore&&b.onBefore.call(b,a,f,h)===false)return;if(b.stop)h.stop(true);if(b.hash){var j=f.id==d?'id':'name',k=$('<a> </a>').attr(j,d).css({position:'absolute',top:$(window).scrollTop(),left:$(window).scrollLeft()});f[j]='';$('body').prepend(k);location=e.hash;k.remove();f[j]=d}h.scrollTo(f,b).trigger('notify.serialScroll',[f])}})(jQuery);

