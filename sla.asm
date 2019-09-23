  
#-------------------------------------------------------------------------
#		OrganizaÃƒÂ§ÃƒÂ£o e Arquitetura de Computadores - Turma C 
#			Trabalho 1 - Assembly RISC-V
#
# Nome: Jônatas Gomes Barbosa da Silva	Matricula: 17/0059847
# Nome: Marcos				Matricula: 
# Nome: Tatiana Franco Pereira		Matricula: 18/0131206

.data
#menu:
	str:	.asciz "\n. Defina o numero da função desejada: \n"	#declaracao da string "str"
	str2:	.asciz "	1. Obtem ponto\n"
	str3: 	.asciz "	2. Desenha ponto\n"
	str4: 	.asciz "	3. Desenha retangulo com preenchimento\n"
	str5: 	.asciz "	4. Desenha retangulo sem preenchimento\n"
	str6: 	.asciz "	5. Converte para negativo da imagem\n"
	str7: 	.asciz "	6. Converte imagem para tons de vermelho\n"
	str8: 	.asciz "	7. Carrega imagem\n"
	str9: 	.asciz "	8. Encerra\n"
		
#genericos:
	X0Y0:   .word 0x10043F00
	ent1:	.asciz "Digite um valor de 0 a 63:\n"
	ent2:	.asciz "Digite um valor de 0 a 255:\n"
	x:	.asciz "X -> "
	y:	.asciz "Y -> "
	xi:	.asciz "Xi -> "
	yi:	.asciz "Yi -> "
	xf:	.asciz "Xf -> "
	yf:	.asciz "Yf -> "	
	valorR:	.asciz "Valor de R: "
	valorG: .asciz "Valor de G: "
	valorB: .asciz "Valor de B: "
		
	
#load_image:
	image_name:   	.asciz "lenaeye.raw"	# nome da imagem a ser carregada
	address: 	.word   0x10040000	# endereco do bitmap display na memoria	
	buffer:		.word   0		# configuracao default do RARS
	size:		.word	4096		# numero de pixels da imagem

.text
#Definição dos limites
	li a5, 64
	li a6, 256

