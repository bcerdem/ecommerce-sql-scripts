-- Dinamik Ürün Arama

CREATE PROCEDURE SearchProducts
    @search_term VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @sql NVARCHAR(MAX);
    SET @sql = 'SELECT * FROM Products WHERE name LIKE ''%' + @search_term + '%'' OR description LIKE ''%' + @search_term + '%''';

    EXEC sp_executesql @sql;
END;
GO
