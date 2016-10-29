$('.books.show').ready(function() {

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

  var dataAverageBookEvaluation = document.querySelector('#average-book-evaluation').dataset;
  setAverageBookEvaluation(dataAverageBookEvaluation.value);

  var dataEvaluation = document.querySelector('#evaluation').dataset;
  setEvaluation(dataEvaluation.value, dataEvaluation.url)
});