# definicao de macros

	.macro print_string($arg)
		#chamada de sistema para imprimir strings na tela
		#parÃ¢metros: a0 -> endereÃ§o da string que se quer imprimir
		#retorno: imprime uma string no console
		li	a7, 4		#a7=4 -> definiÃ§Ã£o da chamada de sistema para imprimir strings na tela
		la	a0, $arg	#a0=endereÃ§o da string "ent1"
		ecall			
	.end_macro 
	
	.macro entradaxy()	#Macro de entrada dos valores de X e Y
		ent_x:	print_string(ent1)
			print_string(x)
			li a7, 5		#coloca x no registrador s1
			ecall			
			mv s1, a0
			bge s1, a5, ent_x
			blez s1, ent_x
		
		ent_y:	print_string(ent1)			
			print_string(y)
			li a7, 5		#coloca y no registrador s2
			ecall			
			mv s2, a0
			bge s2, a5, ent_y
			blez s2, ent_y
	.end_macro
	
	.macro entradaxy2()	#Macro de entrada dos valores de Xi, Xf, Yi e Yf
		ent_xi:	print_string(ent1)
			print_string(xi)
			li a7, 5		#coloca xi no registrador s1
			ecall			
			mv s1, a0
			bge s1, a5, ent_xi	#Caso o valor recebido seja maior ou igual a 64, ele retorna ao início da leitura.
			blez s1, ent_xi		#Caso o valor seja igual ou menor que zero, ele também retorna ao início da leitura.
			
		ent_xf:	print_string(ent1)
			print_string(xf)
			li a7, 5		#coloca xf no registrador s2
			ecall
			mv s2, a0
			bge s2, a5, ent_xf	#Caso o valor recebido seja maior ou igual a 64, ele retorna ao início da leitura.
			blez s2, ent_xf		#Caso o valor seja igual ou menor que zero, ele também retorna ao início da leitura.
			
		ent_yi:	print_string(yi)
			li a7, 5		#coloca yi no registrador s3
			ecall			
			mv s3, a0
			bge s3, a5, ent_yi	#Caso o valor recebido seja maior ou igual a 64, ele retorna ao início da leitura.
			blez s3, ent_yi		#Caso o valor seja igual ou menor que zero, ele também retorna ao início da leitura.
			
		ent_yf:	print_string(yf)
			li a7, 5		#coloca yf no registrador s4
			ecall
			mv s4, a0
			bge s4, a5, ent_yf	#Caso o valor recebido seja maior ou igual a 64, ele retorna ao início da leitura.
			blez s4, ent_yf		#Caso o valor seja igual ou menor que zero, ele também retorna ao início da leitura.
	.end_macro
	
	.macro entradargb()	#Macro de entradas dos valores RGB
		red: 	print_string(ent2)
			print_string(valorR)
			li a7, 5		#coloca o valor R no registrador s5
			ecall			
			mv s5, a0
			bge s5, a6, red		#Caso o valor recebido seja maior, igual a 256 ou menor que zero ele retorna ao início da leitura.
			blt s5, zero, red		
		
		blue:	print_string(ent2)
			print_string(valorG)
			li a7, 5		#coloca o valor G no registrador s6
			ecall			
			mv s6, a0
			bge s6, a6, blue	#Caso o valor recebido seja maior, igual a 256 ou menor que zero ele retorna ao início da leitura.
			blt s6, zero, blue

		green:	print_string(ent2)	
			print_string(valorB)
			li a7, 5		#coloca o valor B no registrador s7
			ecall			
			mv s7, a0
			bge s7, a6, green	#Caso o valor recebido seja maior, igual a 256 ou menor que zero ele retorna ao início da leitura.
			blt s7, zero, green
	.end_macro

menu:	print_string(str)	#imprime as opcoes do menu
	print_string(str2)
	print_string(str3)
	print_string(str4)
	print_string(str5)
	print_string(str6)
	print_string(str7)
	print_string(str8)
	print_string(str9)
	
	#le a opcao escolhida pelo usuario
	li a7, 5		
	ecall			
	mv t0, a0
	
	#usa o t1 para comparar as opcoes de menu
	addi t1, x0, 1			# t1 = 1	
	
	beq t0, t1, get_point		#if t0 == 1 
	addi t1, t1, 1			#else t1++
	beq t0, t1, draw_point		#if t0 == 2	
	addi t1, t1, 1
	beq t0, t1, draw_full_rectangle	#if t0 == 3, e por ai vai, ate chegar na ultima opcao de menu
	addi t1, t1, 1
	beq t0, t1, draw_empty_rectangle
	addi t1, t1, 1
	beq t0, t1, convert_negative
	addi t1, t1, 1
	beq t0, t1, convert_redtones
	addi t1, t1, 1
	beq t0, t1, load_image
	addi t1, t1, 1
	beq t0, t1, encerra
	
get_point: 
	#recebe coordenadas de x e y
		entradaxy()
	
	#coloca os valores auxiliares nos registradores
		li t2, 1	#t2 = 1
		li t3, 256	#t3 = 256
		li t4, 4	#t4 = 4
		lw s5, X0Y0	#t5 = posicao no Bitmap onde x = 0 e y = 0
	
	#localiza x e y no bitmap display  
		#subtrai 256 da posicao inicial y vezes	
	loopy1:	blez  s2, loopx1
		sub s5, s5, t3
		sub s2, s2, t2
		j loopy1
	 
	#adiciona 4 a posicao atual x vezes
	loopx1:	blez s1, pegaCor 
		add s5, s5, t4
		sub s1, s1, t2
		j  loopx1
		
	#separa os valores das cores movendo os bits pra direita e pra esquerda	
	pegaCor: 
		lw   t4, 0(s5)   		# le pixel do display
		srli t2, t4, 16
		srli t3, t4, 8
		slli t3, t3, 24				
		srli t3, t3, 24
		slli t5, t4, 24
		srli t5, t5, 24
						
	#imprime a cor
		print_string(valorR)
		li a7, 1		#coloca o valor R no registrador s5
		mv a0, t2
		ecall			
			
		
		print_string(valorG)
		li a7, 1		#coloca o valor G no registrador s6
		mv a0, t3
		ecall			
		
		print_string(valorB)
		li a7, 1		#coloca o valor B no registrador s7
		mv a0, t5
		ecall			

	j menu	#volta pro menu

