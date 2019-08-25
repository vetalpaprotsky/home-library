// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require bootstrap-sprockets
//= require bootstrap-filestyle
//= require_tree ../../../vendor/assets/javascripts/bootstrap_select
//= require jquery.raty
//= require jquery-readyselector
//= require turbolinks
//= require_tree .

function setAverageBookEvaluation(evaluation) {
  $('#average-book-evaluation').raty({
    readOnly: true,
    path: '/raty/',
    score: evaluation
  });
}

function modifyChooseFileButton() {
  $('span.buttonText').first().remove()
  $('div.bootstrap-filestyle > input').first().attr('placeholder', 'jpg, jpeg, png')
}

function useMultipleOptionSelection() {
  $("select").mousedown(function(e){
    e.preventDefault();

    var select = this;
    var scroll = select.scrollTop;

    e.target.selected = !e.target.selected;

    setTimeout(function(){select.scrollTop = scroll;}, 0);

    $(select ).focus();
  }).mousemove(function(e){e.preventDefault()});
}
