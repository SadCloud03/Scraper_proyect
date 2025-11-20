-- practicas de consultas:


-- 1er ejercicio (Listar todos los libros con su categoria y autor
SELECT 
    Libro.title AS Libro,
    Categoria.name AS Categoria,
    Autor.author AS Autor
FROM
    Libro
JOIN Categoria ON Categoria.id_category = Libro.id_category
JOIN LibroAutor ON LibroAutor.id_book = Libro.id_book
JOIN Autor ON Autor.id_author = LibroAutor.id_author;

-- 2do ejercicio (contar cuantos autores hay por categoria)
-- SELECT
--     Categoria.name,
--     COUNT(DISTINCT Autor.author) AS autoresCategoria
-- FROM
--     Categoria
-- JOIN Libro ON Libro.id_category = Categoria.id_category
-- JOIN LibroAutor ON Libro.id_book = LibroAutor.id_book
-- JOIN Autor ON Autor.id_author = LibroAutor.id_author
-- GROUP BY Categoria.name 
-- ORDER BY autoresCategoria DESC LIMIT 10;

--3er ejercicio (contar libros por autor)
-- SELECT 
--     Autor.author AS autor,
--     COUNT(DISTINCT Libro.id_book) AS CantidadLibros
-- FROM   
--     Autor
-- JOIN LibroAutor ON LibroAutor.id_author = Autor.id_author
-- JOIN Libro ON Libro.id_book = LibroAutor.id_book
-- GROUP BY autor
-- ORDER BY CantidadLibros DESC;

--4to ejercicio (Contar libros y autores totales)
-- SELECT 
--     COUNT(DISTINCT libro.id_book) AS cantidad_libros,
--     COUNT(DISTINCT Autor.id_author) AS cantidad_autores
-- FROM    
--     Libro
-- JOIN LibroAutor ON LibroAutor.id_book = Libro.id_book
-- JOIN Autor ON Autor.id_author = LibroAutor.id_author


--5to ejercicio (Mostrar los libros que tengan mas de un autor)
-- SELECT 
--     Libro.title AS libro,
--     COUNT(LibroAutor.id_author) AS cantidad_autores
-- FROM 
--     Libro
-- JOIN LibroAutor ON Libro.id_book = LibroAutor.id_book
-- GROUP BY Libro.id_book 
-- HAVING COUNT(LibroAutor.id_author) > 1;

--6to ejercicio (mostrar libros sin autores definidos)
-- SELECT
--     Libro.title AS libro,
--     Autor.author AS Confirmacion_Autor
-- FROM 
--     Libro
-- JOIN LibroAutor ON LibroAutor.id_book = Libro.id_book
-- JOIN Autor ON Autor.id_author = LibroAutor.id_author
-- WHERE Confirmacion_Autor = 'desconocido'
-- GROUP BY libro;

--7mo ejercicio (mostrar libros con stock disponible)
-- SELECT 
--     Libro.title AS libro,
--     Libro.stock AS confirmation
-- FROM 
--     libro 
-- WHERE
--     Libro.stock LIKE '%In stock%';

--8vo ejercicio (Libros con rating mayor a X)
-- SELECT 
--     Libro.title AS libro,
--     Libro.stars AS rating
-- FROM 
--     Libro 
-- WHERE Libro.stars > 3;

--9no ejercicio (mostrar categorias que no tienen libros Asociados)
-- SELECT  
--     Categoria.name AS categoria,
--     COUNT(DISTINCT Libro.id_book) AS cantidad_libros
-- FROM 
--     Categoria
--     LEFT JOIN Libro ON Libro.id_category = Categoria.id_category
-- WHERE Libro.id_book IS NULL

--10 ejercicio (Libros y cantidad de autores por libro)
-- SELECT 
--     Libro.title AS libro,
--     COUNT(LibroAutor.id_author) AS cantidad_Autores
-- FROM 
--     Libro
--     JOIN LibroAutor ON LibroAutor.id_book = Libro.id_book
-- GROUP BY Libro.id_book
-- ORDER BY cantidad_Autores DESC

--Nivel 1 (subconsultas basicas)

--1er ejercicio (mostrar los libros que tienen mas autores que el promedio de libros)
-- SELECT 
--     Libro.title AS libro,
--     COUNT(LibroAutor.id_author) AS TotalAutores
-- FROM 
--     Libro
--     JOIN LibroAutor ON LibroAutor.id_book = Libro.id_book
-- GROUP BY 
--     Libro.id_book
-- HAVING 
--     COUNT(LibroAutor.id_author) > (
--         SELECT 
--             AVG(cantidad_autores)
--         FROM (
--             SELECT
--                 COUNT(LibroAutor.id_author) AS cantidad_autores
--             FROM
--                 LibroAutor
--             GROUP BY
--                 LibroAutor.id_book
--         )
--     );

--2do ejercicio (Obtener los autores que escribieron mas libros que el promedio general de libros por autor)
-- SELECT 
--     Autor.author AS autor,
--     COUNT(LibroAutor.id_book) AS cantidadLibros
-- FROM 
--     Autor
--     JOIN LibroAutor ON LibroAutor.id_author = Autor.id_author
-- GROUP BY 
--     Autor.id_author
-- HAVING
--     COUNT(LibroAutor.id_book) > (
--         SELECT 
--             AVG(libros_por_autor)
--         FROM (
--             SELECT 
--                 COUNT(LibroAutor.id_book) AS libros_por_autor
--             FROM 
--                 LibroAutor
--             GROUP BY
--                 LibroAutor.id_author
--         ) AS where_from
--     );

--3er ejercicio (listar los libros cuyo numero de autores es igual al libro "colaborativo" (el que tiene mas autores)
-- SELECT
--     Libro.title,
--     COUNT(DISTINCT LibroAutor.id_author) AS CantidadAutores
-- FROM    
--     Libro
--     JOIN LibroAutor ON LibroAutor.id_book = Libro.id_book
-- GROUP BY Libro.id_book
-- HAVING 
--     COUNT(DISTINCT LibroAutor.id_author) = (
--         SELECT 
--             MAX(CantidadAutores)
--         FROM 
--             (SELECT 
--                 COUNT( DISTINCT LibroAutor.id_author) AS CantidadAutores
--             FROM 
--                 LibroAutor
--             GROUP BY
--                 LibroAutor.id_book
--         ) AS MaxAutoresLibro
--     );

