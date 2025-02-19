$(document).ready(function () {
  var larguraViewport = $(window).width();
  let active = false

  function atualizarLarguraViewport() {
      larguraViewport = $(window).width();

      if (larguraViewport > 831) {
          $(".aside").css("left", "0")
          active = false
          $(".line1").removeClass("active")
          $(".line2").removeClass("active")
          $(".line3").removeClass("active")

          $(".navbar-options").css("display", "block")
          $(".actions-user").css("display", "none")
      } else {
          $(".aside").css("left", "-100vw")
          $(".navbar-options").css("display", "none")
          $(".actions-user").css("display", "flex")
      }
  }

  atualizarLarguraViewport();

  $(window).resize(function () {
      atualizarLarguraViewport();
      $(".line1").removeClass("active")
      $(".line2").removeClass("active")
      $(".line3").removeClass("active")
      active = false
  });

  $(".button").on('click', function () {
      if (active == false) {
          $(".line1").addClass("active")
          $(".line2").addClass("active")
          $(".line3").addClass("active")

          $(".aside").css("left", "0")
      } else {
          $(".line1").removeClass("active")
          $(".line2").removeClass("active")
          $(".line3").removeClass("active")

          $(".aside").css("left", "-100vw")
      }
      active = !active
  });
})

$(function() {
  $(".datetime").datetimepicker({})

  $('#images')
  .bind('cocoon:after-insert', function() {
    $(".date").datetimepicker({})
  })

  $('#nestable').nestable({})

  $('#image-sortable').nestable({
    maxDepth: 1
  })

  $('.nestable').on('change', function(){
    $.ajax({
      url: $(this).data('update-path'),
      type: 'POST',
      data:
        { nodes: $('.nestable').nestable('serialize') }
    })
  })

  $('.chosen-select').chosen(
    {no_results_text: "Oops, nenhum resultado encontrado!"}
  )

  $(":file").filestyle({
    classButton: "btn btn-default",
    buttonText: "Selecionar Arquivo",
    classInput: "form-control inline v-middle input-s"
  })

  $(".date").datetimepicker({
    format: 'DD/MM/YYYY',
    pickTime: false
  })

  $(".datetime").datetimepicker({
    format: 'DD/MM/YYYY hh:mm:ss',
    useSeconds: true,
  })

  if ($('.active').hasClass('item_menu')) {
    $('.active').parents('li').addClass('active')
  }

  $(".dropdown-toggle").click(function(){
    $(".dropdown-menu").slideToggle();
  });

  $("#phone_phone, #phone-field, #member_phone, #phone-field-number").inputmask("(99)[9]9999-9999").on("input", function () {
    var len = this.value.replace(/\D/g, '').length;
    $(this).inputmask(len > 10 ? "(99)[9]9999-9999" : "(99) 99999-9999");
  });
 
  $('[data-toggle="tooltip"]').tooltip();

  $('.simple-form button[type=submit].btn-primary').on('click', function (event) {  
    event.preventDefault();
    var el = $(this);
    el.prop('disabled', true);
    setTimeout(function(){el.prop('disabled', false); }, 3000);
  });  
  
  var options = {
    closeButton: true,
    debug: false,
    newestOnTop: false,
    progressBar: true,
    positionClass: "toast-top-center",
    preventDuplicates: true,
    onclick: null,
    showDuration: 300,
    hideDuration: 1000,
    timeOut: 3000,
    extendedTimeOut: 1000,
    showEasing: "swing",
    hideEasing: "linear",
    showMethod: "fadeIn",
    hideMethod: "fadeOut"
  }

  if($('.notice').text() !== "") 
    toastr.success($('.notice').text(), "Sucesso!", options);  

  if($('.alert').text() !== "") 
    toastr.error($('.alert').text(), "Falha!", options); 

  // Função para animar o realce
  function animateHighlight() {
    var sortedNumber = $('#sorted-number').data('sorted-number'); // Obtém o número sorteado
    var highlightColors = ['#ff0000', '#00ff00', '#0000ff', '#ffff00', '#ff00ff']; // Cores para realçar
    var currentIndex = 0;

    // Função para animar o realce de um número
    function highlightNumber(index) {
      $('.participant-number').eq(index).css('color', highlightColors[index % highlightColors.length]);
      if (index > 0) {
        $('.participant-number').eq(index - 1).css('color', ''); // Remove o realce do número anterior
      }
    }

    // Realiza a animação de realce
    var highlightInterval = setInterval(function() {
      highlightNumber(currentIndex);
      currentIndex++;

      // Se chegou ao final, para a animação
      if (currentIndex >= $('.participant-number').length) {
        clearInterval(highlightInterval);
        $('#sorted-number').text(sortedNumber).css('color', 'black'); // Define o número sorteado e realça em preto
      }

      // Se o número atual é o sorteado, para a animação
      if ($('.participant-number').eq(currentIndex - 1).text() == sortedNumber || sortedNumber === 'null') {
        clearInterval(highlightInterval);
        $('#sorted-number').text(sortedNumber).css('color', 'black'); // Define o número sorteado e realça em preto
      }
    }, 400); // Intervalo de 1 segundo entre os realces
  }

  // Chama a função para animar o realce
  animateHighlight(); 

  $('#search-member-btn').on('click', function(e) {
    e.preventDefault();
    var ticketNumber = $('#search_ticket_number').val();
    var lotteryId = $('#lottery_id').val();

    $.ajax({
      url: '/admin/members/search_by_ticket',
      type: 'POST',
      contentType: 'application/json',
      data: JSON.stringify({ ticket_number: ticketNumber, lottery_id: lotteryId }),
      headers: {
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
      },
      success: function(data) {
        if (data.success) {
          $('#lottery_winner').val(data.member);
          $('#member-info').html(`
          <div class="member-info-card">
            <h3>Informações do Membro</h3>
            <p><strong>Nome:</strong> ${data.member}</p>
            <p><strong>CPF:</strong> <span data-full-cpf="${data.cpf}" class="masked" id="cpf">'***.***.***-**'</span> <i class="olhoCpf fas fa-eye"></i></p>
            <p><strong>Telefone:</strong> <span data-full-phone="${data.phone}" class="masked" id="phone">'(**)*****-****'</span> <i class="olhoPhone fas fa-eye"></i></p>
            <p><strong>Email:</strong> <span data-full-email="${data.email}" class="masked" id="email">'***********@****.****'</span> <i class="olhoEmail fas fa-eye"></i></p>
          </div>
          `);
        } else {
          alert(data.message);
        }
      },
      error: function() {
        alert('Erro ao buscar o membro. Por favor, tente novamente.');
      }
    });
  });
 
  $('#member-info').on('click', '.olhoCpf', function() {
    var cpfElement = $('#cpf');
    if (cpfElement.hasClass('masked')) {
      // Se o CPF está mascarado, mostra o CPF completo
      cpfElement.text(cpfElement.data('full-cpf'));
      cpfElement.removeClass('masked');
      $(this).removeClass('fa-eye-slash').addClass('fa-eye');
    } else {
      // Se o CPF está visível, mascara o CPF
      cpfElement.data('full-cpf', cpfElement.text());
      cpfElement.text('***.***.***-**');
      cpfElement.addClass('masked');
      $(this).removeClass('fa-eye').addClass('fa-eye-slash');
    }
  });

  $('#member-info').on('click', '.olhoPhone', function() {
    var phoneElement = $('#phone');
    if (phoneElement.hasClass('masked')) {
      // Se o CPF está mascarado, mostra o CPF completo
      phoneElement.text(phoneElement.data('full-phone'));
      phoneElement.removeClass('masked');
      $(this).removeClass('fa-eye-slash').addClass('fa-eye');
    } else {
      // Se o CPF está visível, mascara o CPF
      phoneElement.data('full-phone', phoneElement.text());
      phoneElement.text('(**)*****-****');
      phoneElement.addClass('masked');
      $(this).removeClass('fa-eye').addClass('fa-eye-slash');
    }
  });

  $('#member-info').on('click', '.olhoEmail', function() {
    var emailElement = $('#email');
    if (emailElement.hasClass('masked')) {
      // Se o CPF está mascarado, mostra o CPF completo
      emailElement.text(emailElement.data('full-email'));
      emailElement.removeClass('masked');
      $(this).removeClass('fa-eye-slash').addClass('fa-eye');
    } else {
      // Se o CPF está visível, mascara o CPF
      emailElement.data('full-email', emailElement.text());
      emailElement.text('***********@****.****');
      emailElement.addClass('masked');
      $(this).removeClass('fa-eye').addClass('fa-eye-slash');
    }
  });
});
