# Programar un script con el nombre backup_home_cliente-03.sh, que permita realizar un backup de su carpeta home de la 
# maquina 192.168.20.3 y que cumpla con lo siguiente:
# 	•	Deberá ejecutarse una vez por dia.
# OK	•	Cada ejecución deberá generar un archivo de log con el nombre backup_home_cliente-03.sh_YYYY-mm-dd_HH-MM-SSZ.log 
#		con la información de todo lo que vaya sucediendo (Considere utilizar verbose y stats). 
#OK 	•	Los logs deberan estar dentro de una carpeta llamada logs, la cual deberá estar en el mismo directorio 
#		donde reside el script (Validar la existencia de dicho directorio y crearlo en caso de ser necesario).
# 	•	Antes de realizar el backup, deberá validar si el host se encuentra online.
# 	•	Deberá evitar ingresar la password de usuario en cada ejecución.
# 	•	Al ejecutar rsync, deberá:
# 	•	Preservar los timestamp de todos los archivos transferidos.
# 	•	Los archivos que ya no existan en origen, deberan ser borrados en destino.
# 		1.	Si en origen existe el directorio .cache, este no se deberá transferir.
# 		2.	Todo lo que se escriba en los logs debe ser human-readable (Considere personalizar los formatos de salida).

##############################################    VARIABLES   ###################################################
#Tomo variables de archivos de source
#source "backup_home_cliente-03_Variables.sh"
PATHLOG="/home/mgarcia/Scripting/logs/"
TARGETHOST="192.168.20.253"
#################################################################################################################
##############################################    FUNCIONES   ###################################################
#################################################################################################################

# Se define el nombre del archivo de log con la fecha de ejecución del script
nameLogFile="backup_home_cliente-03.sh_"$(echo $(date +"%Y-%m-%d_%H-%M-%S"))".log" 
PATHFILELOG=$PATHLOG$nameLogFile # Se obtiene el path con el nombre del archivo de log


if [  ! -d $PATHLOG ] # Si el directorio logs no existe lo crea
then
{
	mkdir $PATHLOG # Crea el directorio logs
}
fi

touch $PATHFILELOG # -> Creación del archivo de log

echo $(date +"%d-%m-%y %T") " | INFO | Se inicia el proceso de backup"  >> $PATHFILELOG # -> Entrada de log

PING=$(ping -c 4 $TARGETHOST) # Se realiza un ping con el file-server para validar el estado

if [[ $? != 0 ]] # Si el ping es diferente a 0, es decir, falla no se realiza el backup
then
{
	echo $(date +"%d-%m-%y %T") " | ERROR | Estado de host destino("$TARGETHOST"): offline"  >> $PATHFILELOG # -> Entrada de log
	echo -e "\nNo se encuentra online el file-server("$TARGETHOST"). Se cancela el proceso de backup.."
	echo $(date +"%d-%m-%y %T") " | INFO | Backup cancelado "  >> $PATHFILELOG # -> Entrada de log
}
else
{
	echo $(date +"%d-%m-%y %T") " | INFO | Estado de host destino("$TARGETHOST"): online"  >> $PATHFILELOG # -> Entrada de log
	rsync -athvz --delete --exclude=/.cache /media file-server:/media/disco_backups
	if [[ $? != 0 ]] # Si el comando rsync falla al realizar la transferencia
	then
	{
		echo $(date +"%d-%m-%y %T") " | ERROR | Error al realizar el backup con rsync" >> $PATHFILELOG # -> Entrada de log 
	}
	else
	{
		echo $(date +"%d-%m-%y %T") " | INFO | Se realizo el backup satisfactoriamente" >> $PATHFILELOG # -> Entrada de log
	}
	fi
}
fi
