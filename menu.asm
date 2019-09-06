#-------------------------------------------------------------------------
#		Organização e Arquitetura de Computadores - Turma C 
#			Trabalho 1 - Assembly RISC-V
#
# Nome: 				Matricula: 
# Nome: 				Matricula: 
# Nome: 				Matricula: 

.data
	#menu:
		str:	.asciz ". Defina o numero opcao desejada: \n"	#declara��o da string "str"
		str2:	.asciz "	1. Obtem ponto\n"
		str3: 	.asciz "	2. Desenha ponto\n"
		str4: 	.asciz "	3. Desenha retangulo com preenchimento\n"
		str5: 	.asciz "	4. Desenha retangulo sem preenchimento\n"
		str6: 	.asciz "	5. Converte para negativo da imagem\n"
		str7: 	.asciz "	6. Converte imagem para tons de vermelho\n"
		str8: 	.asciz "	7. Carrega imagem\n"
		str9: 	.asciz "	8. Encerra\n"
	
	#load_image:
		image_name:   	.asciz "lenaeye.raw"	# nome da imagem a ser carregada
		address: 	.word   0x10040000	# endereco do bitmap display na memoria	
		buffer:		.word   0		# configuracao default do RARS
		size:		.word	4096		# numero de pixels da imagem
	
	strop1: .asciz "(Executa opcao 1)\n"
	strop2: .asciz "(Executa opcao 2)\n"
	strop3: .asciz "(Executa opcao 3)\n"
	strop4: .asciz "(Executa opcao 4)\n"
	strop5: .asciz "(Executa opcao 5)\n"
	strop6: .asciz "(Executa opcao 6)\n"
	strop7: .asciz "(Executa opcao 7)\n"
	
	

.text

# definicao de macros

	.macro print_string($arg)
		#chamada de sistema para imprimir strings na tela
		#par�metros: a0 -> endere�o da string que se quer imprimir
		#retorno: imprime uma string no console
		li	a7, 4		#a7=4 -> defini��o da chamada de sistema para imprimir strings na tela
		la	a0, $arg	#a0=endere�o da string "str0"
		ecall			
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
		print_string(strop1)
		j menu

	draw_point: 
		print_string(strop2)
		j menu
	
	draw_full_rectangle:
		print_string(strop3)
		j menu
	
	draw_empty_rectangle: 
		print_string(strop4)
		j menu
	
	convert_negative:  
		print_string(strop5)
		j menu
	convert_redtones:
		print_string(strop6)
		j menu
	
	load_image:
		# define par�metros e chama a fun��o para carregar a imagem
		la a0, image_name
		lw a1, address
		la a2, buffer
		lw a3, size
		jal load_pixels
  	
		#defini��o da chamada de sistema para encerrar programa	
		#par�metros da chamada de sistema: a7=10
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
		# A fun��o foi implementada ... (explica��o da fun��o)
  
		load_pixels:
			# salva os par�metros da fun�ao nos tempor�rios
			mv t0, a0		# nome do arquivo
			mv t1, a1		# endereco de carga
			mv t2, a2		# buffer para leitura de um pixel do arquivo
	
			# chamada de sistema para abertura de arquivo
			#par�metros da chamada de sistema: a7=1024, a0=string com o diret�rio da imagem, a1 = defini��o de leitura/escrita
			li a7, 1024		# chamada de sistema para abertura de arquivo
			li a1, 0		# Abre arquivo para leitura (pode ser 0: leitura, 1: escrita)
			ecall			# Abre um arquivo (descritor do arquivo � retornado em a0)
			mv s6, a0		# salva o descritor do arquivo em s6
	
			mv a0, s6		# descritor do arquivo 
			mv a1, t2		# endere�o do buffer 
			li a2, 3		# largura do buffer
	
		#loop utilizado para ler pixel a pixel da imagem
		loop:  
		
			beq a3, zero, close		#verifica se o contador de pixels da imagem chegou a 0
		
			#chamada de sistema para leitura de arquivo
			#par�metros da chamada de sistema: a7=63, a0=descritor do arquivo, a1 = endere�o do buffer, a2 = m�ximo tamanho pra ler
			li a7, 63				# defini��o da chamada de sistema para leitura de arquivo 
			ecall            		# l� o arquivo
			lw   t4, 0(a1)   		# l� pixel do buffer	
			sw   t4, 0(t1)   		# escreve pixel no display
			addi t1, t1, 4  		# pr�ximo pixel
			addi a3, a3, -1  		# decrementa countador de pixels da imagem
			
			j loop
		
		# fecha o arquivo 
		close:
			# chamada de sistema para fechamento do arquivo
			#par�metros da chamada de sistema: a7=57, a0=descritor do arquivo
			li a7, 57		# chamada de sistema para fechamento do arquivo
			mv a0, s6		# descritor do arquivo a ser fechado
			ecall           # fecha arquivo
			
			
		j menu
	
	#chamada de sistema para terminar programa 
	encerra:	
		li	a7, 10		
		ecall			
