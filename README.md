# Iac InnovaRetail Corp

* ## Descripción

`Ante la necesidad de brindar una experiencia de usuario excepcional y facilitar la gestión interna, "InnovaRetail Corp." decide implementar una plataforma de comercio electrónico que incluya tanto la tienda en línea como un sistema de administración avanzado (CMS). Este sistema permitirá controlar múltiples vendedores o tiendas, gestionar productos, categorías, imágenes, filtros y publicidad de manera eficiente. El proyecto deberá demostrar una implementación ejemplar de prácticas DevOps, incluyendo la automatización de la infraestructura y procesos, estrategias de branching efectivas, seguridad a través de la gestión adecuada de secretos y una arquitectura robusta de microservicios.`

* ## Tecnologías usadas

    * Sistema de Pagos: [Stripe](https://stripe.com/es)
    * Atenticación: [Clerk](https://clerk.com)
    * Gestión de archivos: [Cloudinary](https://cloudinary.com)
    * Proveedor de Nube: [Azure](https://azure.microsoft.com/es-es)
    * Monitoreo : [Azure Monitor](https://azure.microsoft.com/es-es/products/monitor)
    * Código de la aplicación: [Repositorios](https://github.com/orgs/InnovaRetailCorp-Automatization/repositories)
    * Entrega Continua y Despliegue Continuo (CI-CD): [Azure Devops](https://azure.microsoft.com/es-es/products/devops)

* ## Requerimientos:
    * Sistema operativo con terraform, docker, minikube y kubectl instalado (de preferencia en linux):
        * [Instalar terraform en linux](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
        * [Instalar Terraform en Windows](https://learn.microsoft.com/es-es/azure/developer/terraform/get-started-windows-bash?tabs=bash) 

    * Azure Cli instalado con la sesión de azure iniciada, para esto se puede seguir la guía de [instalar azure-cli](https://learn.microsoft.com/es-es/cli/azure/install-azure-cli-linux?pivots=apt) de hashicorp
    * Archivo ````terraform.tfvars```` con los valores para las variables definidas en el archivo ````variables.tf````

* ## Pasos a seguir:

* Después de haber definido la IaC usando terraform, en el archivo [main](main.tf) podemos ver que contiene el llamado a los modulos de los recursos usados en el proyecto.

* El archivo [variables](variables.tf) contiene las definiciones de variables que serán utilizadas en los archivos de configuración de Terraform (como [main](main.tf), [outputs](outputs.tf), etc.). Estas variables pueden ser utilizadas para parametrizar la configuración de la infraestructura y permitir una mayor flexibilidad y reutilización del código.

* El archivo [terraform](terraform.tfvars) un archivo de variables específico de Terraform que se utiliza para definir valores específicos para las variables declaradas en los archivos de configuración de Terraform, como el archivo de [variables](variables.tf). Este archivo es opcional, pero es una práctica común para proporcionar valores específicos para las variables en lugar de especificarlos directamente en los comandos de Terraform o en otros archivos.

* ## Comandos

1. Preparar el directorio de trabajo para trabajar con terraform ````terraform init````
2. Validar la configuración de terraform ````terraform validate````
3. Validar y mostrar los cambios requeridos para aplicar la configuración de la infraestructura ````terraform plan````
4. Aplicar un formateo en el archivo de definición que se crea con terraform ````terraform fmt````
5. Crear la infraestructura ````terraform apply````
6. En caso de necesitar eliminar la infraestructura, se usa el comando ````terraform apply````

* ## Consideraciones

    * En caso de necesitar auto-hospedar un agente de azure para correr los pipelines sin el paralelismo que ofrece microsoft se debe usar esta [guía](https://learn.microsoft.com/es-es/azure/devops/pipelines/agents/windows-agent?view=azure-devops)

* ## Documentación

    * [Acta de acuerdo](https://icesiedu.sharepoint.com/:w:/s/AutomatizaciondelaInfraestructura2024-1/Ed0dURvUQXdIiUqBKd4570QBWgIoeSDa2uWOlMbX9vQsOg?e=1h347w)
    * [Actividades realizadas](https://www.notion.so/2ee2192ec9ed4c15beea39ba0815996b?v=91eb915a5729490eac4a348547756011&pvs=4)
    * [Presentacion del proyecto](https://icesiedu.sharepoint.com/:b:/s/AutomatizaciondelaInfraestructura2024-1/ES5IFLZ3tahDvzuKL6YjPh4BtJC7KSD2GIgPjzD0s8QD8w?e=13JQFg)
    * [Estimacion de costos](https://icesiedu.sharepoint.com/:x:/s/AutomatizaciondelaInfraestructura2024-1/EVVDdUvQi2FCk0tSwq5BdbIB31eDAGqAd6lPbs-6obmUGg?e=0pihLf)
    * [Requerimientos](https://icesiedu.sharepoint.com/:w:/s/AutomatizaciondelaInfraestructura2024-1/EQ-j478akcFLggLPWvyIYeQBz0WeLwM2RByWTsZN4siz1Q?e=dc0rRS)

* ## Funcionamiento de la App
    * [Solución integrando el recurso de Application Gateway](https://icesiedu-my.sharepoint.com/:v:/g/personal/1010159945_u_icesi_edu_co/EbJHrx6L8ENOvYcFZU-HRMwBrv3RKzjcrEbUScHuQkDXBg?e=y0QkHB)
    * [Solución sin el Application Gateway](https://icesiedu-my.sharepoint.com/:v:/g/personal/1010159945_u_icesi_edu_co/EVZi8_gChWFCtPwHCR7oNekBjEbU97GtLkbZsaePkh4vCA?e=P2i4PN)
