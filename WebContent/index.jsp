<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Organograma</title>

	<!-- Bootstrap -->
	<link rel="stylesheet"
		href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
	<script
		src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
	<script
		src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	<!-- CSS -->
	<link rel="stylesheet" type="text/css" href="organograma.css">

	<script>
		//Funcao que extrai dados de elementos span do html para exibi-los no Modal
		function pegaDados(parentElement) {
			var span = parentElement.getElementsByTagName("span");
			var titulo = "";
			
			//Validação para colocar título correto no caso da prefeitura
			if(span[0].getAttribute("data-orgao")=="Prefeitura") titulo = "<span style = \"font-size:1.25em\"><strong>"
			+ span[0].getAttribute("data-orgao")+" de "+span[0].getAttribute("data-setor")+"</strong></span>";
			else titulo = "<span style = \"font-size:1.25em\"><strong>"
				+ span[0].getAttribute("data-setor")+"</strong></span>";
				
			var texto="";
			var rodape = "";
			var nome, cargo, admissao, exoneracao, endereco, telefone, cep, email, site;
			
			for(var i = 0;i < span.length; i++) {
				nome = span[i].getAttribute("data-nome");
				cargo = span[i].getAttribute("data-cargo");
				admissao = span[i].getAttribute("data-admissao");
				exoneracao = span[i].getAttribute("data-exoneracao");
				
				//Se o dado extraido do span nao for nulo, ele eh acrescentado a variavel que armazena o texto
				if(nome) texto += "<span style = \"font-size:1.3em\">"+ nome + "</span><br />";
				
				/*Faz com que os cargos aparecem também com feminino
				Nada acontece no caso de Prefeito pois atualmnte eh um homem*/
				if(cargo){
					if(cargo == "Prefeito") ;
					else if(cargo == "Vice-Prefeito") cargo = "Vice-Prefeita";
					else if(cargo == "Secretário Adjunto") cargo = "Secretário(a) Adjunto(a)";	
					else if(cargo == "Controlador Geral Adjunto") cargo = "Controlador(a) Geral Adjunto(a)";
					else if(cargo == "Controlador Geral") cargo = "Controlador(a) Geral";
					else if(cargo == "Procurador Geral Adjunto") cargo = "Procurador(a) Geral Adjunto(a)";
					else if(cargo == "Procurador Geral") cargo = "Procurador(a) Geral";
					else if(cargo != "Chefe de Gabinete") cargo += "(a)";
				}
				
				if(cargo) texto += "<span style = \"font-size:1.1em\"><strong>" + cargo + "</strong></span><br />";
				
				//Verifica casos de substituicao para mostrar o periodo da mesma em caso positivo
				if(nome){
					if(nome.indexOf('*') != -1){
						if(admissao && exoneracao)texto += "<p>Período de substituição: " + admissao + " - " + exoneracao + "</p>";
					}
					else{
						if(admissao) texto += "<p>Admissão em: " + admissao + "</p>";
					}
				}
				//Para melhorar a estetica
				if((span[0].getAttribute("data-orgao") != "Prefeitura") && (i != span.length-1)) texto += "<br />";
			}
			
			endereco = span[span.length - 1].getAttribute("data-end");
			cep = span[span.length - 1].getAttribute("data-cep");
			telefone = span[span.length - 1].getAttribute("data-tel");
			email  = span[span.length - 1].getAttribute("data-email");
			site  = span[span.length - 1].getAttribute("data-site");
			
			//Se o dado nao for nulo eh acrescentada a variavel rodape na qual existem informacoes adicionais
			if(email) rodape += "<a class=\"nostyle\" style = \"font-size:0.8em\" href=\"mailto:" + email + "\">" + email + "</a> - ";
			if(site) rodape += "<a class=\"nostyle\" style = \"font-size:0.8em\" href=\"" + site + "\" target=\"_blank\">" + site + "</a><br />";
			if(endereco) rodape += "<span style = \"font-size:0.8em\">" + endereco + "</span><br />";
			if(cep) rodape += "<span style = \"font-size:0.8em\">CEP: " + cep;
			if(telefone) rodape += " - Telefone: " + telefone + "</span>";
			rodape += "<br />";
			rodape += "<span style = \"font-size:0.74em\">* funcionários que estão substituindo o responsável pelo cargo</span>";

			//Insere o conteudo no Modal
			document.getElementById('myModalLabel').innerHTML = titulo;
			document.getElementById('modalBody').innerHTML = texto;
			document.getElementById('modalFooter').innerHTML = rodape;
		}
		
		//Pega infos da barra de busca
		function pegaDadosForm(){
			var busca = document.getElementById('busca').value;
			var opcoes = document.getElementById('opcoes').value;
			var re = new RegExp(busca, 'gi');
			
			var span = document.getElementsByTagName("span");
			
			for(var i = 0; i < span.length; i++) {
				orgao = span[i].getAttribute("data-orgao");
				setor = span[i].getAttribute("data-setor");
				nome = span[i].getAttribute("data-nome");
				id = span[i].getAttribute("data-id");
				
				switch(opcoes){
					case '1':
						console.log("Busca: "+busca);
						if(nome!=null && busca != ""){
							if(nome.match(re) != null && setor != null){
								if (orgao=="Prefeitura") document.getElementById(id).focus();
								else document.getElementById(setor).focus();
							}
						}
						break;
						
					case '2':
						if(orgao=="Secretaria" && setor!=null && busca != ""){
							if(setor.match(re) != null){
								document.getElementById(setor).focus();
							}
						}
						break;
					
					case '3':
						if(orgao=="Subprefeitura" && setor!=null && busca != ""){
							if(setor.match(re) != null){
								document.getElementById(setor).focus();
							}
						}
						break;
				}

			}
			document.getElementById('busca').value = "";
		}		
	</script>

	<script>
		$(document).ready(function(){
			//Mostra e esconde a barra de buscas
			$("#lupa").click(function(){
		        $("#lupa").hide();
		        $("div#barra").removeClass("hidden");
		        $("#barra").show();
		    });
		    $("#x").click(function(){
		        $("#barra").hide();
		        $("#lupa").show();
		    });
		    
		});
	</script>
	

