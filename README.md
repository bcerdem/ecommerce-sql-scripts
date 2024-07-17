# Ecommerce Database Design 

## Veritabanı ve Tabloların Oluşturulması

Projenin başlangıcında, gerekli tüm tablolar ve veri yapıları oluşturulmuştur. Bu tablolar:

- Users
- Categories
- Products
- Addresses
- Orders
- Payments
- OrderItems
- ProductReviews
- ProductImages
- Wishlists
- ShippingMethods
- OrderShipments

Her tablo, ilgili kolonları ve veri tipleriyle birlikte aşağıdaki T-SQL komutları kullanılarak oluşturulmuştur:

```sql
CREATE TABLE [dbo].[Users]
(
     [user_id] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
     [first_name] VARCHAR(50) NOT NULL,
     [last_name] VARCHAR(50) NOT NULL,
     [email] VARCHAR(50) NOT NULL UNIQUE,
     [pwd] VARCHAR(255) NOT NULL,
     [phone] VARCHAR(15),
     [created_at] DATETIME DEFAULT GETDATE(),
     [updated_at] DATETIME DEFAULT GETDATE()
);
-- Diğer tablolar da benzer şekilde oluşturulmuştur.