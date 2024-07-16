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

    $(".button-add-numbers").on('click', function () {
        var quantityInput = $('#quantity-sorteio');

        var value = parseInt(quantityInput.val());
        var maxValue = parseInt(quantityInput.attr('max'));
        var increment = parseInt($(this).attr('increment'));
        var decrement = parseInt($(this).attr('decrement'));

        if (increment && value < maxValue && (value + increment <= maxValue))
            $("#quantity-sorteio").val(value + increment);

        if (decrement && value > 0)
            $("#quantity-sorteio").val(value - decrement);
    })

    $(".button-clear-numbers").on('click', function () {
        $("#quantity-sorteio").val(0);
    })

    var timerInterval;
    var elapsedTime = 10 * 60; // Inicia em 10 minutos
    var maxTime = 0; // Termina em 0 segundos

    function formatTime(timeInSeconds) {
        var minutes = Math.floor((timeInSeconds % 3600) / 60);
        var seconds = timeInSeconds % 60;
        return (
            (minutes < 10 ? "0" : "") + minutes + ":" +
            (seconds < 10 ? "0" : "") + seconds
        );
    }

    function updateTimer() {
          elapsedTime--;
        $('#timer').text(formatTime(elapsedTime));

        if (elapsedTime <= maxTime) {
            clearInterval(timerInterval);
            window.location.href = "/";
            
        }
    }


    // Iniciar o cronômetro automaticamente
    timerInterval = setInterval(updateTimer, 1000);

    $("#openModal").click(function() {
        var quantityInput = $('#quantity-sorteio');

        if(quantityInput.val() > 0) {
            $("#myModal").css("display", "flex");
        } else {
            alert("Digite a quantidade de tickets")
        }
        
    }); 

    $("#openModalNumber").click(function() {
       $("#myModalNumber").css("display", "flex");    
    });

    $("#openModalContact").click(function() {
        $("#myModalContact").css("display", "flex");    
     });

    // Quando o usuário clicar no <span> (x), fecha o modal
    $(".close").click(function() {
        $("#myModal").css("display", "none");
        $("#myModalNumber").css("display", "none");
        $("#myModalContact").css("display", "none");
    });

    // Quando o usuário clicar em qualquer lugar fora do modal, fecha o modal
    $(window).click(function(event) {
        if ($(event.target).is("#myModal")) {
            $("#myModal").css("display", "none");
        }
    });

    $(window).click(function(event) {
        if ($(event.target).is("#myModalNumber")) {
            $("#myModalNumber").css("display", "none");
        }
    });

    $(window).click(function(event) {
        if ($(event.target).is("#myModalContact")) {
            $("#myModalContact").css("display", "none");
        }
    });

    $('#btn-copiar').click(function() {
        var inputValue = $('#copiar').val();
        copyToClipboard(inputValue);
    });
    
    function copyToClipboard(value) {
        var $temp = $("<input>");
        $("body").append($temp);
        $temp.val(value).select();
        document.execCommand("copy");
        $temp.remove();
        alert('Pix copiado para a área de transferência');
    }
})






