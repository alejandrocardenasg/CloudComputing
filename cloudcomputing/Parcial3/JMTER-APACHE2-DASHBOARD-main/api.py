import os
import time

while True: 

    try:
        """

        """
        os.system("sudo rm -fr /var/www/html/metricas/*")
        os.system("sudo rm -fr /usr/local/jmeter/pruebas/logs/*")

        os.system("/usr/local/jmeter/bin/jmeter -n -t /usr/local/jmeter/pruebas/parcial1.jmx -l /usr/local/jmeter/pruebas/logs/registro_pruebas.log -e -o /var/www/html/metricas/")
        print("Listo")
        time.sleep(180)


    except Exception: 

        print("Vacío")

    except KeyboardInterrupt:

        print('Hello user you have pressed ctrl-c button.')
        break
