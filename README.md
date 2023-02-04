# Aprendizaje Automático Aplicado a Teoría de Control

Este proyecto tiene como objetivo estudiar la viabilidad de construir un emulador de un controlador MPC utilizando modelos de aprendizaje automático. La hipótesis es que los modelos de aprendizaje automático pueden ser más rápidos que los controladores MPC tradicionales, lo que los hace ideales para aplicaciones industriales.

## Herramientas

Este proyecto utiliza Matlab y Python para desarrollar el emulador de controlador MPC. En Matlab, se diseñó una planta de temperatura sencilla y se utilizó el controlador MPC para obtener los datos de entrenamiento para los modelos de aprendizaje automático. Los archivos "temperatura" y "simulinkTemperatura" contienen el código para dicho diseño.

En Python, se construyeron modelos de regresión lineal, SVM y redes neuronales para emular el controlador MPC. La información sobre estos modelos y los resultados se pueden encontrar en el archivo Jupyter Notebook llamado "ML-controler".

Por último, se generó un archivo en Matlab llamado "tiempos" para comparar el tiempo de ejecución del controlador MPC con los modelos de aprendizaje automático.

## Requisitos
Para ejecutar este proyecto, es necesario tener instalados Matlab y Python, así como las siguientes bibliotecas de Python:

* NumPy
* Pandas
* scikit-learn
* TensorFlow

## Contribución
Si desea contribuir a este proyecto, por favor abra una solicitud de pull o envíe un correo electrónico a drambaut.

## Créditos
Agradecemos a todas las personas y recursos que contribuyeron al desarrollo de tu proyecto.
