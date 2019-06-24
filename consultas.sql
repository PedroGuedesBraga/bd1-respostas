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
                                                                                                     
                                                                                                     
 
                                                                                                     
                                                                                                     

                                                                                                     
--Questao 15
--LEMBRAR DE CORRIGIR OS VALORES NA STRINGS

CREATE OR REPLACE TRIGGER trCheckReserva 
AFTER INSERT ON Reserva
FOR EACH ROW
BEGIN
    IF :new.NUMERO_QUARTO NOT IN (SELECT q.NUMERO
                                FROM Quarto q
                                WHERE q.TIPO = 'EUR' and q.VISTA = 'Euro') THEN 
        RAISE_APPLICATION_ERROR(-20000, 'So pode reservar quarto tipo simples e vista lateral');                          
    END IF;
END;



--Questao 15
-- Versao alternativa

CREATE OR REPLACE TRIGGER trCheckReserva 
AFTER INSERT ON Reserva
FOR EACH ROW
DECLARE
    CURSOR qto_cursor IS SELECT q.NUMERO
                         FROM Quarto q
                         WHERE q.TIPO LIKE '%EUR%' and q.VISTA LIKE '%Euro%';
    num_qto_simples_lateral qto_cursor%ROWTYPE;
BEGIN
    OPEN qto_cursor;
    LOOP
        FECTH qto_cursor INTO num_qto_simples_lateral;
        EXIT WHEN qto_cursor%NOT_FOUND;
        IF(num_qto_simples_lateral LIKE :NEW.NUMERO_QUARTO) THEN
            EXIT;
        END IF;
    END LOOP;
    IF(qto_cursor%NOT_FOUND)
        RAISE_APPLICATION_ERROR(-20000, 'So pode reservar quarto tipo simples e vista lateral');
    END IF;
    CLOSE qto_cursor;
END;
                                                                                                     