$(function () {
    $(".datetime").datetimepicker({})

    $('#images')
        .bind('cocoon:after-insert', function () {
            $(".date").datetimepicker({})
        })

    $('#nestable').nestable({})

    $('#image-sortable').nestable({
        maxDepth: 1
    })

    $('.nestable').on('change', function () {
        $.ajax({
            url: $(this).data('update-path'),
            type: 'POST',
            data:
                { nodes: $('.nestable').nestable('serialize') }
        })
    })

    $('.chosen-select').chosen(
        { no_results_text: "Oops, nenhum resultado encontrado!" }
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

    $(".dropdown-toggle").click(function () {
        $(".dropdown-menu").slideToggle();
    });

    $("#phone_phone, #phone-field, #member_phone, #phone-field-number").inputmask("(99)[9]9999-9999").on("input", function () {
        var len = this.value.replace(/\D/g, '').length;
        $(this).inputmask(len > 10 ? "(99)[9]9999-9999" : "(99) 99999-9999");
    });

    $("#member_cpf").inputmask("999.999.999-99");

    // Evento focusout para ajuste, se necessário
    $("#member_cpf").on("input", function () {
        var len = this.value.replace(/\D/g, '').length;
        // Mantém a máscara padrão (999.999.999-99) independente do tamanho do CPF
        $(this).inputmask(len >= 11 ? "999.999.999-99" : "999.999.999-99");
    });
    
    $("#member_email").on("input", function() {
        let email = $(this).val();
        let isValid = validateEmail(email);

        if (email.trim() === '') {
            $('#emailMessage').text('').css('color', ''); // Limpa o texto e a cor se estiver vazio
            return; // Sai da função sem fazer mais nada
        }

        if (isValid) {
            $('#emailMessage').text('').css('color', '');
        } else {
            $("#emailMessage").text("E-mail inválido").css("color", "#e33244");
        }
    });   

    $('#member_cpf').on('input keyup', function() {
        var cpf = $(this).val().trim();
        var isValid = validateCPF(cpf);

        if (cpf.trim() === '') {
            $('#cpfMessage').text('').css('color', ''); // Limpa o texto e a cor se estiver vazio
            return; // Sai da função sem fazer mais nada
        }
        
        if (isValid) {
            $('#cpfMessage').text('').css('color', '');
        } else {
            $('#cpfMessage').text('CPF inválido').css('color', '#e33244');
        }
    });

    $('#member_phone').on('input keyup', function() {
        let telefone = $(this).val();

        if (telefone.trim() === '') {
            $('#phoneMessage').text('').css('color', ''); // Limpa o texto e a cor se estiver vazio
            return; // Sai da função sem fazer mais nada
        }

        let isValid = validatePhone(telefone);
        
        if (isValid) {
            $('#phoneMessage').text('').css('color', '');

        } else {
            $('#phoneMessage').text('Telefone inválido').css('color', '#e33244');
        }
    });

    function validatePhone(telefone) {
        // Remove todos os caracteres não numéricos, exceto o sinal de mais (+) que pode indicar um código internacional
        telefone = telefone.replace(/[^\d+]/g, '');

        // Verifica se o telefone possui 10 ou 11 dígitos
        if (telefone.length === 11) {
            return true;
        } else {
            return false;
        }
    }

    function validateCPF(cpf) {
        cpf = cpf.replace(/[^\d]+/g, ''); // Remove caracteres não numéricos

        if (cpf.length !== 11) return false;

        // Validação do primeiro dígito verificador
        var add = 0;
        for (var i = 0; i < 9; i++) {
            add += parseInt(cpf.charAt(i)) * (10 - i);
        }
        var rev = 11 - (add % 11);
        if (rev === 10 || rev === 11) rev = 0;
        if (rev !== parseInt(cpf.charAt(9))) return false;

        // Validação do segundo dígito verificador
        add = 0;
        for (var i = 0; i < 10; i++) {
            add += parseInt(cpf.charAt(i)) * (11 - i);
        }
        rev = 11 - (add % 11);
        if (rev === 10 || rev === 11) rev = 0;
        if (rev !== parseInt(cpf.charAt(10))) return false;

        return true;
    }
    
    function validateEmail(email) {
        // Expressão regular para validar email
        let regex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        return regex.test(email);
    }

    function checkFieldsValidity() {
        let telefone = $('#member_phone').val();
        let email = $('#member_email').val();
        let cpf = $('#member_cpf').val();

        let isValidPhone = validatePhone(telefone);
        let isValidEmail = validateEmail(email);
        let isValidCPF = validateCPF(cpf);

        // Verifica se todos os campos estão válidos
        if (isValidPhone && isValidEmail && isValidCPF) {
            $('#button-submit').prop('disabled', false); 
        } else {
            $('#button-submit').prop('disabled', true); 
        }
    }

        // Eventos de entrada para os campos
    $('#member_phone, #member_email, #member_cpf').on('input keyup', function() {
        checkFieldsValidity();
    });

    checkFieldsValidity();

    $('[data-toggle="tooltip"]').tooltip();

    $('.simple-form button[type=submit].btn-primary').on('click', function (event) {
        event.preventDefault();
        var el = $(this);
        el.prop('disabled', true);
        setTimeout(function () { el.prop('disabled', false); }, 3000);
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

    if ($('.notice').text() !== "")
        toastr.success($('.notice').text(), "Sucesso!", options);

    if ($('.alert').text() !== "")
        toastr.error($('.alert').text(), "Falha!", options);

    // Função para verificar o pagamento apenas quando estiver no endpoint desejado
    function checkPaymentAtEndpoint() {
        // Verifica se a URL atual corresponde ao endpoint desejado
        if (window.location.pathname === "/pagamento" || window.location.pathname === "/pagamento-membro") {
            // Chama a função de verificação de pagamento
            checkPayment();
        }
    }
    
    function checkPayment() {
        console.log("Verificando Pagamento");

        // Substitua 'payment_id' pelo ID real do pagamento que você deseja verificar
        const paymentId = document.getElementById("payment_id").value;

        // Faça uma solicitação AJAX para o seu servidor que consulta a API do Mercado Pago
        $.ajax({
            url: `/check_payment_public`,
            method: "GET",
            data: { payment_id: paymentId },
            success: function (data) {
                if (data.status) {
                    var paymentStatus = data.status
                    // paymentStatus = 'approved'
                    // Verifica se o pagamento foi aprovado
                    if (paymentStatus === 'approved') {
                        console.log("Pagamento aprovado");
                        const quantity = document.getElementById("quantity").value;
                        const lotteryId = document.getElementById("lottery_id").value;
                        const memberId = document.getElementById("member_id").value;
                        $.ajax({
                            url: 'comprar_public',
                            method: 'PUT',
                            data: { lottery_id: lotteryId, quantity: quantity, member_id: memberId, transaction_id: paymentId },
                            success: function (data) {
                                console.log(data);
                                if (data.numbers) {
                                window.location.href = `/numeros-selecionados?numbers=${data.numbers}&member_id=sdfwerwersfsfwerwrq423no2noino2o34iow2n3o42n3o3io24n2o3i4no12i3no23i4n2oi4wperípí24poipiepwoirpweipsdfipoipip23i4pipweirp2oi34p2ipfpsdspfowpnhfpnfsdfnslkjlq43bl4b23l4n&yek=${memberId}+"&qpwoeiqpoieqpeipqoweiqpoweiqpwoeiqpwoqie=1231l23nlnlknlandqlwneqlwenqjnlkjnfkabkqbkqhwbekqwbeqkwhe=&yeekkqieo=123013012ljnlajsndiqwe&timestamp="${data.timestamp}`;
                                }else{
                                    window.location.href = `/numeros-esgotados?transaction=${paymentId}` 
                                }
                            }
                            
                        });
                        
                    } else {
                        console.log("Status do pagamento: " + paymentStatus);
                    }
                } else {
                    console.error("Não foi possível obter o status do pagamento");
                }
            },
            error: function (error) {
                console.error("Erro ao verificar o pagamento:", error);
            }
        });
    }

    
    setInterval(checkPaymentAtEndpoint, 10000);

});