draw_point: 
	#recebe coordenadas de x e y
		entradaxy()

	#coloca os valores auxiliares nos registradores
		li t2, 1	#t2 = 1
		li t3, 256	#t3 = 256
		li t4, 4	#t4 = 4	
		lw t5, X0Y0	#t5 = posicao no Bitmap onde x = 0 e y = 0
	
	#localiza x e y no bitmap display  
		#subtrai 256 da posicao inicial y vezes	
	loopy2:	blez  s2, loopx2
		sub t5, t5, t3
		sub s2, s2, t2
		j loopy2
		 
	#adiciona 4 a posicao atual x vezes
	loopx2:	blez s1, corRGB 
		add t5, t5, t4
		sub s1, s1, t2
		j  loopx2
	
	#altera a cor do ponto
		#recebe os valores do usuario
		corRGB: entradargb()
			
		#soma os valores e move 8 bits pra direita, liberando espaÃ§o para o prÃ³ximo valor
		or t1, s0, s5
		slli t1, t1, 8
		or  t1, t1, s6
		slli t1, t1, 8
		or t1, t1, s7
	
		#regista a cor em RGB no endereco correspondente ao ponto
		li s2, 0   #cor em rgb
		or s2, s2, t1
		sw s2, 0(t5)	
			
	j menu	#volta pro menu
				
draw_full_rectangle:
	lw t5, X0Y0	#Posicao (0,0)
		
	#recebe os dados de xi, yi, xf, yf e as cores em RGB
		entradaxy2()
			
		#subtrai os valores a fim de achar a largura e a altura, caso necessario, pode ser alterado mais a frente
		sub a1, s2, s1
		sub a3, s4, s3
			
		#se s2=xf for maior q s1=xi, nÃ£o troca e pula pra conferir os valores de y
		bgeu s2, s1, conti
		#caso contrario troca e recalcula o valor da largura a fim de evitar nÃºmeros negativos
		sub a1, s1, s2
		mv t4, s1
		mv s1, s2
		mv s2, t4
			
		#mesma coisa q anteriormente, mas com s3=yi e s4=yf, calculando o valor da altura
	conti:	bgeu s4, s3, conti2
		sub a3, s3, s4
		mv t4, s3
		mv s3, s4
		mv s4, t4
			
			
	conti2:	mv t4, s4
		mv t2, s4
		mv s8, s2
		mv t3, s2
		sub s8, s8, s1
		sub t3, t3, s1
		sub t4, t4, s3
		sub t2, t2, s3
			
		#recebe os valores de RGB
		entradargb()
		#os posiciona movendo os bits para a esquerda de acordo com a cor q esta sendo definida	
		or t1, s0, s5
		slli t1, t1, 8
		or  t1, t1, s6
		slli t1, t1, 8
		or t1, t1, s7
		
		#localiza a posicao de acordo com o y (onde o retangula vai comecar a ser desenhado)
	loopigy:blez  s3, loopigx
		addi t5, t5, -256
		addi s3, s3, -1

		j loopigy
		
		#localiza a posicao de acordo com o x 
	loopigx:blez s1, colore
		addi t5, t5, 4 
		addi s1, s1, -1
		j  loopigx
			
		#sai do loop anterior e comeca a colorir o retangulo	
	colore:	mv a4, a1 #largura do retangulo (quantos x temos q andar)
		mv t4, t5 #posicao do parametro q define em qual linha (y) estamos

		#pinta o ponto
	colore2:li a2, 0   #cor em rgb
		or a2, a2, t1
		sw a2, 0(t5)
		#anda pro proximo pixel
		addi t5, t5, 4
		addi a1, a1, -1
		#se ainda n tiver zerado a flag de quantos pontos pintamos da largura, pinta o pixel do lado	
		bgt a1, zero, colore2
		#se já tiver zerado, passa pra linha de cima	
		addi a3, a3, -1
		addi t4, t4, -256
			
		mv a1, a4
		mv t5, t4
		#se o parametro q controla a altura q ainda falta ser pintada zerar, encerra a funcao	
		bgt a3, zero,  colore2		
		
	j menu	#volta pro menu
	
