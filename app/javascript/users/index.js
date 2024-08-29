document.addEventListener('turbo:load', () => {
  $(document).ready(function() {

    $( "button[id^='delete_btn_']" ).on( "click", function() {
      hint_modal_message    = "User ["+this.dataset.bgUsername+"] will be deleted, delete anyway?";
      delete_chose_user_url = this.dataset.bgUrl;
      $("#hint_modal_body_p").text(hint_modal_message);
      $("#hint_modal_confirm_a").attr("href", delete_chose_user_url);
    } );

  });
});