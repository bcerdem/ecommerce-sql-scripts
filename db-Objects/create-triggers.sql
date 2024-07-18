-- 'Users' tablosu için [update_at] kolonunu güncelleyen trigger

CREATE TRIGGER trg_UpdateUserTimestamp
ON Users
AFTER UPDATE
AS
BEGIN
     SET NOCOUNT ON;
     UPDATE Users
     SET updated_at = GETDATE()
     WHERE user_id IN (SELECT DISTINCT user_id FROM Inserted);
END;
GO

-- 'Products' tablosu için [update_at] kolonunu güncelleyen trigger

CREATE TRIGGER trg_UpdateProductTimestamp
ON Products
AFTER UPDATE
AS
BEGIN
     SET NOCOUNT ON;
     UPDATE Products
     SET updated_at = GETDATE()
     WHERE product_id IN (SELECT DISTINCT product_id FROM Inserted);
END;
GO

-- 'Categories' tablosu için [update_at] kolonunu güncelleyen trigger

CREATE TRIGGER trg_UpdateCategoryTimestamp
ON Categories
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Categories
    SET updated_at = GETDATE()
    WHERE category_id IN (SELECT DISTINCT category_id FROM Inserted);
END;
GO


-- 'Orders' tablosu için [updated_at] kolonunu güncelleyen trigger

CREATE TRIGGER trg_UpdateOrderTimestamp
ON Orders
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Orders
    SET updated_at = GETDATE()
    WHERE order_id IN (SELECT DISTINCT order_id FROM Inserted);
END;
GO

-- OrderItems tablosu için [updated_at] kolonunu güncelleyen trigger

CREATE TRIGGER trg_UpdateOrderItemTimestamp
ON OrderItems
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE OrderItems
    SET updated_at = GETDATE()
    WHERE order_item_id IN (SELECT DISTINCT order_item_id FROM Inserted);
END;
GO

-- `Payments` tablosu için [updated_at] kolonunu güncelleyen trigger


CREATE TRIGGER trg_UpdatePaymentTimestamp
ON Payments
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Payments
    SET updated_at = GETDATE()
    WHERE payment_id IN (SELECT DISTINCT payment_id FROM Inserted);
END;
GO

-- 'Addresses` tablosu için [updated_at] kolonunu güncelleyen trigger

CREATE TRIGGER trg_UpdateAddressTimestamp
ON Addresses
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Addresses
    SET updated_at = GETDATE()
    WHERE address_id IN (SELECT DISTINCT address_id FROM Inserted);
END;
GO

-- `ProductReviews` tablosu için [updated_at] kolonunu güncelleyen trigger

CREATE TRIGGER trg_UpdateProductReviewTimestamp
ON ProductReviews
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE ProductReviews
    SET updated_at = GETDATE()
    WHERE review_id IN (SELECT DISTINCT review_id FROM Inserted);
END;
GO

-- `ProductImages` tablosu için [updated_at] kolonunu güncelleyen trigger

CREATE TRIGGER trg_UpdateProductImageTimestamp
ON ProductImages
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE ProductImages
    SET updated_at = GETDATE()
    WHERE image_id IN (SELECT DISTINCT image_id FROM Inserted);
END;
GO

-- `Wishlists` tablosu için [updated_at] kolonunu güncelleyen trigger

CREATE TRIGGER trg_UpdateWishlistTimestamp
ON Wishlists
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Wishlists
    SET updated_at = GETDATE()
    WHERE wishlist_id IN (SELECT DISTINCT wishlist_id FROM Inserted);
END;
GO

-- `ShippingMethods` tablosu için [updated_at] kolonunu güncelleyen trigger

CREATE TRIGGER trg_UpdateShippingMethodTimestamp
ON ShippingMethods
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE ShippingMethods
    SET updated_at = GETDATE()
    WHERE shipping_method_id IN (SELECT DISTINCT shipping_method_id FROM Inserted);
END;
GO

-- 'OrderShipments` tablosu için [updated_at] kolonunu güncelleyen trigger

CREATE TRIGGER trg_UpdateOrderShipmentTimestamp
ON OrderShipments
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE OrderShipments
    SET updated_at = GETDATE()
    WHERE shipment_id IN (SELECT DISTINCT shipment_id FROM Inserted);
END;
GO

-- Stok Güncelleme

CREATE TRIGGER trg_UpdateStock
ON OrderItems
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @product_id INT;
    DECLARE @quantity INT;

    SELECT @product_id = i.product_id, @quantity = i.quantity
    FROM Inserted i;

    UPDATE Products
    SET stock = stock - @quantity
    WHERE product_id = @product_id;
END;
GO