draw_empty_rectangle: 
	lw t5, X0Y0	#Posicao (0,0)
		
	entradaxy2()
			
	bgeu s2, s1, cont
	mv t4, s1
	mv s1, s2
	mv s2, t4
			
	cont:	bgeu s4, s3, cont2
		mv t4, s3
		mv s3, s4
		mv s4, t4
		
	cont2:	mv t4, s4
		mv t2, s4
		mv s8, s2
		mv t3, s2
		sub s8, s8, s1
		sub t3, t3, s1
		sub t4, t4, s3
		sub t2, t2, s3
			
		entradargb()
			
		or t1, s0, s5
		slli t1, t1, 8
		or  t1, t1, s6
		slli t1, t1, 8
		or t1, t1, s7
		
	loopgy:	blez  s3, loopgx
		addi t5, t5, -256
		addi s3, s3, -1

		j loopgy
		 
	loopgx:	blez s1, curso
		addi t5, t5, 4 
		addi s1, s1, -1
		j  loopgx
				
	curso: 	li a2, 0   #cor em rgb
		or a2, a2, t1
		sw a2, 0(t5)
		blez s8, curso2
		addi s8, s8, -1
		addi t5, t5, 4
			
		j curso
		
	curso2:	li a2, 0   #cor em rgb
		or a2, a2, t1
		sw a2, 0(t5)
		blez t4, curso3
		addi t4, t4, -1
		addi t5, t5, -256
			
		j curso2
			
	curso3: li a2, 0   #cor em rgb
		or a2, a2, t1
		sw a2, 0(t5)
		blez t3, curso4
		addi t3, t3, -1
		addi t5, t5, -4
			
		j curso3
			
	curso4:	li a2, 0   #cor em rgb
		or a2, a2, t1
		sw a2, 0(t5)
		blez t2, fim
		addi t2, t2, -1
		addi t5, t5, 256
			
		j curso4
	
	fim:	j menu	#volta para o menu
	
convert_negative:  
	lw s1, address	#carrega o endereco inicial, por onde vai comecar a mexer nos pixels
	lw a3, size	#quantidade de pixels q serao modificados (tamanho da imagem)
	#loop utilizado para ler pixel a pixel da imagem
	loopneg:  
		
		beq a3, zero, endneg		#verifica se o contador de pixels da imagem chegou a 0
	        
		lw   t4, 0(s1)   		# lÃª pixel do display
		srli t5, t4, 16
		slli t5, t5, 16
		srli t2, t4, 8
		slli t2, t2, 24
		srli t2, t2, 16
		slli t3, t4, 24				
		srli t3, t3, 24
		addi t6, zero, 255

		sub t2, t6, t2
		sub t3, t6, t3
		sub t5, t6, t5
			

		srli t5, t5, 16
		slli t5, t5, 16
		srli t2, t2, 8
		slli t2, t2, 24
		srli t2, t2, 16
		slli t3, t3, 24
		srli t3, t3, 24

		addi t4, zero, 0
		or t4, t4, t2
		or t4, t4, t3
		or t4, t4, t5
			
		sw   t4, 0(s1)   		# escreve pixel no display
		addi s1, s1, 4  		# proximo pixel
		addi a3, a3, -1  		# decrementa countador de pixels da imagem
			
		j loopneg
			
	endneg:	j menu #volta para o menu
	
