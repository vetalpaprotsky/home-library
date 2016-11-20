$('.books.show').ready(function() {

  $(document).on('ajax:success', '.comment-links a[data-method=delete]', function(evt, data, status, xhr) {
    $(evt.target).parents('.comment').remove();
  });

  $(document).on('click', '.comment form a[data-cancel-comment-editing]', function(evt, data, status, xhr) {
    var form = $(evt.target).parents('form');

    form.siblings('.comment-section').show();
    form.remove();
  });

  var averageBookEvaluation = document.querySelector('#average-book-evaluation').dataset.value;
  setAverageBookEvaluation(averageBookEvaluation);

  var dataEvaluation = document.querySelector('#evaluation').dataset;
  setEvaluation(dataEvaluation.value, dataEvaluation.url);

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
