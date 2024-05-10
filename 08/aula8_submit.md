# BD: Guião 8


## ​8.1. Complete a seguinte tabela.
Complete the following table.

| #    | Query                                                                                                      | Rows  | Cost  | Pag. Reads | Time (ms) | Index used | Index Op.            | Discussion |
| :--- | :--------------------------------------------------------------------------------------------------------- | :---- | :---- | :--------- | :-------- | :--------- | :------------------- | :--------- |
| 1    | SELECT * from Production.WorkOrder                                                                         | 72591 | 0.473 | 552        | 856      | PK_WorkerOrder_WorkOrderID    | Clustered Index Scan |            |
| 2    | SELECT * from Production.WorkOrder where WorkOrderID=1234                                                  | 1      |   0.00328    |   20         |    5       |  PK_WorkerOrder_WorkOrderID    |      Clustered Index Scan               |            |
| 3.1  | SELECT * FROM Production.WorkOrder WHERE WorkOrderID between 10000 and 10010                               |  11     |   0.00329    |   26         |   89        |   PK_WorkerOrder_WorkOrderID     |     Clustered Index Seek                 |            |
| 3.2  | SELECT * FROM Production.WorkOrder WHERE WorkOrderID between 1 and 72591                                   |     72591  |   0.473    |   554         |    803       |    PK_WorkerOrder_WorkOrderID   |     Clustered Index Seek                 |            |
| 4    | SELECT * FROM Production.WorkOrder WHERE StartDate = '2007-06-25'                                          |   55    |   0.473    |     1162       |    144       |    PK_WorkerOrder_WorkOrderID     |       Clustered Index Scan               |            |
| 5    | SELECT * FROM Production.WorkOrder WHERE ProductID = 757                                                   |   9    |   0.00329    |     238       |    71       |   IX_WorkerOrder_ProductID         |      Index Seek         |            |
| 6.1  | SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 757                              |   9    |   0.00329    |     238       |     73      |    IX_WorkerOrder_ProductID        |        Index Seek              |            |
| 6.2  | SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 945                              |   105    |  0.473     |     748       |      66     |     PK_WorkerOrder_WorkOrderID       |     Clustered Index Scan                 |            |
| 6.3  | SELECT WorkOrderID FROM Production.WorkOrder WHERE ProductID = 945 AND StartDate = '2006-01-04'            |    1   |   0.473    |    750        |     19      |      PK_WorkerOrder_WorkOrderID       |     Clustered Index Scan               |            |
| 7    | SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 945 AND StartDate = '2006-01-04' |   1    |   0.473    |     556       |     12      |     PK_WorkerOrder_WorkOrderID       |     Clustered Index Scan              |            |
| 8    | SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 945 AND StartDate = '2006-01-04' |    1   |    0.473   |     750       |    19       |      PK_WorkerOrder_WorkOrderID       |     Clustered Index Scan            |            |

## ​8.2.

### a)

```
CREATE CLUSTERED INDEX Idx_rid ON mytemp(rid);
```

### b)

```
99.22
```

### c)

```
65 - 2:03
80 - 1:59
90 - 1:55

Assim conclui-se que o tempo de inserção reduz com o aumento do fillfactor
```

### d)

```
65 - 1:43
80 - 1:55
90 - 1:55
```

### e)

```
sem indice - 1:53
com todos os indices - 4:08

Com isto conclui-se que um elevado número de índices pode levar a uma quebra de desempenho em operações de inserção
```

## ​8.3.

```
a)
    i) CREATE CLUSTERED INDEX Idx_Ssn ON Employee(Ssn);
    ii) CREATE CLUSTERED INDEX Idx_Name ON Employee(Lname, Fname);
    iii) CREATE INDEX Idx_Dno ON Employee(Dno);
    iv) CREATE INDEX Idx_Pno ON WorksOn(Pno);
        CREATE INDEX Idx_Ssn ON Employee(Ssn);
    v) CREATE INDEX Idx_DependentEssn ON Dependent(Essn);
       CREATE INDEX Idx_Ssn ON Employee(Ssn);
    vi) CREATE INDEX Idx_Dnumber ON Project(Dnumber);
```