</head>
<body>
	<jsp:useBean id="bd" class="dao.FuncionarioDAO" />
	<jsp:useBean id="setor" class="dao.SetorDAO" />

	<!-- Botao para download do CSV -->
	<div class="navbar-form navbar-right">
		<form action="CSV">
			<!-- <input class="btn btn-default" type="submit" value="Download CSV"> -->
			<button type="submit" class="btn btn-default" aria-label="Right Align" style="float:right; margin-right:15px; margin-left:-15px;" 
			data-toggle="tooltip" data-placement="bottom" title="Download Organograma">
			  <span class="glyphicon glyphicon-download-alt" aria-hidden="true"></span>
		</button>
		</form>
	</div>
	<!-- Botao Lupa -->
	<div class="navbar-form navbar-right">
		<button id="lupa" type="button" class="btn btn-default" aria-label="Right Align" style="float:right" 
		data-toggle="tooltip" data-placement="bottom" title="Busca">
			  <span class="glyphicon glyphicon-search" aria-hidden="true"></span>
		</button>
	</div>
	<!-- Barra de Busca que aparece ao clicar no botao Lupa -->
	<div id="barra" class="hidden" style="float:right; margin-right:-15px;">
		<form class="navbar-form navbar-right" role="search" >
		  <!-- Opcoes de busca -->		     
	      <select class="form-control" id="opcoes">
	        <option value="1">Nome</option>
	        <option value="2">Secretaria</option>
	        <option value="3">Subprefeitura</option>	   
	      </select>
	      <!-- Insercao do conteudo da busca -->
		  <div class="form-group" >
		  <input id="busca" name="busca" type="text" class="form-control" placeholder="Busca" style="">
		  <!--<select class="form-control" id="busca">
		  	<option value="">-- select one -- </option>
	      </select> -->
		  </div> 
		  <!-- Fecha a barra de busca -->
		  <button id="x" type="button" class="btn btn-default" aria-label="Right Align" style="float:right">
		  	<span class="glyphicon glyphicon-remove" aria-hidden="true"></span>
		  </button>		 
		  <!-- Lupa para busca -->
		  <button class="btn btn-default" aria-label="Right Align" style="float:right" onclick="pegaDadosForm();return false;">
		  	<span class="glyphicon glyphicon-search" aria-hidden="true"></span>
		  </button>
		</form>
	</div><br /><br /><br />
	
	<!-- Cabecalho com imagens -->
	<div class="container">	
		<div class="col-xs-2 col-sm-2 col-md-2">
			<a class="nostyle" href="http://www.capital.sp.gov.br/portal/" target="_blank"><img src="imagens/BrasaoSaoPaulo.png" alt="" height="60em"
				style="float: right; padding-right: 2em; margin-top: 1.8em" /></a>
		</div>
		<div class="col-xs-8 col-sm-8 col-md-8">
			<h1 style="text-align: center;margin-top:0.7em">Organograma Prefeitura de São Paulo</h1>
		</div>
		<div class="col-xs-2 col-sm-2 col-md-2">
			<a class="nostyle" href="https://www.facebook.com/labprodam/" target="_blank"><img src="imagens/logoProdam.png" alt="" 
			height="60em" style="float: left; margin-top: 1.6em" /></a>
		</div>
		<br />
	</div>

	<!-- Inicio da estrutura do organograma -->
	<div class="content"><br /><br />
		<!--
		Copyright (c) 2016 by Ronny Siikaluoma (http://codepen.io/siiron/pen/aLkdE)
		Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation 
		files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, 
		modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software 
		is furnished to do so, subject to the following conditions:
		The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
		OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
		BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT
		OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
		-->
		<figure class="org-chart cf">
			<ul class="administration">
				<li>
					<ul class="director">
						<li>
							<!-- Busca infos de Prefeito no BD -->
							<c:forEach	var="funcionario" items="${bd.buscaCargo(\"Prefeito\", \"Prefeitura\")}">
								<!-- Chamada da funcao que pega dados para coloca-los no Modal -->
								<a id="${funcionario.id}" href="" onclick="pegaDados(this);" data-toggle="modal"	data-target="#myModal">
								<!-- Span contem os dados que sao tratados na funcao pegaDados() e exibe dados do Prefeito  -->
									<span data-id="${funcionario.id}"
									data-orgao="${funcionario.orgao}"
									data-setor="${funcionario.setor}"
									data-nome="${funcionario.nome}"
									data-cargo="${funcionario.cargo}"
									data-admissao="${funcionario.admissao}"
									data-exoneracao="${funcionario.exoneracao}">
										<p>${funcionario.nome}</p>
										<p>${funcionario.cargo}</p>
										<p>${funcionario.orgao}</p>
										<p>${funcionario.setor}</p>
									</span>
									<!-- Busca infos que serao exibidas no rodape do Modal -->
									<c:forEach var="set" items="${setor.buscaSetor(funcionario.orgao, funcionario.setor)}">
											<span data-end="${set.endereco}" data-cep="${set.cep}" data-tel="${set.telefone}"
												data-email="${set.email}" data-site="${set.site}"></span>
									</c:forEach>
								</a>
							</c:forEach>
							<ul class="subdirector">
								<li>
									<!-- Busca infos de Chefe de Gabinete da Prefeitura no BD -->
									<c:forEach var="funcionario" items="${bd.buscaCargo(\"Chefe de Gabinete\", \"Prefeitura\")}">
										<!-- Chamada da funcao que pega dados para coloca-los no Modal -->
										<a id="${funcionario.id}" href="" onclick="pegaDados(this);" data-toggle="modal" data-target="#myModal">
										<!-- Span contem os dados que sao tratados na funcao pegaDados() e exibe dados do Chefe de Gabinete  -->
											<span data-id="${funcionario.id}"
											data-orgao="${funcionario.orgao}"
											data-setor="${funcionario.setor}"
											data-nome="${funcionario.nome}"
											data-cargo="${funcionario.cargo}"
											data-admissao="${funcionario.admissao}"
											data-exoneracao="${funcionario.exoneracao}">
												<p>${funcionario.nome}<br /> ${funcionario.cargo}<br />
													${funcionario.orgao}<br /> ${funcionario.setor}
												</p>
											</span>
											<!-- Busca infos que serao exibidas no rodape do Modal -->
											<c:forEach var="set" items="${setor.buscaSetor(funcionario.orgao, funcionario.setor)}">
												<span data-end="${set.endereco}" data-cep="${set.cep}" data-tel="${set.telefone}"
													data-email="${set.email}" data-site="${set.site}"></span>
											</c:forEach>
										</a>
									</c:forEach>
								</li>
							</ul>
							<ul class="departments cf">
								<li>
									<!-- Busca infos de Vice-Prefeito no BD --> <c:forEach
										var="funcionario" items="${bd.buscaCargo(\"Vice-Prefeito\", \"Prefeitura\")}">
										<!-- Chamada da funcao que pega dados para coloca-los no Modal -->
										<a id="${funcionario.id}" href="" onclick="pegaDados(this);" data-toggle="modal" data-target="#myModal">
											<!-- Span contem os dados que sao tratados na funcao pegaDados() e exibe dados do Vice-Prefeito  -->
											<span data-id="${funcionario.id}"
											data-orgao="${funcionario.orgao}"
											data-setor="${funcionario.setor}"
											data-nome="${funcionario.nome}"
											data-cargo="${funcionario.cargo}"
											data-admissao="${funcionario.admissao}"
											data-exoneracao="${funcionario.exoneracao}">
											<!-- Caso o Vice-Prefeito seja homem, substituir Vice-Prefeita por ${funcionario.cargo} -->
												<p>${funcionario.nome}<br /> Vice-Prefeita<br />
													${funcionario.orgao}<br /> ${funcionario.setor}
												</p>
											</span>
											<!-- Busca infos que serao exibidas no rodape do Modal -->
											<c:forEach var="set" items="${setor.buscaSetor(funcionario.orgao, funcionario.setor)}">
												<span data-end="Viaduto do Chá, 15 - 6º andar - Edifício Matarazzo - Centro - São Paulo - SP" data-cep="${set.cep}" data-tel="${set.telefone}"
													data-email="${set.email}" data-site="${set.site}"></span>
											</c:forEach>
										</a>
									</c:forEach>
								</li>
								<li class="department dep-a">
									<a>
									<!-- Menu indicando cores dos cargos das Secretarias -->
										<span class="spon"> Secretarias <br />
											<container>
											<div style="background-color: #3b9187" class="legendas div-left">
												<p class="div-right">Secretário(a)</p>
											</div>
											<br />
											<div style="background-color: #80cbc2" class="legendas div-left">
												<p class="div-right">Secretário(a) Adjunto(a)</p>
											</div>
											<br />
											<div style="background-color: #c9e8e5" class="legendas div-left">
												<p class="div-right">Chefe de Gabinete</p>
											</div>
											</container>
										</span>
									</a>
									<ul class="sections">
										<!-- Busca infos da Controladoria no BD -->
										<c:forEach var="funcionario" items="${bd.buscaCargo(\"Controlador Geral\", \"Controladoria\")}">
											<li class="section">
												<!-- Chamada da funcao que pega dados para coloca-los no Modal -->
												<a id="${funcionario.setor}" href="" onclick="pegaDados(this);" data-toggle="modal" data-target="#myModal">
													<!-- Span contem os dados que sao tratados na funcao pegaDados() e exibe dados Secretarios -->
													<!-- Cabecalho das caixinhas das Secretarias -->
													<span class="spon" data-orgao="${funcionario.orgao}" data-setor="${funcionario.setor}">
														<p>${funcionario.setor}</p>
														<br />
													</span> 
													<span data-id="${funcionario.id}"
													data-setor="${funcionario.setor}"
													data-nome="${funcionario.nome}"
													data-cargo="${funcionario.cargo}"
													data-admissao="${funcionario.admissao}"
													data-exoneracao="${funcionario.exoneracao}"
													style="background-color: #3b9187" class="spon">
														${funcionario.nome}<br />
													</span>
													<br />
													<!-- Busca infos dos Secretarios Adjuntos de cada Secretaria no BD -->
													<c:forEach var="funcionario2" items="${bd.buscaSetor(\"Controlador Geral Adjunto\", funcionario.orgao, funcionario.setor)}">
														<!-- Span contem os dados que sao tratados na funcao pegaDados() e exibe dados dos Secretarios Adjuntos  -->
														<span id="${funcionario.id}" 
														data-id="${funcionario.id}"
														data-setor="${funcionario.setor}"
														data-nome="${funcionario2.nome}"
															data-cargo="${funcionario2.cargo}"
															data-admissao="${funcionario2.admissao}"
															data-exoneracao="${funcionario2.exoneracao}"
															style="background-color: #80cbc2" class="spon">
															${funcionario2.nome}<br />
														</span>
														<br />
														<!-- Busca infos dos Chefe de Gabinete de cada Secretaria no BD -->
														<c:forEach var="funcionario3" items="${bd.buscaSetor(\"Chefe de Gabinete\", funcionario.orgao, funcionario.setor)}">
															<span id="${funcionario.id}" 
																data-id="${funcionario.id}"
																data-setor="${funcionario.setor}"
																data-nome="${funcionario3.nome}"
																data-cargo="${funcionario3.cargo}"
																data-admissao="${funcionario3.admissao}"
																data-exoneracao="${funcionario3.exoneracao}"
																style="background-color: #c9e8e5" class="spon">
																${funcionario3.nome}<br />
															</span>
														</c:forEach>
													</c:forEach>
													<!-- Busca infos que serao exibidas no rodape do Modal -->
													<c:forEach var="set" items="${setor.buscaSetor(funcionario.orgao, funcionario.setor)}">
														<span data-end="${set.endereco}" data-cep="${set.cep}"
															data-tel="${set.telefone}" data-email="${set.email}"
															data-site="${set.site}"></span>
													</c:forEach>
												</a>
											</li>
										</c:forEach>
										<!-- Busca infos da Procuradoria no BD -->
										<c:forEach var="funcionario" items="${bd.buscaCargo(\"Procurador Geral\", \"Procuradoria\")}">
											<li class="section">
												<!-- Chamada da funcao que pega dados para coloca-los no Modal -->
												<a id="${funcionario.setor}" href="" onclick="pegaDados(this);" data-toggle="modal" data-target="#myModal">
													<!-- Span contem os dados que sao tratados na funcao pegaDados() e exibe dados Secretarios -->
													<!-- Cabecalho das caixinhas das Secretarias -->
													<span class="spon" data-orgao="${funcionario.orgao}" data-setor="${funcionario.setor}">
														<p>${funcionario.setor}</p>
														<br />
													</span> 
													<span data-setor="${funcionario.setor}"
													data-nome="${funcionario.nome}"
													data-cargo="${funcionario.cargo}"
													data-admissao="${funcionario.admissao}"
													data-exoneracao="${funcionario.exoneracao}"
													style="background-color: #3b9187" class="spon">
														${funcionario.nome}<br />
													</span>
													<br />
													<!-- Busca infos dos Secretarios Adjuntos de cada Secretaria no BD -->
													<c:forEach var="funcionario2" items="${bd.buscaSetor(\"Procurador Geral Adjunto\", funcionario.orgao, funcionario.setor)}">
														<!-- Span contem os dados que sao tratados na funcao pegaDados() e exibe dados dos Secretarios Adjuntos  -->
														<span data-setor="${funcionario.setor}"
															data-nome="${funcionario2.nome}"
															data-cargo="${funcionario2.cargo}"
															data-admissao="${funcionario2.admissao}"
															data-exoneracao="${funcionario2.exoneracao}"
															style="background-color: #80cbc2" class="spon">
															${funcionario2.nome}<br />
														</span>
														<br />
														<!-- Busca infos dos Chefe de Gabinete de cada Secretaria no BD -->
														<c:forEach var="funcionario3" items="${bd.buscaSetor(\"Chefe de Gabinete\", funcionario.orgao, funcionario.setor)}">
															<span data-setor="${funcionario.setor}"
																data-nome="${funcionario3.nome}"
																data-cargo="${funcionario3.cargo}"
																data-admissao="${funcionario3.admissao}"
																data-exoneracao="${funcionario3.exoneracao}"
																style="background-color: #c9e8e5" class="spon">
																${funcionario3.nome}<br />
															</span>
														</c:forEach>
													</c:forEach>
													<!-- Busca infos que serao exibidas no rodape do Modal -->
													<c:forEach var="set" items="${setor.buscaSetor(funcionario.orgao, funcionario.setor)}">
														<span data-end="${set.endereco}" data-cep="${set.cep}"
															data-tel="${set.telefone}" data-email="${set.email}"
															data-site="${set.site}"></span>
													</c:forEach>
												</a>
											</li>
										</c:forEach>
										<!-- Busca infos dos Secretarios no BD -->
										<c:forEach var="funcionario" items="${bd.buscaCargo(\"Secretário\", \"Secretaria\")}">
											<li class="section">
												<!-- Chamada da funcao que pega dados para coloca-los no Modal -->
												<a id="${funcionario.setor}"  href="" onclick="pegaDados(this);" data-toggle="modal" data-target="#myModal">
													<!-- Span contem os dados que sao tratados na funcao pegaDados() e exibe dados Secretarios -->
													<!-- Cabecalho das caixinhas das Secretarias -->
													<span class="spon" data-orgao="${funcionario.orgao}" data-setor="${funcionario.setor}">
														<p>${funcionario.setor}</p>
														<br />
													</span> 
													<span data-setor="${funcionario.setor}"
													data-nome="${funcionario.nome}"
													data-cargo="${funcionario.cargo}"
													data-admissao="${funcionario.admissao}"
													data-exoneracao="${funcionario.exoneracao}"
													style="background-color: #3b9187" class="spon">
														${funcionario.nome}<br />
													</span>
													<br />
													<!-- Busca infos dos Secretarios Adjuntos de cada Secretaria no BD -->
													<c:forEach var="funcionario2" items="${bd.buscaSetor(\"Secretario Adjunto\", funcionario.orgao, funcionario.setor)}">
														<!-- Span contem os dados que sao tratados na funcao pegaDados() e exibe dados dos Secretarios Adjuntos  -->
														<span data-setor="${funcionario.setor}"
															data-nome="${funcionario2.nome}"
															data-cargo="${funcionario2.cargo}"
															data-admissao="${funcionario2.admissao}"
															data-exoneracao="${funcionario2.exoneracao}"
															style="background-color: #80cbc2" class="spon">
															${funcionario2.nome}<br />
														</span>
														<br />
														<!-- Busca infos dos Chefe de Gabinete de cada Secretaria no BD -->
														<c:forEach var="funcionario3" items="${bd.buscaSetor(\"Chefe de Gabinete\", funcionario.orgao, funcionario.setor)}">
															<span data-setor="${funcionario.setor}" 
																data-nome="${funcionario3.nome}"
																data-cargo="${funcionario3.cargo}"
																data-admissao="${funcionario3.admissao}"
																data-exoneracao="${funcionario3.exoneracao}"
																style="background-color: #c9e8e5" class="spon">
																${funcionario3.nome}<br />
															</span>
														</c:forEach>
													</c:forEach>
													<!-- Busca infos que serao exibidas no rodape do Modal -->
													<c:forEach var="set" items="${setor.buscaSetor(funcionario.orgao, funcionario.setor)}">
														<span data-end="${set.endereco}" data-cep="${set.cep}"
															data-tel="${set.telefone}" data-email="${set.email}"
															data-site="${set.site}"></span>
													</c:forEach>
												</a>
											</li>
										</c:forEach>
									</ul>
								</li>
								<li class="department dep-b">
									<a>
										<!-- Menu indicando cores dos cargos das Subprefeituras -->
										<span> Subprefeituras <br />
											<div class="container">
												<div style="background-color: #80deea" class="legendas div-left">
													<p class="div-right">Subprefeito(a)</p>
												</div>
												<br />
												<div style="background-color: #b2ebf2" class="legendas div-left">
													<p class="div-right">Chefe de Gabinete</p>
												</div>
											</div>
										</span>
									</a>
									<ul class="sections">
										<!-- Busca infos dos Subprefeitos no BD -->
										<c:forEach var="funcionario" items="${bd.buscaCargo(\"Subprefeito\", \"Subprefeitura\")}">
											<li class="section">
												<!-- Chamada da funcao que pega dados para coloca-los no Modal -->
												<a id="${funcionario.setor}" href="" onclick="pegaDados(this);" data-toggle="modal" data-target="#myModal">
													<!-- Span contem os dados que sao tratados na funcao pegaDados() e exibe dados dos Subprefeitos -->
													<!-- Cabecalho das caixinhas das Subprefeituras -->
													<span class="spon" data-orgao="${funcionario.orgao}" data-setor="${funcionario.setor}">
														<p>${funcionario.setor}</p>
														<br />
													</span>
													<span data-setor="${funcionario.setor}"
													data-nome="${funcionario.nome}"
													data-cargo="${funcionario.cargo}"
													data-admissao="${funcionario.admissao}"
													data-exoneracao="${funcionario.exoneracao}"
													style="background-color: #80deea" class="spon">
														${funcionario.nome}<br />
													</span> <br /> <!-- Busca infos dos Chefes de Gabinete de cada Subprefeitura no BD -->
													<c:forEach var="funcionario2" items="${bd.buscaSetor(\"Chefe de Gabinete\", funcionario.orgao, funcionario.setor)}">
														<span data-setor="${funcionario.setor}"
															data-nome="${funcionario2.nome}"
															data-cargo="${funcionario2.cargo}"
															data-admissao="${funcionario2.admissao}"
															data-exoneracao="${funcionario2.exoneracao}"
															style="background-color: #c9e8e5" class="spon">
															${funcionario2.nome}<br />
														</span>
													</c:forEach>
													<!-- Busca infos que serao exibidas no rodape do Modal -->
													<c:forEach var="set" items="${setor.buscaSetor(funcionario.orgao, funcionario.setor)}">
														<span data-end="${set.endereco}" data-cep="${set.cep}"
															data-tel="${set.telefone}" data-email="${set.email}"
															data-site="${set.site}"></span>
													</c:forEach>
												</a>
											</li>
										</c:forEach>
									</ul>
								</li>								
							</ul>
						</li>
					</ul>
				</li>
			</ul>
		</figure>
	</div>

	<!-- Modal -->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title" id="myModalLabel" style="text-align: center; width: 97%; padding-left: 3.1%">
						<!-- Modal Title -->
					</h4>
				</div>
				<div id="modalBody" class="modal-body" style="text-align: center">
					<!-- Aqui serao inseridos dados sobre os funcionarios -->
				</div>
				<div id="modalFooter" class="modal-footer"
					style="text-align: center">
					<!-- Aqui serao inseridos dados complementares de cada setor -->
				</div>
			</div>
		</div>
	</div>
</body>
</html>
