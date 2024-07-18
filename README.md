# Ecommerce Database Design 
Bu proje, e-ticaret sitesi için T-SQL kullanarak bir veritabanı tasarımı ve yönetimi içermektedir. Aşağıda, bu projede gerçekleştirilen işlemler ve kullanılan komutlar sırasıyla açıklanmaktadır.

## İçindekiler

1. [Veritabanı ve Tabloların Oluşturulması]
2. [Stored Procedures]
3. [Views]
4. [Functions]
5. [Triggers]

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