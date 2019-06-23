--Questao 5

SELECT v.ID_VENDA
FROM VENDA v, PRODUTO p
WHERE v.ID_PRODUTO = p.ID and
      (v.QUANTIDADE * p.VALOR) = (SELECT MAX(v1.QUANTIDADE * p1.VALOR) as VALOR_DA_VENDA
                                 FROM VENDA v1, PRODUTO p1
                                 WHERE v1.ID_PRODUTO = p1.ID
                                 and v1.data between TO_DATE('12-01-2018', 'MM-DD-YYYY') and TO_DATE('12-31-2018', 'MM-DD-YYYY'))
      and v.data between TO_DATE('12-01-2018', 'MM-DD-YYYY') and TO_DATE('12-31-2018', 'MM-DD-YYYY')
      

--Questao 10 

--Visao Auxiliar definida localmente com WITH: permite ter, em cada tupla, a informacao do cpf do cliente e a qnt. de produtos do tipo 'lavadeira' que ele consumiu
--(LEMBRAR DE TROCAR 'restaurante' por 'lavadeira')
WITH auxiliar(cpf, qnt_lavadeira) AS
     (SELECT c.CPF, COUNT(p.ID) as NumeroProdutosTipoLavadeira
     FROM Cliente c, Hospeda h, Quarto q, Venda v, Produto p
     WHERE c.CPF = h.CPF_CLIENTE and h.NUMERO_QUARTO = q.NUMERO and q.NUMERO = v.NUMERO_QUARTO and v.ID_PRODUTO = p.ID
           and p.tipo LIKE '%restaurante%'
     GROUP BY c.CPF)
SELECT a.cpf
FROM auxiliar a
WHERE a.qnt_lavadeira = (SELECT MAX(qnt_lavadeira)
                        FROM auxiliar)