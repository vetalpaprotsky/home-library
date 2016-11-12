$('.books.index').ready(function() {

  locale = location.pathname.split("/")[1]

  switch (locale) {
  case "en":
      setEnLocaleForSelectpicker(jQuery);
      break;
  case "ru":
      setRuLocaleForSelectpicker(jQuery);
      break;
  case "ua":
      setUaLocaleForSelectpicker(jQuery);
      break;
  }

  $('.selectpicker').selectpicker();
  $('.selectpicker').on('change', function() {
    location = this.options[this.selectedIndex].value;
  });
});
