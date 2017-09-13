main=/etc/postfix/main.cf
sasl=/etc/postfix/sasl_passwd

sudo echo -n || exit 2

read -p "Correo de Gmail : $(tput setaf 2)" -e correo
echo -n "$(tput sgr0)"
read -p "Contraseña de correo : $(tput setaf 2)" -s password
echo -n "$(tput sgr0)"

if grep -qx "mail_owner.*" $main ; then
sudo cat $main | sudo perl -pi -e 's/mail_owner.*/mail_owner = _postfix/g' $main

else
	echo "mail_owner = _postfix" | sudo tee -a $main
	echo "Línea agregada"
fi

if grep -qx "setgid_group.*" $main ; then
sudo cat $main | sudo perl -pi -e 's/setgid_group.*/setgid_group = _postdrop/g' $main

else
	echo "setgid_group = _postdrop" | sudo tee -a $main
	echo "Línea agregada"
fi

if grep -qx "relayhost=.*" $main ; then
sudo cat $main | sudo perl -pi -e 's/relayhost=.*/relayhost=smtp.gmail.com:587/g' $main

else
	echo "relayhost=smtp.gmail.com:587" | sudo tee -a $main
	echo "Línea agregada"
fi

if grep -qx "smtp_sasl_auth_enable.*" $main ; then
sudo cat $main | sudo perl -pi -e 's/smtp_sasl_auth_enable.*/smtp_sasl_auth_enable=yes/g' $main

else
	echo "smtp_sasl_auth_enable=yes" | sudo tee -a $main
	echo "Línea agregada"
fi

if grep -qx "smtp_sasl_password_maps.*" $main ; then
sudo cat $main | sudo perl -pi -e 's/smtp_sasl_password_maps.*/smtp_sasl_password_maps=hash:\/etc\/postfix\/sasl_passwd/g' $main

else
	echo "smtp_sasl_password_maps=hash:\/etc\/postfix\/sasl_passwd" | sudo tee -a $main
	echo "Línea agregada"
fi

if grep -qx "smtp_sasl_security_options.*" $main ; then
sudo cat $main | sudo perl -pi -e 's/smtp_sasl_security_options.*/smtp_sasl_security_options=noanonymous/g' $main

else
	echo "smtp_sasl_security_options=noanonymous" | sudo tee -a $main
	echo "Línea agregada"
fi

if grep -qx "smtp_sasl_mechanism_filter.*" $main ; then
sudo cat $main | sudo perl -pi -e 's/smtp_sasl_mechanism_filter.*/smtp_sasl_mechanism_filter=plain/g' $main

else
	echo "smtp_sasl_mechanism_filter=plain" | sudo tee -a $main
	echo "Línea agregada"
fi

if grep -qx "smtp_use_tls.*" $main ; then
sudo cat $main | sudo perl -pi -e 's/smtp_use_tls.*/smtp_use_tls=yes/g' $main

else
	echo "smtp_use_tls=yes" | sudo tee -a $main
	echo "Línea agregada"
fi

if grep -qx "smtp_tls_security_level.*" $main ; then
sudo cat $main | sudo perl -pi -e 's/smtp_tls_security_level.*/smtp_tls_security_level=encrypt/g' $main

else
	echo "smtp_tls_security_level=encrypt" | sudo tee -a $main
	echo "Línea agregada"
fi

if grep -qx "tls_random_source.*" $main ; then
sudo cat $main | sudo perl -pi -e 's/tls_random_source.*/tls_random_source=dev:\/dev\/urandom/g' $main

else
	echo "tls_random_source=dev:\/dev\/urandom" | sudo tee -a $main
	echo "Línea agregada"
fi

##Otras configuraciones útiles no se si funcionarian...
##Hotmail SMTP
#relayhost=smtp.live.com:587
##Yahoo SMTP
#relayhost=smtp.mail.yahoo.com:465
##Gmail
#smtp.gmail.com:587
##Outlook
#relayhost=smtp.live.com:587

if sudo grep -qx "smtp.*" $sasl ; then
sudo cat $sasl | sudo perl -pi -e "s/smtp.*//g" $sasl && echo "smtp.gmail.com:587 $correo:$password" | sudo tee -a $sasl >/dev/null
sudo sed '/^$/d' /etc/postfix/sasl_passwd >/dev/null
else
	echo "smtp.gmail.com:587 $correo:$password" | sudo tee -a $sasl >/dev/null
	sudo sed '/^$/d' /etc/postfix/sasl_passwd >/dev/null
	echo "Línea agregada"
fi

##Cargando configuraciones

sudo postmap /etc/postfix/sasl_passwd >/dev/null
echo
sudo postfix start 2>/dev/null
sudo postfix reload >/dev/null

echo "Configuración de correo finalizada para $correo" | grep $correo