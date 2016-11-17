$('.books.show').ready(function() {

  $(".comment-links a[data-method=delete]").on("ajax:success", function(evt, data, status, xhr){
    $(evt.target).parents('.comment').remove();
  });

  function setEvaluation(evaluation, url) {
    $('#evaluation').raty({
      size: 24,
      path: '/assets/',
      score: evaluation,
      starHalf: 'star-half-big.png',
      starOff: 'star-off-big.png',
      starOn: 'star-on-big.png',
      click: function(score, callback) {
        $.ajax({
          type: "POST",
          url: url,
          data: {
            evaluation: {
              value: score
            }
          }
        });
      }
    });
  }

  var averageBookEvaluation = document.querySelector('#average-book-evaluation').dataset.value;
  setAverageBookEvaluation(averageBookEvaluation);

  var dataEvaluation = document.querySelector('#evaluation').dataset;
  setEvaluation(dataEvaluation.value, dataEvaluation.url)
});
