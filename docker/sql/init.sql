-- Create database if not exists
IF DB_ID('ContactDB') IS NULL
BEGIN
    CREATE DATABASE ContactDB;
END;
GO

-- Switch to ContactDB
USE ContactDB;
GO

-- Create Users table if not exists
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'Users' AND xtype = 'U')
BEGIN
    CREATE TABLE Users (
        Id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
        Email NVARCHAR(100) NOT NULL UNIQUE,
        FirstName NVARCHAR(100) NOT NULL,
        LastName NVARCHAR(100) NOT NULL,
        PasswordHash NVARCHAR(MAX) NOT NULL,
        DateCreated DATETIME NOT NULL DEFAULT GETDATE(),
        RefreshToken NVARCHAR(MAX) NULL,
        RefreshTokenExpiryTime DATETIME NULL
    );
END;
GO

-- Create Contacts table if not exists
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'Contacts' AND xtype = 'U')
BEGIN
    CREATE TABLE Contacts (
        Id INT IDENTITY PRIMARY KEY,
        ContactId UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
        UserId UNIQUEIDENTIFIER NOT NULL,
        Name NVARCHAR(100) NOT NULL,
        Email NVARCHAR(100) NOT NULL UNIQUE,
        PhoneNumber NVARCHAR(20) NULL,
        ProfilePicture NVARCHAR(MAX) NULL,
        DateCreated DATETIME NOT NULL DEFAULT GETDATE(),
        DateUpdated DATETIME NULL,
        CONSTRAINT FK_Contacts_Users FOREIGN KEY (UserId)
            REFERENCES Users(Id)
            ON DELETE CASCADE
    );

    -- Indexes for better performance
    CREATE INDEX IX_Contacts_UserId ON Contacts(UserId);
    CREATE INDEX IX_Contacts_Email ON Contacts(Email);
END;
GO
