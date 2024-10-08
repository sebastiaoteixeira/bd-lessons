# BD: Guião 6

## Problema 6.1

### *a)* Todos os tuplos da tabela autores (authors);

```
SELECT * 
    FROM authors;
```

### *b)* O primeiro nome, o último nome e o telefone dos autores;

```
SELECT authors.au_fname, authors.au_lname, authors.phone
    FROM authors;
```

### *c)* Consulta definida em b) mas ordenada pelo primeiro nome (ascendente) e depois o último nome (ascendente); 

```
SELECT authors.au_fname, authors.au_lname, authors.phone
    FROM authors
ORDER BY authors.au_fname, authors.au_lname;
```

### *d)* Consulta definida em c) mas renomeando os atributos para (first_name, last_name, telephone); 

```
SELECT authors.au_fname AS first_name, authors.au_lname AS last_name, authors.phone AS telephone
    FROM authors
ORDER BY authors.au_fname, authors.au_lname;
```

### *e)* Consulta definida em d) mas só os autores da Califórnia (CA) cujo último nome é diferente de ‘Ringer’; 

```
SELECT authors.au_fname AS first_name, authors.au_lname AS last_name, authors.phone AS telephone
    FROM authors
WHERE authors.state = 'CA' AND authors.au_lname != 'Ringer'
ORDER BY authors.au_fname, authors.au_lname;
```

### *f)* Todas as editoras (publishers) que tenham ‘Bo’ em qualquer parte do nome; 

```
SELECT *
FROM publishers
WHERE publishers.pub_name LIKE '%Bo%';
```

### *g)* Nome das editoras que têm pelo menos uma publicação do tipo ‘Business’; 

```
SELECT *
FROM publishers
WHERE publishers.pub_name LIKE '%Bo%';
```

### *h)* Número total de vendas de cada editora; 

```
SELECT publishers.pub_name, SUM(sales.qty) AS total_sales
FROM publishers
JOIN titles
ON publishers.pub_id = titles.pub_id
JOIN sales
ON titles.title_id = sales.title_id
GROUP BY publishers.pub_name;
```

### *i)* Número total de vendas de cada editora agrupado por título; 

```
SELECT publishers.pub_name, titles.title, SUM(sales.qty) AS total_sales
FROM publishers
JOIN titles
ON publishers.pub_id = titles.pub_id
JOIN sales
ON titles.title_id = sales.title_id
GROUP BY publishers.pub_name, titles.title
```

### *j)* Nome dos títulos vendidos pela loja ‘Bookbeat’; 

```
SELECT stores.stor_name AS store, titles.title
FROM sales
JOIN stores
ON sales.stor_id = stores.stor_id
JOIN titles
ON sales.title_id = titles.title_id
WHERE stores.stor_name = 'Bookbeat';
```

### *k)* Nome de autores que tenham publicações de tipos diferentes; 

```
SELECT authors.au_id, authors.au_lname, authors.au_fname
FROM authors
JOIN
(
    SELECT titleauthor.au_id AS au_id, COUNT(titles.type) AS type_count
    FROM titles
    JOIN titleauthor
    ON titles.title_id = titleauthor.title_id
    GROUP BY titleauthor.au_id
) AS title_count
ON authors.au_id = title_count.au_id
WHERE type_count > 1;
```

### *l)* Para os títulos, obter o preço médio e o número total de vendas agrupado por tipo (type) e editora (pub_id);

```
SELECT pub_name, sales_info.type, total_sales, average_price
FROM publishers
JOIN (
    SELECT titles.pub_id, titles.type, SUM(sales.qty) AS total_sales, AVG(titles.price) AS average_price
    FROM sales
    JOIN titles
    ON titles.title_id = sales.title_id
    GROUP BY titles.type, titles.pub_id
) AS sales_info
ON publishers.pub_id = sales_info.pub_id
ORDER BY sales_info.type, pub_name;
```

### *m)* Obter o(s) tipo(s) de título(s) para o(s) qual(is) o máximo de dinheiro “à cabeça” (advance) é uma vez e meia superior à média do grupo (tipo);

