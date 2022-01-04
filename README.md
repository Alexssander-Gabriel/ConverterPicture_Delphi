Conversor de Imagens.

como usar:

1 - Acrescente o arquivo uConversor.pas ao seu projeto.

2 - Chame o Type TConversor pelo Método Create passando todos os seus devidos Parâmetros.

3 - Chame a procedure Converter do TConversor.  


Tutorial:

Conversões Disponíveis:
Png para Jpeg/Jpg.
Png para Bmp.
Jpeg/Jpg para Png.
Jpeg/jpg para Bmp.

Formado são definidos pelos números inteiros, sendo eles:
0 - JPEG / JPG.
1 - PNG.
2 - BMP.

A opção de aplicar fundo somente é funcional para imagens no formato de origem PNG que sejam Transparentes(Não branco).

Extra: Função formatovalido pode ser utilizada para verificar os formatos antes de inicializar a conversão, porém a mesma é utilizada automaticamente no processo de conversão, convertendo somente as imagens com o formato de origem valido.



 