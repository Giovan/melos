(function(b,r,a,n,c,h,_,s,d,k){if(!b[n]||!b[n]._q){for(;s<_.length;)c(h,_[s++]);d=r.createElement(a);d.async=1;d.src="https://cdn.branch.io/branch-v1.3.3.min.js";k=r.getElementsByTagName(a)[0];k.parentNode.insertBefore(d,k);b[n]=h}})(window,document,"script","branch",function(b,r){b[r]=function(){b._q.push([r,arguments])}},{_q:[],_v:1},"init data setIdentity logout track link sendSMS referrals credits redeem banner".split(" "),0);

branch.init('43114168957534881', function(err, data) {
  // callback to handle err or data
});

$(function() {
  branch.banner({
      icon: '/assets/icons/bible/200/' +  I18n.locale + '.png',
      title: I18n.t('download ad.title'),
      description: '',
      openAppButtonText: I18n.t('download ad.open'),         // Text to show on button if the user has the app installed
      downloadAppButtonText: I18n.t('download ad.download'), // Text to show on button if the user does not have the app installed
      iframe: false,                      // Show banner in an iframe, recomended to isolate Branch banner CSS
      showiOS: true,                     // Should the banner be shown on iOS devices?
      showAndroid: true,                 // Should the banner be shown on Android devices?
      showDesktop: true,                 // Should the banner be shown on desktop devices?
      disableHide: false,                // Should the user have the ability to hide the banner? (show's X on left side)
      forgetHide: true,                  // Should we remember or forget whether the user hid the banner?
      make_new_link: false               // Should the banner create a new link, even if a link already exists?
  }, {
      phone: '1234567890',
      tags: ['tag1', 'tag2'],
      feature: 'dashboard',
      stage: 'new user',
      type: 1,
      data: {
          referring_url: window.location.origin,
          '$desktop_url': 'http://bible.com/app',
          '$ios_url': 'https://itunes.apple.com/us/app/bible/id282935706',
          '$android_url': 'https://play.google.com/store/apps/details?id=com.sirma.mobile.bible.android&hl=en',
          '$og_app_id': '818055158234752',
          '$og_title': 'YouVersion - The Bible App',
          '$og_image_url': '//bible.com/assets/icons/bible/200/' + I18n.locale + '.png'
      }
  });
});
// branch.banner({
//   icon: '',
//   title: 'Youversion Bible App',
//   description: 'The Branch demo app!',
//   openAppButtonText: 'Open',         // Text to show on button if the user has the app installed
//   downloadAppButtonText: 'Download', // Text to show on button if the user does not have the app installed
//   iframe: true,                      // Show banner in an iframe, recomended to isolate Branch banner CSS
//   showiOS: true,                     // Should the banner be shown on iOS devices?
//   showAndroid: true,                 // Should the banner be shown on Android devices?
//   showDesktop: true,                 // Should the banner be shown on desktop devices?
//   disableHide: false,                // Should the user have the ability to hide the banner? (show's X on left side)
//   forgetHide: false,                 // Should we remember or forget whether the user hid the banner?
//   make_new_link: false      
// }, {

//   phone: '9999999999',
//   '$desktop_url': 'https://bible.com/'

// });