```
SELECT titles.title, titles.advance, type_avg_advances.avg_advance
FROM titles
JOIN (
    SELECT titles.type, AVG(same_type_titles.advance) AS avg_advance
    FROM titles
    JOIN (
        SELECT titles.type AS this_type, titles.advance AS advance
        FROM titles
    ) AS same_type_titles
    ON titles.type = same_type_titles.this_type
    GROUP BY titles.type
) AS type_avg_advances
ON titles.type = type_avg_advances.type
WHERE titles.advance > 1.5 * type_avg_advances.avg_advance;
```

### *n)* Obter, para cada título, nome dos autores e valor arrecadado por estes com a sua venda;

```
SELECT authors.au_lname, authors.au_fname, titles.title, sales_info.total
FROM authors
JOIN
(
    SELECT titleauthor.au_id, titles.title_id, SUM(sales.qty) AS total
    FROM titles
    JOIN titleauthor
    ON titles.title_id = titleauthor.title_id
    JOIN sales
    ON titles.title_id = sales.title_id
    GROUP BY titleauthor.au_id, titles.title_id
) AS sales_info
ON authors.au_id = sales_info.au_id
JOIN titles
ON sales_info.title_id = titles.title_id
```

### *o)* Obter uma lista que incluía o número de vendas de um título (ytd_sales), o seu nome, a faturação total, o valor da faturação relativa aos autores e o valor da faturação relativa à editora;

```
SELECT title, ytd_sales, faturacao_total, (faturacao_total * royalty / 100 + advance) AS faturacao_autor, (faturacao_total * (100 - royalty) / 100 - advance) AS faturacao_editora
FROM (
    SELECT titles.title, titles.ytd_sales, titles.price, (titles.price * titles.ytd_sales) AS faturacao_total, titles.advance, titles.royalty
    FROM titles
) AS subquery
```

### *p)* Obter uma lista que incluía o número de vendas de um título (ytd_sales), o seu nome, o nome de cada autor, o valor da faturação de cada autor e o valor da faturação relativa à editora;

```
SELECT title_sales, title, author_name, (faturacao_autores * royalty_autor / 100) AS faturacao_autor, faturacao_editora
FROM (
    SELECT title, CONCAT(authors.au_fname,' ',authors.au_lname) AS author_name, title_sales, titleauthor.royaltyper AS royalty_autor, (faturacao_total * royalty / 100 + advance) AS faturacao_autores, (faturacao_total * (100 - royalty) / 100 - advance) AS faturacao_editora
    FROM (
        SELECT titles.title_id, titles.title, titles.ytd_sales as title_sales, titles.price, (titles.price * titles.ytd_sales) AS faturacao_total, titles.advance, titles.royalty
        FROM titles
    ) AS subquery
    JOIN titleauthor ON subquery.title_id = titleauthor.title_id
    JOIN authors ON titleauthor.au_id = authors.au_id
) AS subquery2
ORDER BY title
```

### *q)* Lista de lojas que venderam pelo menos um exemplar de todos os livros;

```
SELECT stores.stor_name
FROM stores
WHERE stores.stor_id NOT IN
(
    SELECT stores_sales.stor_id
    FROM 
    (
        SELECT sales.stor_id, titles.title_id
        FROM sales, titles
        
    ) AS all_stor_title_pairs
    LEFT JOIN
    (
        SELECT stores.stor_id, sales.title_id
        FROM sales
        JOIN stores
        ON stores.stor_id=sales.stor_id
        WHERE qty > 0
    ) AS stores_sales
    ON all_stor_title_pairs.title_id=stores_sales.title_id AND all_stor_title_pairs.stor_id=stores_sales.stor_id
    WHERE stores_sales.stor_id IS NULL
)
```

### *r)* Lista de lojas que venderam mais livros do que a média de todas as lojas;

