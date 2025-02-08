
document.addEventListener('turbo:load', () => {

  var dropdownElementList = [].slice.call(document.querySelectorAll('.dropdown-toggle'));
  var dropdownList = dropdownElementList.map(function (dropdownToggleEl) {
    return new bootstrap.Dropdown(dropdownToggleEl);
  });
  
  $(document).ready(function() {
      console.log('user_sessions/index.js is running');

  });
});
