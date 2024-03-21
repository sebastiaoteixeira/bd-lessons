# BD: Guião 5


## ​Problema 5.1
 
### *a)*

```
π employee.Ssn,employee.Fname,project.Pname
(
    works_on
        ⨝ works_on.Pno=project.Pnumber
    project
        ⨝ works_on.Essn=employee.Ssn 
    employee
)
```


### *b)* 

```
... Write here your answer ...
```


### *c)* 

```
γ project.Pname; sum(Hours) -> workedHours
(
    project 
        ⨝ works_on.Pno=project.Pnumber
    works_on
)
```


### *d)* 

```
... Write here your answer ...
```


### *e)* 

```
σ works_on.Essn=null
(
    employee 
        ⟕employee.Ssn=works_on.Essn 
    works_on
)
```


### *f)* 

```
γ department.Dnumber,department.Dname; avg(Hours) -> averageHours
(
	σ employee.Sex='F'
	(
		employee
		⨝department.Dnumber=employee.Dno
		department
	)
	⨝employee.Ssn=works_on.Essn works_on
)
```


### *g)* 

```
... Write here your answer ...
```


### *h)* 

```
π employee.Fname,employee.Minit,employee.Lname
σ dependent.Essn=null
(
	(
		employee
		⨝employee.Ssn=department.Mgr_ssn
		department
	)
	⟕employee.Ssn=dependent.Essn
	dependent
)
```


### *i)* 

```
... Write here your answer ...
```


## ​Problema 5.2

### *a)*

```
π fornecedor.nif,fornecedor.nome
σ encomenda.numero=null
(
	fornecedor
	⟕fornecedor.nif=encomenda.fornecedor
	encomenda
)
```

### *b)* 

```
γ produto.codigo,produto.nome; avg(produto.unidades) -> averageUnidades (produto)

```


### *c)* 

```
... Write here your answer ...
```


### *d)* 

```
... Write here your answer ...
```


## ​Problema 5.3

### *a)*

```
... Write here your answer ...
```

### *b)* 

```
... Write here your answer ...
```


### *c)* 

```
... Write here your answer ...
```


### *d)* 

```
... Write here your answer ...
```

### *e)* 

```
... Write here your answer ...
```

### *f)* 

```
... Write here your answer ...
```