```
SELECT store_sales_subquery.store_name, store_sales_subquery.store_sales
FROM (
    SELECT stores.stor_name AS store_name, SUM(sales.qty) AS store_sales
    FROM stores
    JOIN sales
    ON stores.stor_id = sales.stor_id
    GROUP BY stores.stor_id, stores.stor_name
) AS store_sales_subquery
JOIN (
    SELECT AVG(store_sales) AS avg_sales
    FROM (
        SELECT stores.stor_name AS store_name, SUM(sales.qty) AS store_sales
        FROM stores
        JOIN sales
        ON stores.stor_id = sales.stor_id
        GROUP BY stores.stor_id, stores.stor_name
    ) AS inner_subquery
) AS avg_sales_subquery
ON store_sales_subquery.store_sales > avg_sales_subquery.avg_sales
```

### *s)* Nome dos títulos que nunca foram vendidos na loja “Bookbeat”;

```
SELECT title
FROM titles
WHERE title_id NOT IN (
    SELECT sales.title_id
    FROM sales
    JOIN stores
    ON sales.stor_id = stores.stor_id
    WHERE stores.stor_name = 'Bookbeat'
)
```

### *t)* Para cada editora, a lista de todas as lojas que nunca venderam títulos dessa editora; 

```
SELECT publishers.pub_name, stores.stor_name
FROM publishers
CROSS JOIN stores
WHERE NOT EXISTS (
    SELECT *
    FROM sales
    JOIN titles
    ON sales.title_id = titles.title_id
    WHERE titles.pub_id = publishers.pub_id AND sales.stor_id = stores.stor_id
)
ORDER BY publishers.pub_name, stores.stor_name
```

## Problema 6.2

### ​5.1

#### a) SQL DDL Script
 
[a) SQL DDL File](ex_6_2_1_ddl.sql "SQLFileQuestion")

#### b) Data Insertion Script

[b) SQL Data Insertion File](ex_6_2_1_data.sql "SQLFileQuestion")

#### c) Queries

##### *a)*

```
SELECT employee.Ssn, employee.Fname, project.Pname
FROM works_on
JOIN project ON works_on.Pno = project.Pnumber
JOIN employee ON works_on.Essn = employee.Ssn;
```

##### *b)* 

```
SELECT employee.Fname, employee.Minit, employee.Lname
FROM employee
INNER JOIN employee AS Chefe ON employee.Super_ssn = Chefe.Ssn
WHERE Chefe.Fname = 'Carlos' AND Chefe.Minit = 'D' AND Chefe.Lname = 'Gomes';
```

##### *c)* 

```
SELECT project.Pname, SUM(works_on.Hours) AS workedHours
FROM project
JOIN works_on ON works_on.Pno = project.Pnumber
GROUP BY project.Pname;
```

##### *d)* 

```
SELECT employee.Fname, employee.Minit, employee.Lname
FROM employee
JOIN works_on ON employee.Ssn = works_on.Essn
JOIN project ON works_on.Pno = project.Pnumber
WHERE works_on.Hours > 20
AND employee.Dno = 3
AND project.Pname = 'Aveiro Digital';
```

##### *e)* 

```
SELECT employee.Fname, employee.Minit, employee.Lname
FROM employee
LEFT JOIN works_on ON employee.Ssn = works_on.Essn
WHERE works_on.Essn IS NULL;
```

##### *f)* 

```
SELECT department.Dnumber, department.Dname, AVG(works_on.Hours) AS averageHours 
FROM employee 
JOIN department ON department.Dnumber = employee.Dno 
JOIN works_on ON employee.Ssn = works_on.Essn 
WHERE employee.Sex = 'F' 
GROUP BY department.Dnumber, department.Dname;
```

##### *g)* 

```
SELECT employee.Fname, employee.Minit, employee.Lname, depCounts.numDependents
FROM employee
LEFT JOIN (
    SELECT dependent.Essn, COUNT(dependent.Dependent_name) AS numDependents
    FROM dependent
    GROUP BY dependent.Essn
) AS depCounts ON employee.Ssn = depCounts.Essn
WHERE depCounts.numDependents IS NOT null;
```

##### *h)* 

```
SELECT DISTINCT employee.Fname, employee.Minit, employee.Lname
FROM employee
JOIN department ON employee.Ssn = department.Mgr_ssn
LEFT JOIN dependent ON employee.Ssn = dependent.Essn
WHERE dependent.Essn IS NULL;
```

##### *i)* 

