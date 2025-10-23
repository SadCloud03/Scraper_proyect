# ------- Scraper ------

import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin
import time

url = 'https://books.toscrape.com/'
respuesta = requests.get(url)

soup = BeautifulSoup(respuesta.content, 'lxml')

etiqueta_categorias = soup.find('ul', class_='nav nav-list')

# ----- diccionario para guardar links segun categoria -----
category = {}

# ----- para todos los libros -----
link_all_books = url + etiqueta_categorias.a['href']
category['all books'] = link_all_books

# ----- por categorias -----
etiqueta_book_category = etiqueta_categorias.find('ul')
book_category = etiqueta_book_category.find_all('li')
for cat in book_category:
    nombre = cat.a.text.strip()
    link = cat.a['href']
    category[nombre] = url + link 

category_eleccion = input('categoria a visitar: ')

if category_eleccion in category:

    new_url = category[category_eleccion]
    new_response = requests.get(new_url)
    
    books = []

    while True:
        soup_new = BeautifulSoup(new_response.content, 'lxml')

        seleccion_of_books = soup_new.find('ol', class_='row')
        all_books_seleccion = seleccion_of_books.find_all('li')

        for book in all_books_seleccion:

            book_information = book.find('article', class_='product_pod')

            # ---- nombre del libro -----
            title = book_information.h3.a['title']

            # ---- precio del libro -----
            price_tag = book_information.find('div', class_='product_price')
            price = price_tag.find('p', class_='price_color').text

            # ---- disponibilidad del libro ----
            disponibility_tag = price_tag.find('p', class_='instock availability')
            disponibility = disponibility_tag.text.strip()

            # ----- cantidad de estrellas -----
            stars_tag = book_information.find('p', class_='star-rating')
            stars = stars_tag['class'][1] if stars_tag else 'not reviewd'

            # ----- descripcion -----
            description_place_tag_link = book_information.h3.a['href']
            description_place_tag_complete_link = urljoin(new_url, description_place_tag_link)
            description_response = requests.get(description_place_tag_complete_link)
            time.sleep(1.5)
            soup_description = BeautifulSoup(description_response.content, 'lxml')
            product_tag = soup_description.find('div', id='product_description')
            if product_tag:
                description = product_tag.find_next_sibling('p').text.strip()
                description = description.replace('\n', ' ').strip()
            else:
                description = 'No description'

            books.append({
                'title' : title,
                'stars' : stars,
                'price' : price,
                'stock' : disponibility,
                'description' : description
            })

        # ----- si hay mas de una pagina en el apartado -----
        next_tag = soup_new.find('li', class_='next')


        # ----- si hay volver a hacerel requests y trabajar con el siguiente HTML -----
        if next_tag:
            next_link = next_tag.a['href']
            new_url = urljoin(new_url, next_link)
            new_response = requests.get(new_url)
            time.sleep(1.5)

        else:
            break
    
# terminando esto todo eta en la lista Books -----> primera parte del scraper lista


