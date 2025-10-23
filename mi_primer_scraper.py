import requests
from bs4 import BeautifulSoup

# ------ Crear conexion con bookstoscrape -----
url = 'https://books.toscrape.com/'
respuesta = requests.get(url)
soup = BeautifulSoup(respuesta.content, 'lxml')

# ----- encontrar las categorias -----
div_categoria = soup.find('ul', class_='nav nav-list')
link_all_books = url + div_categoria.a['href']
list_books = div_categoria.find('ul')
books = list_books.find_all('li')

# ----- Crear lista de las categorias -----
categorias = {}

# ----- Agregar a la lista link a todos los libros -----
categorias['all books'] = link_all_books

# ----- Agregar todas la categorias -----
for categoria in books:
    nombre = categoria.a.text.strip()
    link = categoria.a['href']
    categorias[nombre] = url + link


# ------ Eleccion de categoria a revisar para que no explote la compu o me hechen de la paginas -----
print('----Categorias Disponibles----\n')
for x, _ in categorias.items():
    print(x)
    

# ----- Ingreso al apartado en la pagina para reducir area de busqueda de libros -----
eleccion = input('\nQue categoria le gustaria visitar: ')
if eleccion in categorias:

    url_eleccion = categorias[eleccion]
    respuesta_eleccion = requests.get(url_eleccion)
    
    while True:
        # ----- busque de conexion -----
        soup_eleccion = BeautifulSoup(respuesta_eleccion.content, 'lxml')

        libros = soup_eleccion.find_all('article', class_='product_pod')
        
        print("\n----Libros Disponibles----\n")
        for libro in libros:
            titulo = libro.h3.a['title']
            estrellas_etiqueta = libro.find('p', class_='star-rating')
            puntuacion = estrellas_etiqueta['class'][1] if estrellas_etiqueta else 'sin clasificar'
            print(f"Titulo: {titulo} \nEstrellas: {puntuacion} \n")

        etiqueta_next = soup_eleccion.find('li', class_='next')

        if etiqueta_next:
            siguiente = etiqueta_next.a['href']
            url_eleccion = '/'.join(url_eleccion.split('/')[:-1]) + '/' + siguiente
            respuesta_eleccion = requests.get(url_eleccion)
            decision = input('quieres ir a la siguiente pagina: (y/n) ')
            if decision.lower() != 'y':
                break
        
        else:
            break
    # ubiucacion_libros = soup_eleccion.find('ol', class_='row')
    # ubicacion_titulos = ubiucacion_libros.find_all('h3')

    # titulos = {}
    # for libro in ubicacion_titulos:
    #     titulo = libro.a['title']
        
    #     print('-',titulo)




