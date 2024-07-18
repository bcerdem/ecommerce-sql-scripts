-- Create a new database called 'ECommerceDB'
-- Connect to the 'master' database to run this snippet
USE master
GO
-- Create the new database if it does not exist already
IF NOT EXISTS (
     SELECT [name]
          FROM sys.databases
          WHERE [name] = N'ECommerceDB'
)
CREATE DATABASE ECommerceDB
GO

USE ECommerceDB;
GO

-- Drop tables if they exist
IF OBJECT_ID('[dbo].[OrderShipments]', 'U') IS NOT NULL DROP TABLE [dbo].[OrderShipments];
IF OBJECT_ID('[dbo].[Wishlists]', 'U') IS NOT NULL DROP TABLE [dbo].[Wishlists];
IF OBJECT_ID('[dbo].[ProductImages]', 'U') IS NOT NULL DROP TABLE [dbo].[ProductImages];
IF OBJECT_ID('[dbo].[ProductsReviews]', 'U') IS NOT NULL DROP TABLE [dbo].[ProductsReviews];
IF OBJECT_ID('[dbo].[Addresses]', 'U') IS NOT NULL DROP TABLE [dbo].[Addresses];
IF OBJECT_ID('[dbo].[Payments]', 'U') IS NOT NULL DROP TABLE [dbo].[Payments];
IF OBJECT_ID('[dbo].[OrderItems]', 'U') IS NOT NULL DROP TABLE [dbo].[OrderItems];
IF OBJECT_ID('[dbo].[Orders]', 'U') IS NOT NULL DROP TABLE [dbo].[Orders];
IF OBJECT_ID('[dbo].[Products]', 'U') IS NOT NULL DROP TABLE [dbo].[Products];
IF OBJECT_ID('[dbo].[Categories]', 'U') IS NOT NULL DROP TABLE [dbo].[Categories];
IF OBJECT_ID('[dbo].[ShippingMethods]', 'U') IS NOT NULL DROP TABLE [dbo].[ShippingMethods];
IF OBJECT_ID('[dbo].[Users]', 'U') IS NOT NULL DROP TABLE [dbo].[Users];
GO

-- Create Users table
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
GO

-- Create Categories table
CREATE TABLE [dbo].[Categories]
(
     [category_id] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
     [category_name] NVARCHAR(50) NOT NULL,
     [category_descr] VARCHAR(MAX),
     [created_at] DATETIME DEFAULT GETDATE(),
     [updated_at] DATETIME DEFAULT GETDATE()     
);
GO

-- Create Products table
CREATE TABLE [dbo].[Products]
(
     [product_id] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
     [product_name] VARCHAR(100) NOT NULL,
     [product_descr] VARCHAR(MAX),
     [price] DECIMAL(10,2) NOT NULL,
     [stock] INT NOT NULL,
     [category_id] INT NOT NULL,
     [created_at] DATETIME DEFAULT GETDATE(),
     [updated_at] DATETIME DEFAULT GETDATE(),
     FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);
GO

-- Create Addresses table
CREATE TABLE [dbo].[Addresses]
(
     [address_id] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
     [user_id] INT,
     [address_line1] VARCHAR(255) NOT NULL,
     [address_line2] VARCHAR(255),
     [city] VARCHAR(50) NOT NULL,
     [state] VARCHAR(50) NOT NULL,
     [zip_code] VARCHAR(20) NOT NULL,
     [country] VARCHAR(50) NOT NULL,
     [created_at] DATETIME DEFAULT GETDATE(),
     [updated_at] DATETIME DEFAULT GETDATE(),
     FOREIGN KEY(user_id) REFERENCES Users(user_id)
);
GO

-- Create Orders table
CREATE TABLE [dbo].[Orders]
(
    [order_id] INT PRIMARY KEY IDENTITY(1,1),
    [user_id] INT NOT NULL,
    [order_date] DATETIME DEFAULT GETDATE(),
    [order_status] VARCHAR(20) NOT NULL,
    [total_amount] DECIMAL(10,2) NOT NULL,
    [shipping_address_id] INT,
    [billing_address_id] INT,
    [payment_id] INT,
    [created_at] DATETIME DEFAULT GETDATE(),
    [updated_at] DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (shipping_address_id) REFERENCES Addresses(address_id),
    FOREIGN KEY (billing_address_id) REFERENCES Addresses(address_id)
);
GO

