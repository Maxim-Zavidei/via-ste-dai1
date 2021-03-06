USE [master]
GO

/****** Object:  Database [northwindDW]    Script Date: 5/1/2022 14:44:12 ******/
CREATE DATABASE [northwindDW]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'northwindDW', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\northwindDW.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'northwindDW_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\northwindDW_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [northwindDW].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [northwindDW] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [northwindDW] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [northwindDW] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [northwindDW] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [northwindDW] SET ARITHABORT OFF 
GO

ALTER DATABASE [northwindDW] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [northwindDW] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [northwindDW] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [northwindDW] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [northwindDW] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [northwindDW] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [northwindDW] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [northwindDW] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [northwindDW] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [northwindDW] SET  DISABLE_BROKER 
GO

ALTER DATABASE [northwindDW] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [northwindDW] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [northwindDW] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [northwindDW] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [northwindDW] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [northwindDW] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [northwindDW] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [northwindDW] SET RECOVERY FULL 
GO

ALTER DATABASE [northwindDW] SET  MULTI_USER 
GO

ALTER DATABASE [northwindDW] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [northwindDW] SET DB_CHAINING OFF 
GO

ALTER DATABASE [northwindDW] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO

ALTER DATABASE [northwindDW] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO

ALTER DATABASE [northwindDW] SET DELAYED_DURABILITY = DISABLED 
GO

ALTER DATABASE [northwindDW] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO

ALTER DATABASE [northwindDW] SET QUERY_STORE = OFF
GO

ALTER DATABASE [northwindDW] SET  READ_WRITE 
GO

USE [northwindDW]
GO

CREATE SCHEMA [stage]
GO

CREATE SCHEMA [edw]
GO
