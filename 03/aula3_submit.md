# BD: Guião 3


## ​Problema 3.1
 
### *a)*

```
cliente: NIF (PK) (CK), num_carta (CK), endereço, nome
balcao: numero (PK) (CK), endereco, nome
veiculo: matricula (PK) (CK), marca, ano, tipo_veiculo-codigo (FK)
tipo_veiculo: codigo (PK) (CK), arcondicionado , designacao
aluguer: numero (PK) (CK), date, duracao, cliente-nif (FK), veiculo-matricula (FK), balcao-numero (FK)
similaridade: TVcodigo1 (PK) (CK) (FK), TVcodigo2 (PK) (CK) (FK)
ligeiro: id (PK) (CK), TVcodigo (FK), numlugares, portas, combustível
pesado: id (PK) (CK), TVcodigo (FK), peso, passageiros
```


### *b)* 

```
cliente:
PK: NIF
CK: NIF, num_carta
FK:

balcao:
PK: numero
CK: numero
FK:

veiculo:
PK: matricula
CK: matricula
FK: tipo_veiculo-codigo

tipo_veiculo:
PK: codigo
CK: codigo
FK:

aluguer:
PK: numero
CK: numero
FK: cliente-nif, veiculo-matricula, balcao-numero

similaridade:
PK: TVcodigo1 + TVcodigo2
CK: TVcodigo1 + TVcodigo2
FK: TVcodigo1, TVcodigo2

ligeiro:
PK: id
CK: id
FK: TVcodigo

pesado:
PK: id
CK: id
FK: TVcodigo





```


### *c)* 

![ex_3_1c!](ex_3_1c.jpg "AnImage")


## ​Problema 3.2

### *a)*

```
... Write here your answer ...
```


### *b)* 

```
... Write here your answer ...
```


### *c)* 

![ex_3_2c!](ex_3_2c.jpg "AnImage")


## ​Problema 3.3


### *a)* 2.1

![ex_3_3_a!](ex_3_3a.jpg "AnImage")

### *b)* 2.2

![ex_3_3_b!](ex_3_3b.jpg "AnImage")

### *c)* 2.3

![ex_3_3_c!](ex_3_3c.jpg "AnImage")

### *d)* 2.4

![ex_3_3_d!](ex_3_3d.jpg "AnImage")