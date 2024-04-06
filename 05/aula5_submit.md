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
π employee.Fname, employee.Minit, employee.Lname
σ Chefe.Fname = 'Carlos' ∧ Chefe.Minit = 'D' ∧ Chefe.Lname = 'Gomes'
(
	employee ⨝ employee.Super_ssn = Chefe.Ssn
	ρ Chefe
	employee
)
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
π employee.Fname, employee.Minit, employee.Lname
σ Hours > 20 ∧ employee.Dno = 3 ∧ project.Pname = 'Aveiro Digital' 
(
	employee ⨝ employee.Ssn = works_on.Essn works_on
	⨝ works_on.Pno = project.Pnumber project
)
```


### *e)* 

```
π employee.Fname, employee.Minit, employee.Lname
σ works_on.Essn=null
(
    employee 
        ⟕ employee.Ssn=works_on.Essn 
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
		⨝ department.Dnumber=employee.Dno
		department
	)
	⨝ employee.Ssn=works_on.Essn works_on
)
```


### *g)* 

```
π employee.Fname, employee.Minit, employee.Lname, numDependents
(
	γ dependent.Essn; count(dependent.Dependent_name) -> numDependents (dependent)
	⨝ dependent.Essn = employee.Ssn employee
)
```


### *h)* 

```
π employee.Fname,employee.Minit,employee.Lname
σ dependent.Essn=null
(
	(
		employee
		⨝ employee.Ssn=department.Mgr_ssn
		department
	)
	⟕ employee.Ssn=dependent.Essn
	dependent
)
```


### *i)* 

```
π employee.Fname, employee.Minit, employee.Lname, employee.Address
σ project.Plocation = 'Aveiro' ∧ dept_location.Dlocation ≠ 'Aveiro'
(
	employee
	⨝ employee.Dno = department.Dnumber department
	⨝ department.Dnumber = dept_location.Dnumber dept_location
	⨝ employee.Ssn = works_on.Essn works_on
	⨝ works_on.Pno = project.Pnumber project
)
```


## ​Problema 5.2

### *a)*

```
π fornecedor.nif,fornecedor.nome
σ encomenda.numero=null
(
	fornecedor
	⟕ fornecedor.nif=encomenda.fornecedor
	encomenda
)
```

### *b)* 

```
γ produto.codigo,produto.nome; avg(produto.unidades) -> averageUnidades (produto)
```


### *c)* 

```
γ avg(quantidade) -> average
(
	γ item.numEnc; count(item.codProd) -> quantidade item
)
```


### *d)* 

```
π fornecedor.nome, produto.nome, quantidade
(
	γ item.codProd, encomenda.fornecedor; sum(item.unidades) -> quantidade
	(
		item
		⨝ item.numEnc=encomenda.numero encomenda
		
	)
	⨝ item.codProd=produto.codigo produto
	⨝ encomenda.fornecedor=fornecedor.nif fornecedor
)
```


## ​Problema 5.3

### *a)*

```
π paciente.nome
σ prescricao.numPresc=null
(
	paciente
	⟕ paciente.numUtente = prescricao.numUtente prescricao
)
```

### *b)* 

```
γ medico.especialidade; count(medico.especialidade) -> numPrescricoes
(
	medico
	⨝ medico.numSNS=prescricao.numMedico
	prescricao
)
```


### *c)* 

```
γ prescricao.farmacia; count(prescricao.farmacia) -> numPrescricoes
(
	σ prescricao.farmacia≠null
	(
		medico
		⨝ medico.numSNS=prescricao.numMedico
		prescricao
	)
)
```


### *d)* 

```
π farmaco.nome,farmaco.formula
(
	farmaco
	⨝ farmaceutica.numReg=farmaco.numRegFarm
	(
		farmaceutica - (σ farmaceutica.numReg=906 (farmaceutica))
	)
)
```

### *e)* 

```
π farmacia.nome, farmaceutica.nome, vendas
(
	γ farmacia.nome, farmaco.numRegFarm; count(farmaco.nome) -> vendas
	(
		farmaco
		⨝ presc_farmaco.numRegFarm = farmaco.numRegFarm ∧ presc_farmaco.nomeFarmaco = farmaco.nome presc_farmaco
		⨝ prescricao.numPresc = presc_farmaco.numPresc prescricao
		⨝ prescricao.farmacia = farmacia.nome farmacia
	)
	⨝ farmaco.numRegFarm = farmaceutica.numReg farmaceutica
)
```

### *f)* 

```
σ medicos ≥ 2
γ prescricao.numUtente; count(prescricao.numMedico) -> medicos prescricao
⋊ paciente
```