-- Create Payments table
CREATE TABLE [dbo].[Payments]
(
     [payment_id] INT NOT NULL PRIMARY KEY IDENTITY(1,1), 
     [order_id] INT NOT NULL,
     [payment_method] VARCHAR(50) NOT NULL,
     [amount] DECIMAL(10,2) NOT NULL,
     [payment_date] DATETIME DEFAULT GETDATE(),
     [payment_status] VARCHAR(20) NOT NULL,
     [created_at] DATETIME DEFAULT GETDATE(),
     [updated_at] DATETIME DEFAULT GETDATE(),
     FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);
GO

-- Create OrderItems table
CREATE TABLE [dbo].[OrderItems]
(
     [order_item_id] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
     [order_id] INT NOT NULL,
     [product_id] INT NOT NULL,
     [quantity] INT NOT NULL,
     [price] DECIMAL(10,2) NOT NULL,
     [total] DECIMAL(10,2) NOT NULL,
     [created_at] DATETIME DEFAULT GETDATE(),
     [updated_at] DATETIME DEFAULT GETDATE(),
     FOREIGN KEY (order_id) REFERENCES Orders(order_id),
     FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
GO

-- Create ProductsReviews table
CREATE TABLE [dbo].[ProductsReviews]
(
     [review_id] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
     [product_id] INT NOT NULL,
     [user_id] INT NOT NULL,
     [rating] INT NOT NULL,
     [comments] VARCHAR(MAX),
     [created_at] DATETIME DEFAULT GETDATE(),
     [updated_at] DATETIME DEFAULT GETDATE(),
     FOREIGN KEY(product_id) REFERENCES Products(product_id),
     FOREIGN KEY(user_id) REFERENCES Users(user_id)
);
GO

-- Create ProductImages table
CREATE TABLE [dbo].[ProductImages]
(
     [image_id] INT PRIMARY KEY IDENTITY(1,1),
     [product_id] INT NOT NULL,
     [image_url] VARCHAR(255) NOT NULL,
     [created_at] DATETIME DEFAULT GETDATE(),
     [updated_at] DATETIME DEFAULT GETDATE(),
     FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
GO

-- Create Wishlists table
CREATE TABLE [dbo].[Wishlists]
(
     [wishlist_id] INT PRIMARY KEY IDENTITY(1,1),
     [user_id] INT NOT NULL,
     [product_id] INT NOT NULL,
     [created_at] DATETIME DEFAULT GETDATE(),
     [updated_at] DATETIME DEFAULT GETDATE(),
     FOREIGN KEY (user_id) REFERENCES Users(user_id),
     FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
GO

-- Create ShippingMethods table
CREATE TABLE [dbo].[ShippingMethods]
(
     [shipping_method_id] INT PRIMARY KEY IDENTITY(1,1),
     [sm_name] VARCHAR(50) NOT NULL,
     [sm_descr] VARCHAR(MAX),
     [price] DECIMAL(10,2) NOT NULL,
     [created_at] DATETIME DEFAULT GETDATE(),
     [updated_at] DATETIME DEFAULT GETDATE()
);
GO

-- Create OrderShipments table
CREATE TABLE [dbo].[OrderShipments]
(
     [shipment_id] INT PRIMARY KEY IDENTITY(1,1),
     [order_id] INT NOT NULL,
     [shipping_method_id] INT NOT NULL,
     [tracking_number] VARCHAR(100),
     [shipped_date] DATETIME,
     [os_status] VARCHAR(20) NOT NULL,
     [created_at] DATETIME DEFAULT GETDATE(),
     [updated_at] DATETIME DEFAULT GETDATE(),
     FOREIGN KEY (order_id) REFERENCES Orders(order_id),
     FOREIGN KEY (shipping_method_id) REFERENCES ShippingMethods(shipping_method_id)
);
GO
