-- Eğer varsa;
DROP PROCEDURE IF EXISTS CreateOrder;
GO

-- Sipariş oluşturma ve ödeme işlemi

CREATE PROCEDURE CreateOrder
     @user_id INT,
     @total_amount DECIMAL(10,2),
     @shipping_address_id INT,
     @billing_address_id INT,
     @payment_method VARCHAR(50),
     @product_ids VARCHAR(MAX),
     @quantities VARCHAR(MAX)
AS
BEGIN
     SET NOCOUNT ON;
     DECLARE @order_id INT;
     DECLARE @payment_id INT;
     DECLARE @product_id INT;
     DECLARE @quantity INT;
     DECLARE @price DECIMAL(10,2);
     DECLARE @product_id_list TABLE (product_id INT);
     DECLARE @quantity_list TABLE (quantity INT);

     BEGIN TRANSACTION;

     BEGIN TRY
          -- Sipariş oluştur
          INSERT INTO Orders (user_id, total_amount, shipping_address_id, billing_address_id,order_status)
          VALUES (@order_id, @total_amount, @shipping_address_id, @billing_address_id, 'Pending');
          SET @order_id = SCOPE_IDENTITY();

          -- Ödemeyi oluştur
          INSERT INTO Payments (order_id, payment_method, amount, payment_status)
          VALUES (@order_id, @payment_method, @total_amount, 'Pending');
          SET @payment_id = SCOPE_IDENTITY();

          -- Ürün ve miktar listelerini doldur
          INSERT INTO @product_id_list (product_id) SELECT value FROM string_split(@product_ids, ',');
          INSERT INTO @quantity_list (quantity) SELECT value FROM string_split(@quantities, ',');

          -- Sipariş öğelerini ekle
          DECLARE product_cursor CURSOR FOR SELECT product_id FROM @product_id_list;
          OPEN product_cursor;
          FETCH NEXT FROM product_cursor INTO @product_id;

          WHILE @@FETCH_STATUS = 0
          BEGIN
               SELECT @quantity = (SELECT TOP 1 quantity FROM @quantity_list);
               SELECT @price = (SELECT price FROM Products WHERE product_id = @product_id);

               INSERT INTO OrderItems (order_id, product_id, quantity, price, total)
               VALUES (@order_id,@product_id,@quantity, @price, @price * @quantity);

               DELETE FROM @quantity_list WHERE quantity = @quantity;
               FETCH NEXT FROM product_cursor INTO @product_id;
          END;

          CLOSE product_cursor;
          DEALLOCATE product_cursor;

          -- Ödeme kimliğini siparişe ekle
          UPDATE Orders
          SET payment_id = @payment_id
          WHERE order_id = @order_id;

          COMMIT TRANSACTION;
          SELECT @order_id AS OrderID;
     END TRY
     BEGIN CATCH
          ROLLBACK TRANSACTION;
          THROW;
     END CATCH;
END;
