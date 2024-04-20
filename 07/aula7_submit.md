# BD: Guião 7


## ​7.2 
 
### *a)*

```
... Write here your answer ...
Primeira forma normal 
Não existem atributos multivalor, mas existem dependências parciais
```

### *b)* 

```
-> Livro (_Titulo_Livro_, _Nome_Autor_, Editor, Tipo_Livro, NoPaginas,Ano_Publicacao)
-> Preco (_Tipo_Livro_, _NoPaginas_, Preco)
-> Autor (_Nome_Autor_, Afiliacao_Autor)
-> Editor (_Editor_, Endereco_Editor)
```




## ​7.3
 
### *a)*

```
AB
```


### *b)* 

```
(_A_, _B_, C) (_A_, D, E, I, J) (_B_, F, G, H)
```


### *c)* 

```
(_A_, _B_ C) (_A_, D, E) (_B_, F) (F, G, H) (D, I, J)
```


## ​7.4
 
### *a)*

```
AB
```


### *b)* 

```
(_A_, _B_, C, D) (_D_, E)
```


### *c)* 

```
(_C_, A) (_D_, E) (_B_, C, D)
```



## ​7.5
 
### *a)*

```
AB
```

### *b)* 

```
(_A_, _B_, D, E) (_A_, C)
```


### *c)* 

```
(_A_, _B_, E) (_A_, C) (_C_, D)
```

### *d)* 

```
Já está na BCNF porque não existe nenhuma relação que não seja X->Y onde X é superchave e Y é subchave
```
