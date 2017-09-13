clear && echo -n "$(tput setaf 9)" && echo '

███████╗ █████╗ ███████╗██╗   ██╗    ███╗   ███╗ █████╗ ██╗██╗     ██╗  ██╗
██╔════╝██╔══██╗██╔════╝╚██╗ ██╔╝    ████╗ ████║██╔══██╗██║██║     ╚██╗██╔╝
█████╗  ███████║███████╗ ╚████╔╝     ██╔████╔██║███████║██║██║      ╚███╔╝ 
██╔══╝  ██╔══██║╚════██║  ╚██╔╝      ██║╚██╔╝██║██╔══██║██║██║      ██╔██╗ 
███████╗██║  ██║███████║   ██║       ██║ ╚═╝ ██║██║  ██║██║███████╗██╔╝ ██╗
╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝       ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚══════╝╚═╝  ╚═╝'
echo "$(tput sgr0)"
echo "Para finalizar el mensaje presione las teclas Enter y luego Control + D
Para dejar un campo vacio presione la tecla Enter.
"

echo -ne "Escriba su mensaje: $(tput setaf 2)"
mensaje=$(</dev/stdin)
echo -n "$(tput sgr0)"
read -p "Recipiente ID-USUARIO GPG: $(tput setaf 2)" -e recipiente
echo -n "$(tput sgr0)"
read -p "Destinatario: $(tput setaf 2)" -e receptor
echo -n "$(tput sgr0)"
read -p "Asunto: $(tput setaf 2)" -e asunto
echo -n "$(tput sgr0)"
read -p "Con copia a: $(tput setaf 2)" -e copia
echo -n "$(tput sgr0)"
read -p "Con copia oculta a: $(tput setaf 2)" -e copiaoculta
echo -n "$(tput sgr0)"


if [ -z $receptor ] ; then
	echo "" && echo "Se requiere un receptor para enviar un correo, saliendo...
	" && exit 2
elif [[ ! -z $copia && -z $recipiente && -z $copiaoculta ]] ; then
	echo $mensaje | mail -s "$asunto" -c "$copia" "$receptor"
elif [[ ! -z $copiaoculta && -z $recipiente && -z $copia ]] ; then
	echo $mensaje | mail -s "$asunto" -b "$copiaoculta" "$receptor"
elif [[ ! -z $copia && ! -z $copiaoculta && -z $recipiente ]] ; then
	echo $mensaje | mail -s "$asunto" -c "$copia" -b "$copiaoculta" "$receptor"
elif [[ -z $copia && -z $copiaoculta && -z $recipiente ]] ; then
	echo $mensaje | mail -s "$asunto" "$receptor"
fi

if [[ ! -z $copia && ! -z $recipiente && -z $copiaoculta ]] ; then
	echo $mensaje | gpg -ea -r "$recipiente" | mail -s "$asunto" -c "$copia" "$receptor"
elif [[ ! -z $copiaoculta && ! -z $recipiente && -z $copia ]] ; then
	echo $mensaje | gpg -ea -r "$recipiente" | mail -s "$asunto" -b "$copiaoculta" "$receptor"
elif [[ ! -z $copia && ! -z $copiaoculta && ! -z $recipiente ]] ; then
	echo $mensaje | gpg -ea -r "$recipiente" | mail -s "$asunto" -c "$copia" -b "$copiaoculta" "$receptor"
elif [[ -z $copia && -z $copiaoculta && ! -z $recipiente ]] ; then
	echo $mensaje | gpg -ea -r "$recipiente" | mail -s "$asunto" "$receptor"
fi

hora=$(date +"%T")
echo ""
echo "Mensaje enviado con éxito a las $hora.
"
