# Scripting
# -------------------------
# Se deberá generar un script llamado scripting-tp-integrador.sh el cual mostrará un menu que tendra las siguientes 
#funcionalidades (Se puede tomar como ejemplo el ejercicio nº 8 de scripting):

#################################################################################################################
##############################################    FUNCIONES   ###################################################
#################################################################################################################
# Pedir un numero entero y mostrar esa cantidad de elementos de la sucesion de Fibonacci.
function generarFibbonacci()
{
	# Se incializan variables necesarias
	numIni=0
	numSig=1
	suma=0
	sucesionFibbo=0
	# Se solicitan el numero para cacular la sucesion de Fibonacci
	read -p "Ingrese un numero para calcular su sucesion de Fibbonacci entre 0 y 50: " numIngresado
	while [ $numIngresado -lt 1 ] || [ $numIngresado -gt 50 ] # Se valida que el numero este entre 1 y 50
	do
		read -p "Ingreso incorrecto. Ingrese un numero para calcular su sucesion de Fibbonacci entre 0 y 50: " numIngresado
	done
	
	# Algoritmo que genera la sucesión Fibbonacci
	for (( i=0; i<=$numIngresado; i++))
	do
		#echo $suma
		numIni=$numSig
		numSig=$suma
		sucesionFibbo="$sucesionFibbo"",""$suma" # Vamos agregando a la cadena de numeros la sucesion que se va obteniendo
		suma=$(expr $numIni + $numSig)
	done
	sucesionFibbo=$(echo $sucesionFibbo | sed -e 's/^0,//') # Quitamos el "0," que se genera demás en la primer vuelta
	echo -e "\nLa sucesion Fibbonacci del numero "$numIngresado" es: $sucesionFibbo"
}

#**************************************************************************************************************************************
# Pedir un numero entero y mostrar por pantalla ese numero en forma invertida.
function generarInvertido()
{
	regex12="^[-+]?([0-9][0-9]?|100)$"  # Regex para 1 y 2 digitos
	regex34="^[-+]?([0-9][0-9][0-9][0-9]?|100)$"  # Regex para 3 y 4 digitos
	#regex56="^[-+]?([0-9][0-9][0-9][0-9][0-9][0-9]?|100)$"  # Regex para 5 y 6 digitos
	
	# Se solicitan el numero entero
	read -p "Ingrese un numero entero como maximo de 4 digitos: " numIngresado
	# Se valida que el ingreso sea un numero entero y de 4 digitos como maximo	
	while !([[ $numIngresado =~ $regex12 ]] || [[ $numIngresado =~ $regex34 ]])
	do
		read -p "Ingreso incorrecto. Ingrese un numero entero que no supere los 4 digitos: " numIngresado
	done
	
	#Se invierte el numero ingresado
	numInvertido=$(echo $numIngresado | rev)
	echo -e "\nNumero ingresado es: $numIngresado"
	echo "Numero invertido es: $numInvertido"
}
#**************************************************************************************************************************************
# Pedir una cadena de caracteres y evaluar si es palindromo o no.
function evaluarPalindromo()
{
	# Se solicitan que ingrese una cadena
	read -p "Ingrese una cadena: " cadIngresada
	
	# Se evalua si la cadena es palindromo
	cadInvertida=$(echo $cadIngresada | rev)
	
	# Se evalua si la cadena ingresada es igual a su invertida
	if [ "$cadIngresada" = "$cadInvertida" ]
	then
		echo -e "\nLa cadena ingresada $cadIngresada es palindromo"
	else
		echo -e "\nLa cadena ingresada $cadIngresada no es palindromo"
	fi
}
#**************************************************************************************************************************************
# Pedir el path a un archivo de texto y mostrar por pantalla la cantidad de lineas que tiene.
function mostrarLineasArchivo()
{
	#En caso que el path ingresado sea incorrecto se solicita un nuevo path para proseguir
	read -p "Ingrese el path del archivo:  " pathFile
	while [  ! -f $pathFile ];#Con -f evalua si el archivo no existe
	do
		echo -e "\nEl path ingresado o el archivo no existe"
		read -p "Ingrese el path del archivo:  " pathFile
	done
	
	#Se muestra la cantidad de lineas que tiene el archivo especificado
	echo -e "\nEl archivo $pathFile tiene $(cat $pathFile | wc -l) lineas"
}

