.data
	X0Y63: .word 0x10040000 #endereco no bitmap
	X63Y63: .word 0x100400FC
	X0Y0: .word 0x10043F00
	X63Y0: .word 0x10043FFC

	str0:	.asciz "Digite as posicoes X e Y, espectivamente:"
	x:	.asciz "\nX -> "
	y:	.asciz "\nY -> "	
	str1:	.asciz "\nPosicoes dadas:"		
	seuXeh: .asciz "\nPosicao x -> "
	seuYeh: .asciz "\nPosicao y -> "
	
.text
	.macro print_string($arg)
		#chamada de sistema para imprimir strings na tela -> definida por a7=4 
		#parâmetros: a0 -> endereço da string que se quer imprimir
		#retorno: imprime uma string no console
		li	a7, 4		#a7=4 -> definição da chamada de sistema para imprimir strings na tela
		la	a0, $arg	#a0=endereço da string "str0"
		ecall			#realiza a chamada de sistema
	.end_macro 

#testes para achar os enderecos dos cantos do Bitmap
	
	#x = 0 e y = 0
	lw t0, X0Y0
	li t1, 0x0000FF00 #cor em rgb
	sw t1, 0(t0)
	
	#x = 63 e y = 63
	lw t0, X63Y63
	li t1, 0x00FF00FF #cor em rgb
	sw t1, 0(t0)
	
	#x = 0 e y = 63
	lw t0, X0Y63
	li t1, 0x000000FF #cor em rgb
	sw t1, 0(t0)
	
	#x = 63 e y = 0
	lw t0, X63Y0
	li t1, 0x00FF0000 #cor em rgb
	sw t1, 0(t0)

	#recebe coordenadas de x e y
	print_string(str0)
	print_string(x)
	li a7, 5		#coloca x no registrador t0
	ecall			
	mv t0, a0
	print_string(y)
	li a7, 5		#coloca y no registrador t1
	ecall			
	mv t1, a0
	
	#imprime na tela as posicoes dadas
	print_string(str1)
	print_string(seuXeh)
	li a7, 1		#imprime x
	mv a0, t0
	ecall	
	print_string(seuYeh)
	li a7, 1		#imprime y
	mv a0, t1
	ecall

	
	#primeiro eu coloquei os dados nos registradores q vao nos auxiliar, e coloquei o ponto na posicao x = 0 e y = 0
		li t2, 1
		li t3, 256
		li t4, 4
		lw t5, X0Y0
	
	#depois  achamos a posicao de y em hexadecimal
	#pra isso, eu subtrai 256 da posicao inicial y vezes.
				
	loopy:	blez  t1, loopx
		sub t5, t5, t3
		sub t1, t1, t2
		j loopy
		
	#depois achamos a posicao de x em hexadecimal ao adicionar 4 a posicao atual x vezes
	loopx:	blez t0, fimxy
		add t5, t5, t4
		sub t0, t0, t2
		j  loopx
	
	#por �ltimo selecionamos a cor do ponto, q ainda falta alguns ajustes, por enquanto ta so vermelho msm e
	fimxy:	li t1, 0x00FF0000 #cor em rgb
		sw t1, 0(t5)
		ecall
	
	
	#termina programa
	li	a7, 10		
	ecall			
