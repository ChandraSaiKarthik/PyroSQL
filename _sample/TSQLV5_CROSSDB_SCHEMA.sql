---------------------------------------------------------------------
-- Script that creates the sample database TSQLV5
--
-- Supported versions of SQL Server: 2008 - 2019, Azure SQL Database
--
-- Based originally on the Northwind sample database
-- with changes in both schema and data
--
-- Last updated: 20191126
--
-- © Itzik Ben-Gan
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Create empty database TSQLV5
---------------------------------------------------------------------

-- For SQL Server box product use the steps in section A and then proceed to section C
-- For Azure SQL Database use the steps in section B and then proceed to section C

---------------------------------------------------------------------
-- Section A - for SQL Server box product only
---------------------------------------------------------------------

-- 1. Connect to your SQL Server instance, master database

-- 2. Run the following code to create an empty database called TSQLV5
USE master;

-- Drop database
IF DB_ID(N'TSQLV5_CROSSDB') IS NOT NULL DROP DATABASE TSQLV5_CROSSDB;

-- If database could not be created due to open connections, abort
IF @@ERROR = 3702 
   RAISERROR(N'Database cannot be dropped because there are still open connections.', 127, 127) WITH NOWAIT, LOG;

-- Create database
CREATE DATABASE TSQLV5_CROSSDB;
GO

USE TSQLV5_CROSSDB;
GO

-- 3. Proceed to section C

---------------------------------------------------------------------
-- Section B - for Azure SQL Database only
---------------------------------------------------------------------

/*
-- 1. Connect to Azure SQL Database, master database
USE master; -- used only as a test; will fail if not connected to master

-- 2. Run following if TSQLV5 database already exists, otherwise skip
DROP DATABASE TSQLV5; 
GO

-- 3. Run the following code to create an empty database called TSQLV5
CREATE DATABASE TSQLV5;
GO

-- 4. Connect to TSQLV5 before running the rest of the code
USE TSQLV5; -- used only as a test; will fail if not connected to TSQLV5
GO

-- 5. Proceed to section C
*/

---------------------------------------------------------------------
-- Populate database TSQLV5 with sample data
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Section C - for both SQL Server box and Azure SQL Database
---------------------------------------------------------------------

-- 1. Highlight the remaining code in the script file and execute

---------------------------------------------------------------------
-- Create Schemas
---------------------------------------------------------------------

CREATE SCHEMA HR AUTHORIZATION dbo;
GO
CREATE SCHEMA EXT AUTHORIZATION dbo;
GO

---------------------------------------------------------------------
-- Create Tables
---------------------------------------------------------------------

-- Create table HR.Employees_Migration
CREATE TABLE HR.Employees_Migration
(
  empid           INT          NOT NULL IDENTITY,
  lastname        NVARCHAR(20) NOT NULL,
  firstname       NVARCHAR(10) NOT NULL,
  title           NVARCHAR(30) NOT NULL,
  titleofcourtesy NVARCHAR(25) NOT NULL,
  birthdate       DATE         NOT NULL,
  hiredate        DATE         NOT NULL,
  address         NVARCHAR(60) NOT NULL,
  city            NVARCHAR(15) NOT NULL,
  region          NVARCHAR(15) NULL,
  postalcode      NVARCHAR(10) NULL,
  country         NVARCHAR(15) NOT NULL,
  phone           NVARCHAR(24) NOT NULL,
  mgrid           INT          NULL,
  CONSTRAINT PK_Employees_Migration PRIMARY KEY(empid)
);


-- Create table EXT.Employees_Migration
CREATE TABLE EXT.Employees_Migration_2
(
  empid           INT          NOT NULL IDENTITY,
  lastname        NVARCHAR(20) NOT NULL,
  firstname       NVARCHAR(10) NOT NULL,
  title           NVARCHAR(30) NOT NULL,
  titleofcourtesy NVARCHAR(25) NOT NULL,
  birthdate       DATE         NOT NULL,
  hiredate        DATE         NOT NULL,
  address         NVARCHAR(60) NOT NULL,
  city            NVARCHAR(15) NOT NULL,
  region          NVARCHAR(15) NULL,
  postalcode      NVARCHAR(10) NULL,
  country         NVARCHAR(15) NOT NULL,
  phone           NVARCHAR(24) NOT NULL,
  mgrid           INT          NULL,
  CONSTRAINT PK_EmployeesMigration_2 PRIMARY KEY(empid)
);
GO

CREATE VIEW HR.vw_Employees_Migration 
AS 
SELECT 
	empid           
,	fullname	= firstname + ' ' + lastname
FROM	
	HR.Employees_Migration
GO