```
SELECT employee.Fname, employee.Minit, employee.Lname, employee.Address
FROM employee
JOIN works_on ON employee.Ssn = works_on.Essn
JOIN project ON works_on.Pno = project.Pnumber AND project.Plocation = 'Aveiro'
JOIN department ON employee.Dno = department.Dnumber
JOIN dept_location ON department.Dnumber = dept_location.Dnumber
WHERE dept_location.Dlocation != 'Aveiro';
```

### 5.2

#### a) SQL DDL Script
 
[a) SQL DDL File](ex_6_2_2_ddl.sql "SQLFileQuestion")

#### b) Data Insertion Script

[b) SQL Data Insertion File](ex_6_2_2_data.sql "SQLFileQuestion")

#### c) Queries

##### *a)*

```
SELECT fornecedor.nif, fornecedor.nome
FROM fornecedor
LEFT JOIN encomenda ON fornecedor.nif = encomenda.fornecedor
WHERE encomenda.numero IS NULL;
```

##### *b)* 

```
SELECT produto.codigo, produto.nome, AVG(produto.unidades) AS averageUnidades
FROM produto
GROUP BY produto.codigo, produto.nome;
```


##### *c)* 

```
SELECT AVG(quantidade) AS average
FROM (
    SELECT item.numEnc, COUNT(item.codProd) AS quantidade
    FROM item
    GROUP BY item.numEnc
) AS quantityPerNumEnc;
```


##### *d)* 

```
SELECT fornecedor.nome, produto.nome, SUM(item.unidades) AS quantidade
FROM item
JOIN encomenda ON item.numEnc = encomenda.numero
JOIN produto ON item.codProd = produto.codigo
JOIN fornecedor ON encomenda.fornecedor = fornecedor.nif
GROUP BY fornecedor.nome, produto.nome;
```

### 5.3

#### a) SQL DDL Script
 
[a) SQL DDL File](ex_6_2_3_ddl.sql "SQLFileQuestion")

#### b) Data Insertion Script

[b) SQL Data Insertion File](ex_6_2_3_data.sql "SQLFileQuestion")

#### c) Queries

##### *a)*

```
SELECT paciente.nome
FROM paciente
LEFT JOIN prescricao ON paciente.numUtente = prescricao.numUtente
WHERE prescricao.numPresc IS NULL;
```

##### *b)* 

```
SELECT medico.especialidade, COUNT(prescricao.numPresc) AS numPrescricoes
FROM medico
JOIN prescricao ON medico.numSNS = prescricao.numMedico
GROUP BY medico.especialidade;
```


##### *c)* 

```
SELECT prescricao.farmacia, COUNT(prescricao.farmacia) AS numPrescricoes
FROM medico
JOIN prescricao ON medico.numSNS = prescricao.numMedico
WHERE prescricao.farmacia IS NOT NULL
GROUP BY prescricao.farmacia;
```


##### *d)* 

```
SELECT farmaco.nome, farmaco.formula
FROM farmaco
JOIN farmaceutica ON farmaco.numRegFarm = farmaceutica.numReg
WHERE farmaceutica.numReg != 906;
```

##### *e)* 

```
SELECT farmacia.nome, farmaceutica.nome, COUNT(farmaco.nome) AS vendas
FROM farmaco
JOIN presc_farmaco ON presc_farmaco.numRegFarm = farmaco.numRegFarm AND presc_farmaco.nomeFarmaco = farmaco.nome
JOIN prescricao ON prescricao.numPresc = presc_farmaco.numPresc
JOIN farmacia ON prescricao.farmacia = farmacia.nome
JOIN farmaceutica ON farmaco.numRegFarm = farmaceutica.numReg
GROUP BY farmacia.nome, farmaco.numRegFarm, farmaceutica.nome;
```

##### *f)* 

```
SELECT DISTINCT paciente.*
FROM paciente
JOIN (
    SELECT prescricao.numUtente, COUNT(prescricao.numMedico) AS medicos
    FROM prescricao
    GROUP BY prescricao.numUtente
) AS subquery ON paciente.numUtente = subquery.numUtente
WHERE subquery.medicos >= 2;
```