#**************************************************************************************************************************************
# Pedir el ingreso de 5 numeros enteros y mostrarlos por pantalla en forma ordenada.
function ordenarNumeros()
{
	regexForNum1="^[-+]?([0-9][0-9]?|100)$" # Regex para numeros enteros
	regexForNum2="^[-+]?([0-9][0-9][0-9][0-9]?|100)$"  # Regex para 3 y 4 digitos

	#Bucle for que carga el array con 5 numeros ingresados por el usuario
	for (( i=0; i<5; i++ ))
	do
		# Se solicita cada numero en cada vuelta
		read -p "Ingrese un numero entero: " numIngresado
		# Se valida que el ingreso sea un numero entero de maximo de 4 digitos
		while !([[ $numIngresado =~ $regexForNum1 ]] || [[ $numIngresado =~ $regexForNum2 ]])
		do
			read -p "Ingreso incorrecto. Ingrese un numero entero: " numIngresado
		done
		numArray[i]=$numIngresado #Se carga el array con el nuevo numero
	done
	
	echo -e "\nArray original: "
	#Imprime el array
	echo ${numArray[@]}
	
	#Metodo burbuja que ordena el array
	for i in $(seq 1 $[5-1])
	do
		for j in $(seq 0 $[5 - $i - 1])
		do
			if [ ${numArray[$j]} -gt ${numArray[$j+1]} ]
			then
				aux=${numArray[$[$j+1]]}
				numArray[$j+1]=${numArray[$j]}
				numArray[$j]=$aux
			fi
		done
    done
	
	echo -e "\nArray ordenado: "
	#Imprime el array ordenado
	echo ${numArray[@]}
}

#**************************************************************************************************************************************
# Pedir el path a un directorio y mostrar por pantalla cuantos archivos de cada tipo contiene 
#(No se tenga en cuenta ./ y ../).
function mostrarArchivos()
{
	#En caso que el path ingresado sea incorrecto se solicita un nuevo path para proseguir
	read -p "Ingrese el path del archivo:  " pathFile
	while [  ! -d $pathFile ];#Con -f evalua si el path existe
	do
		echo -e "\nEl path ingresado o el archivo no existe"
		read -p "Ingrese el path del archivo:  " pathFile
	done
	
	echo -e "\nEl path $pathFile tiene $(ls -l $pathFile |grep ^d | wc -l) directorios" # Muestra la cantidad de directorios en el path
	echo "El path $pathFile tiene $(ls -l $pathFile |grep ^- | wc -l) archivos" # Muestra la cantidad de archivos en el path
	echo "El path $pathFile tiene $(ls -l $pathFile |grep ^l | wc -l) links simbolicos" # Muestra la cantidad de links simbolicos en el path
}

#################################################################################################################
##############################################    MAIN   ########################################################
#################################################################################################################

echo -e "\n"
echo -e "                           +-----------------------+"
echo -e "                           | CAplicada - Scripting |"
echo -e "                           +-----------------------+\n"

menuOption="1" 

while [ "$menuOption" != "7" ]
do
	
	echo -e "\n1. Generar Fibbonacci"
	echo -e "2. Generar invertido"
	echo -e "3. Evaluar palindromo"
	echo -e "4. Mostrar cantidad de lineas de archivo especificado"
	echo -e "5. Ordenar numeros ingresados"
	echo -e "6. Mostrar archivos"
	echo -e "7. Salir"
	read -p "" menuOption #Guarda la opción elegida
	
	#Mientras la opcion ingresada no sea válida se seguira pidiendo una opción.
	while [ "$menuOption" != "1" ] && [ "$menuOption" != "2" ] && [ "$menuOption" != "3" ] && [ "$menuOption" != "4" ] && [ "$menuOption" != "5" ] && [ "$menuOption" != "6" ] &&[ "$menuOption" != "7" ];
	do
		echo -e "\n1. Generar Fibbonacci"
		echo -e "2. Generar invertido"
		echo -e "3. Evaluar palindromo"
		echo -e "4. Mostrar cantidad de lineas de archivo especificado"
		echo -e "5. Ordenar numeros ingresados"
		echo -e "6. Mostrar archivos"
		echo -e "7. Salir"
		read -p "" menuOption #Guarda la opción elegida
	done
	
	case $menuOption in
		1)
			echo -e "\nGenerar sucesion Fibbonacci"
			generarFibbonacci
			;;
		2)
			echo -e "\nInvertir numero ingresado"
			generarInvertido
			;;
		3)
			echo -e "\nEvaluar capicua"
			evaluarPalindromo
			;;
		4)
			echo -e "\nMostrar cantidad de lineas de archivo"
			mostrarLineasArchivo
			;;
		5)
			echo -e "\nOrdenar numeros"
			ordenarNumeros
			;;
		6)
			echo -e "\nMostrar cantidad de archivos de un path"
			mostrarArchivos
			;;
		
		7)
			echo -e "\nAdios $(whoami) !!\n" # Se despide el programa saludando al usuario que ejecuto el script
			;;
	esac
done
