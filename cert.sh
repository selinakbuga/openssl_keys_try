#!/bin/bash
directory=~/logkeys

cert_create ()
{
	echo -e -n "\e[93m [log toplamak için sertifika oluşturmak istiyor musunuz? (Ee/Hh) ] **************** \e[0m"
	read cevap
		if [ ! "$cevap" = "${cevap#[Hh]}" ] ; then
			exit
		elif [ ! "$cevap" = "${cevap#[Ee]}" ] ; then
		echo -e -n "\e[93m [kaç sunucu için sertifika oluşturmak istiyorsunuz? (örn:2) ] **************** \e[0m"
		read tekrar_sayi
			for  ((dongu=1; dongu<=$tekrar_sayi; dongu++))
			do
				echo -e -n "\e[93m [log toplamak istediğiniz cihazın fqdn bilgisini giriniz.] ********** \e[0m"
				read client
				openssl genrsa -out $directory/$client.key 2048
				openssl req -new -key $directory/$client.key -out $directory/$client.csr
				openssl x509 -req -in $directory/$client.csr -CA $directory/rootCA.pem -CAkey $directory/rootCA.key -CAcreateserial -out $directory/$client.crt -days 3650 -sha256
			done
		else
		echo -e -n "\e[93m [Geçersiz değer girdiniz.(Ee/Hh) ] **************** \e[0m"
		fi
}
rm -rf $directory/*
openssl genrsa -out $directory/rootCA.key 2048
openssl req -x509 -new -nodes -key $directory/rootCA.key -sha256 -days 1024 -out $directory/rootCA.pem
echo -e -n "\e[93m [log toplamak için sertifika oluşturmak istiyor musunuz? (Ee/Hh) ] **************** \e[0m"
read cevap
cert_create