convert_redtones:
	lw t1, address 	#carrega o endereco inicial, por onde vai comecar a mexer nos pixels
	lw t3, size 	#quantidade de pixels q serao modificados (tamanho da imagem)
	#loop utilizado para ler pixel a pixel da imagem
	loopred:  
		
		beq t3, zero, endred		#verifica se o contador de pixels da imagem chegou a 0
		           		
		lw   t2, 0(t1)   		# le pixel do display
		srli t2, t2, 16			#anda 16 bits pra direita, apagando o conteudo de G e B
		slli t2, t2, 16			#anda 16 bits pra esquerda, volta R para a sua devida posicao
		sw   t2, 0(t1)   		# escreve pixel no display
		addi t1, t1, 4  		# proximo pixel
		addi t3, t3, -1  		# decrementa countador de pixels da imagem
			
		j loopred
			
	endred:	j menu
	
load_image:
	# define parametros e chama a funcao para carregar a imagem
	la a0, image_name
	lw a1, address
	la a2, buffer
	lw a3, size
	jal load_pixels
  	
	#definicao da chamada de sistema para encerrar programa	
	#parametros da chamada de sistema: a7=10
	li a7, 10		
	ecall

	#-------------------------------------------------------------------------
	# Funcao load_pixels: carrega uma imagem em formato RAW RGB para memoria
	# Formato RAW: sequencia de pixels no formato RGB, 8 bits por componente
	# de cor, R o byte mais significativo
	#
	# Parametros:
	#  a0: endereco do string ".asciz" com o nome do arquivo com a imagem
	#  a1: endereco de memoria para onde a imagem sera carregada
	#  a2: endereco de uma palavra na memoria para utilizar como buffer
	#  a3: tamanho da imagem em pixels
	#

  
	load_pixels:
		# salva os parametros da funcao nos temporarios
		mv t0, a0		# nome do arquivo
		mv t1, a1		# endereco de carga
		mv t2, a2		# buffer para leitura de um pixel do arquivo
	
		# chamada de sistema para abertura de arquivo
		#parametros da chamada de sistema: a7=1024, a0=string com o diretorio da imagem, a1 = definicao de leitura/escrita
		li a7, 1024		# chamada de sistema para abertura de arquivo
		li a1, 0		# Abre arquivo para leitura (pode ser 0: leitura, 1: escrita)
		ecall			# Abre um arquivo (descritor do arquivo eh retornado em a0)
		mv s6, a0		# salva o descritor do arquivo em s6
	
		mv a0, s6		# descritor do arquivo 
		mv a1, t2		# endereco do buffer 
		li a2, 3		# largura do buffer
	
	#loop utilizado para ler pixel a pixel da imagem
	loopload:  
		
		beq a3, zero, close		#verifica se o contador de pixels da imagem chegou a 0
		
		#chamada de sistema para leitura de arquivo
		#parametros da chamada de sistema: a7=63, a0=descritor do arquivo, a1 = endereco do buffer, a2 = maximo tamanho pra ler
		li a7, 63				# definicao da chamada de sistema para leitura de arquivo 
		ecall            		# le o arquivo
		lw   t4, 0(a1)   		# le pixel do buffer	
		sw   t4, 0(t1)   		# escreve pixel no display
		addi t1, t1, 4  		# proximo pixel
		addi a3, a3, -1  		# decrementa countador de pixels da imagem
			
		j loopload
		
	# fecha o arquivo 
	close:
		# chamada de sistema para fechamento do arquivo
		#parametros da chamada de sistema: a7=57, a0=descritor do arquivo
		li a7, 57		# chamada de sistema para fechamento do arquivo
		mv a0, s6		# descritor do arquivo a ser fechado
		ecall           # fecha arquivo
			
			
	j menu
	
#chamada de sistema para terminar programa 
encerra:	
	li	a7, 10		
	ecall
