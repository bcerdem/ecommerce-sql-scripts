-- Ürün ekleme prosedürü hata yönetimi

CREATE PROCEDURE AddProduct
     @name VARCHAR(100),
     @desciprition VARCHAR(MAX),
     @price DECIMAL(10,2),
     @stock INT,
     @category_id INT
AS
BEGIN
     SET NOCOUNT ON;

     BEGIN TRY
          INSERT INTO Products (product_name, product_descr, price, stock,category_id)
          VALUES (@name, @desciprition, @price, @stock, @category_id);
     END TRY
     BEGIN CATCH
          DECLARE @ErrorMessage NVARCHAR(4000);
          DECLARE @ErrorSeverity INT;
          DECLARE @ErrorState INT;

          SELECT
               @ErrorMessage = ERROR_MESSAGE(),
               @ErrorSeverity = ERROR_SEVERITY(),
               @ErrorState = ERROR_STATE();

          RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
     END CATCH;
END;