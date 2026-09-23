USE [master]
GO
/****** Object:  Database [LostFoundDB]    Script Date: 23-09-2026 19:43:36 ******/
CREATE DATABASE [LostFoundDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'LostFoundDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL17.MSSQLSERVER\MSSQL\DATA\LostFoundDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'LostFoundDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL17.MSSQLSERVER\MSSQL\DATA\LostFoundDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [LostFoundDB] SET COMPATIBILITY_LEVEL = 170
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [LostFoundDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [LostFoundDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [LostFoundDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [LostFoundDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [LostFoundDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [LostFoundDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [LostFoundDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [LostFoundDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [LostFoundDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [LostFoundDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [LostFoundDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [LostFoundDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [LostFoundDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [LostFoundDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [LostFoundDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [LostFoundDB] SET  ENABLE_BROKER 
GO
ALTER DATABASE [LostFoundDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [LostFoundDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [LostFoundDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [LostFoundDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [LostFoundDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [LostFoundDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [LostFoundDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [LostFoundDB] SET RECOVERY FULL 
GO
ALTER DATABASE [LostFoundDB] SET  MULTI_USER 
GO
ALTER DATABASE [LostFoundDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [LostFoundDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [LostFoundDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [LostFoundDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [LostFoundDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [LostFoundDB] SET OPTIMIZED_LOCKING = OFF 
GO
ALTER DATABASE [LostFoundDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'LostFoundDB', N'ON'
GO
ALTER DATABASE [LostFoundDB] SET QUERY_STORE = ON
GO
ALTER DATABASE [LostFoundDB] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [LostFoundDB]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 23-09-2026 19:43:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[FullName] [varchar](100) NOT NULL,
	[Email] [varchar](150) NOT NULL,
	[PasswordHash] [varchar](255) NOT NULL,
	[Phone] [varchar](15) NULL,
	[Role] [varchar](20) NOT NULL,
	[CreatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 23-09-2026 19:43:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[CategoryID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [varchar](100) NOT NULL,
	[Description] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Locations]    Script Date: 23-09-2026 19:43:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Locations](
	[LocationID] [int] IDENTITY(1,1) NOT NULL,
	[LocationName] [varchar](150) NOT NULL,
	[Description] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[LocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LostItems]    Script Date: 23-09-2026 19:43:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LostItems](
	[LostItemID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[CategoryID] [int] NOT NULL,
	[LocationID] [int] NOT NULL,
	[ItemName] [varchar](150) NOT NULL,
	[Description] [varchar](1000) NULL,
	[Color] [varchar](50) NULL,
	[Brand] [varchar](100) NULL,
	[DateLost] [date] NOT NULL,
	[Status] [varchar](30) NULL,
	[CreatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[LostItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_LostItems]    Script Date: 23-09-2026 19:43:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[vw_LostItems]
AS
SELECT
    L.LostItemID,
    L.UserID,
    U.FullName,
    U.Email,
    L.CategoryID,
    C.CategoryName,
    L.LocationID,
    Loc.LocationName,
    L.ItemName,
    L.Description,
    L.Color,
    L.Brand,
    L.DateLost,
    L.Status,
    L.CreatedAt
FROM dbo.LostItems AS L
INNER JOIN dbo.Users AS U
    ON L.UserID = U.UserID
INNER JOIN dbo.Categories AS C
    ON L.CategoryID = C.CategoryID
INNER JOIN dbo.Locations AS Loc
    ON L.LocationID = Loc.LocationID;
GO
/****** Object:  Table [dbo].[FoundItems]    Script Date: 23-09-2026 19:43:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FoundItems](
	[FoundItemID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[CategoryID] [int] NOT NULL,
	[LocationID] [int] NOT NULL,
	[ItemName] [varchar](150) NOT NULL,
	[Description] [varchar](1000) NULL,
	[Color] [varchar](50) NULL,
	[Brand] [varchar](100) NULL,
	[DateFound] [date] NOT NULL,
	[Status] [varchar](30) NULL,
	[CreatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[FoundItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_FoundItems]    Script Date: 23-09-2026 19:43:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[vw_FoundItems]
AS
SELECT
    F.FoundItemID,
    F.UserID,
    U.FullName,
    U.Email,
    F.CategoryID,
    C.CategoryName,
    F.LocationID,
    Loc.LocationName,
    F.ItemName,
    F.Description,
    F.Color,
    F.Brand,
    F.DateFound,
    F.Status,
    F.CreatedAt
FROM dbo.FoundItems AS F
INNER JOIN dbo.Users AS U
    ON F.UserID = U.UserID
INNER JOIN dbo.Categories AS C
    ON F.CategoryID = C.CategoryID
INNER JOIN dbo.Locations AS Loc
    ON F.LocationID = Loc.LocationID;
GO
/****** Object:  Table [dbo].[Claims]    Script Date: 23-09-2026 19:43:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Claims](
	[ClaimID] [int] IDENTITY(1,1) NOT NULL,
	[FoundItemID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[ClaimDescription] [varchar](1000) NULL,
	[ClaimDate] [datetime] NULL,
	[Status] [varchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[ClaimID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ItemImages]    Script Date: 23-09-2026 19:43:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ItemImages](
	[ImageID] [int] IDENTITY(1,1) NOT NULL,
	[LostItemID] [int] NULL,
	[FoundItemID] [int] NULL,
	[ImageURL] [varchar](500) NOT NULL,
	[UploadedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ImageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Matches]    Script Date: 23-09-2026 19:43:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Matches](
	[MatchID] [int] IDENTITY(1,1) NOT NULL,
	[LostItemID] [int] NOT NULL,
	[FoundItemID] [int] NOT NULL,
	[MatchPercentage] [decimal](5, 2) NULL,
	[MatchStatus] [varchar](30) NULL,
	[CreatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[MatchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Notifications]    Script Date: 23-09-2026 19:43:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Notifications](
	[NotificationID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[Message] [varchar](500) NOT NULL,
	[IsRead] [bit] NULL,
	[CreatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[NotificationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Categories] ON 

INSERT [dbo].[Categories] ([CategoryID], [CategoryName], [Description]) VALUES (1, N'Electronics', N'Mobile phones, laptops, tablets, chargers and other electronic items')
INSERT [dbo].[Categories] ([CategoryID], [CategoryName], [Description]) VALUES (2, N'Documents', N'ID cards, certificates, driving licence and other documents')
INSERT [dbo].[Categories] ([CategoryID], [CategoryName], [Description]) VALUES (3, N'Wallet', N'Wallets, purses and money holders')
INSERT [dbo].[Categories] ([CategoryID], [CategoryName], [Description]) VALUES (4, N'Keys', N'House keys, vehicle keys and other keys')
INSERT [dbo].[Categories] ([CategoryID], [CategoryName], [Description]) VALUES (5, N'Jewellery', N'Rings, chains, watches and other jewellery')
INSERT [dbo].[Categories] ([CategoryID], [CategoryName], [Description]) VALUES (6, N'Bags', N'Backpacks, handbags and other bags')
INSERT [dbo].[Categories] ([CategoryID], [CategoryName], [Description]) VALUES (7, N'Books', N'Books, notebooks and study material')
INSERT [dbo].[Categories] ([CategoryID], [CategoryName], [Description]) VALUES (8, N'Clothing', N'Jackets, shirts, shoes and other clothing')
INSERT [dbo].[Categories] ([CategoryID], [CategoryName], [Description]) VALUES (9, N'Other', N'Other items not covered by the above categories')
SET IDENTITY_INSERT [dbo].[Categories] OFF
GO
SET IDENTITY_INSERT [dbo].[Claims] ON 

INSERT [dbo].[Claims] ([ClaimID], [FoundItemID], [UserID], [ClaimDescription], [ClaimDate], [Status]) VALUES (1, 2, 2, N'I believe this is my laptop. It was lost in the college laboratory and the laptop brand is HP.', CAST(N'2026-09-21T19:20:52.847' AS DateTime), N'Approved')
SET IDENTITY_INSERT [dbo].[Claims] OFF
GO
SET IDENTITY_INSERT [dbo].[FoundItems] ON 

INSERT [dbo].[FoundItems] ([FoundItemID], [UserID], [CategoryID], [LocationID], [ItemName], [Description], [Color], [Brand], [DateFound], [Status], [CreatedAt]) VALUES (1, 1, 3, 2, N'Black Wallet', N'Leather wallet', N'Black', NULL, CAST(N'2026-08-01' AS Date), N'Found', CAST(N'2026-09-21T18:59:16.643' AS DateTime))
INSERT [dbo].[FoundItems] ([FoundItemID], [UserID], [CategoryID], [LocationID], [ItemName], [Description], [Color], [Brand], [DateFound], [Status], [CreatedAt]) VALUES (2, 1, 1, 2, N'Dell Laptop', N'Black Dell laptop', N'Black', N'Dell', CAST(N'2026-08-06' AS Date), N'Returned', CAST(N'2026-09-21T18:59:16.643' AS DateTime))
SET IDENTITY_INSERT [dbo].[FoundItems] OFF
GO
SET IDENTITY_INSERT [dbo].[Locations] ON 

INSERT [dbo].[Locations] ([LocationID], [LocationName], [Description]) VALUES (1, N'Main Gate', N'Main entrance gate')
INSERT [dbo].[Locations] ([LocationID], [LocationName], [Description]) VALUES (2, N'Library', N'College library')
INSERT [dbo].[Locations] ([LocationID], [LocationName], [Description]) VALUES (3, N'Canteen', N'College canteen')
INSERT [dbo].[Locations] ([LocationID], [LocationName], [Description]) VALUES (4, N'Computer Lab', N'Computer laboratory')
INSERT [dbo].[Locations] ([LocationID], [LocationName], [Description]) VALUES (5, N'Mechanical Lab', N'Mechanical laboratory')
INSERT [dbo].[Locations] ([LocationID], [LocationName], [Description]) VALUES (6, N'Classroom Block A', N'Classrooms in Block A')
INSERT [dbo].[Locations] ([LocationID], [LocationName], [Description]) VALUES (7, N'Classroom Block B', N'Classrooms in Block B')
INSERT [dbo].[Locations] ([LocationID], [LocationName], [Description]) VALUES (8, N'Parking Area', N'College parking')
INSERT [dbo].[Locations] ([LocationID], [LocationName], [Description]) VALUES (9, N'Hostel', N'College hostel')
INSERT [dbo].[Locations] ([LocationID], [LocationName], [Description]) VALUES (10, N'Sports Ground', N'College sports ground')
INSERT [dbo].[Locations] ([LocationID], [LocationName], [Description]) VALUES (11, N'Auditorium', N'College auditorium')
INSERT [dbo].[Locations] ([LocationID], [LocationName], [Description]) VALUES (12, N'Other', N'Other location')
INSERT [dbo].[Locations] ([LocationID], [LocationName], [Description]) VALUES (25, N'Lab 3', N'Laboratory 3')
INSERT [dbo].[Locations] ([LocationID], [LocationName], [Description]) VALUES (26, N'Block 2', N'College Block 2')
SET IDENTITY_INSERT [dbo].[Locations] OFF
GO
SET IDENTITY_INSERT [dbo].[LostItems] ON 

INSERT [dbo].[LostItems] ([LostItemID], [UserID], [CategoryID], [LocationID], [ItemName], [Description], [Color], [Brand], [DateLost], [Status], [CreatedAt]) VALUES (2, 2, 1, 25, N'HP Laptop', N'Silver HP laptop', N'Silver', N'HP', CAST(N'2026-08-03' AS Date), N'Lost', CAST(N'2026-09-21T18:59:16.613' AS DateTime))
INSERT [dbo].[LostItems] ([LostItemID], [UserID], [CategoryID], [LocationID], [ItemName], [Description], [Color], [Brand], [DateLost], [Status], [CreatedAt]) VALUES (3, 3, 2, 26, N'Student ID', N'College identity card', NULL, NULL, CAST(N'2026-08-05' AS Date), N'Recovered', CAST(N'2026-09-21T18:59:16.613' AS DateTime))
SET IDENTITY_INSERT [dbo].[LostItems] OFF
GO
SET IDENTITY_INSERT [dbo].[Matches] ON 

INSERT [dbo].[Matches] ([MatchID], [LostItemID], [FoundItemID], [MatchPercentage], [MatchStatus], [CreatedAt]) VALUES (8, 2, 2, CAST(30.00 AS Decimal(5, 2)), N'Confirmed', CAST(N'2026-09-21T19:14:59.810' AS DateTime))
INSERT [dbo].[Matches] ([MatchID], [LostItemID], [FoundItemID], [MatchPercentage], [MatchStatus], [CreatedAt]) VALUES (11, 2, 1, CAST(0.00 AS Decimal(5, 2)), N'Pending', CAST(N'2026-09-22T00:13:08.113' AS DateTime))
SET IDENTITY_INSERT [dbo].[Matches] OFF
GO
SET IDENTITY_INSERT [dbo].[Notifications] ON 

INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1, 2, N'Your lost and found claim has been approved by the administrator.', 1, CAST(N'2026-09-21T19:29:22.513' AS DateTime))
SET IDENTITY_INSERT [dbo].[Notifications] OFF
GO
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([UserID], [FullName], [Email], [PasswordHash], [Phone], [Role], [CreatedAt]) VALUES (1, N'Admin User', N'admin@example.com', N'PUBLIC_TEST_PASSWORD', N'0000000000', N'Admin', CAST(N'2026-09-21T18:44:51.307' AS DateTime))
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [PasswordHash], [Phone], [Role], [CreatedAt]) VALUES (2, N'Rahul Sharma', N'rahul@example.com', N'PUBLIC_TEST_PASSWORD', N'0000000001', N'User', CAST(N'2026-09-21T18:44:51.307' AS DateTime))
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [PasswordHash], [Phone], [Role], [CreatedAt]) VALUES (3, N'Aman Kumar', N'aman@example.com', N'PUBLIC_TEST_PASSWORD', N'0000000002', N'User', CAST(N'2026-09-21T18:44:51.307' AS DateTime))
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [PasswordHash], [Phone], [Role], [CreatedAt]) VALUES (4, N'Priya Singh', N'priya@example.com', N'PUBLIC_TEST_PASSWORD', N'0000000003', N'User', CAST(N'2026-09-21T18:44:51.307' AS DateTime))
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [PasswordHash], [Phone], [Role], [CreatedAt]) VALUES (5, N'Neha Verma', N'neha@example.com', N'PUBLIC_TEST_PASSWORD', N'0000000004', N'User', CAST(N'2026-09-21T18:44:51.307' AS DateTime))
SET IDENTITY_INSERT [dbo].[Users] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Categori__8517B2E075A63349]    Script Date: 23-09-2026 19:43:39 ******/
ALTER TABLE [dbo].[Categories] ADD UNIQUE NONCLUSTERED 
(
	[CategoryName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_Categories_CategoryName]    Script Date: 23-09-2026 19:43:39 ******/
ALTER TABLE [dbo].[Categories] ADD  CONSTRAINT [UQ_Categories_CategoryName] UNIQUE NONCLUSTERED 
(
	[CategoryName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_FoundItems_Category]    Script Date: 23-09-2026 19:43:39 ******/
CREATE NONCLUSTERED INDEX [IX_FoundItems_Category] ON [dbo].[FoundItems]
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_FoundItems_Location]    Script Date: 23-09-2026 19:43:39 ******/
CREATE NONCLUSTERED INDEX [IX_FoundItems_Location] ON [dbo].[FoundItems]
(
	[LocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_FoundItems_Status]    Script Date: 23-09-2026 19:43:39 ******/
CREATE NONCLUSTERED INDEX [IX_FoundItems_Status] ON [dbo].[FoundItems]
(
	[Status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_Locations_LocationName]    Script Date: 23-09-2026 19:43:39 ******/
ALTER TABLE [dbo].[Locations] ADD  CONSTRAINT [UQ_Locations_LocationName] UNIQUE NONCLUSTERED 
(
	[LocationName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_LostItems_Category]    Script Date: 23-09-2026 19:43:39 ******/
CREATE NONCLUSTERED INDEX [IX_LostItems_Category] ON [dbo].[LostItems]
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_LostItems_Location]    Script Date: 23-09-2026 19:43:39 ******/
CREATE NONCLUSTERED INDEX [IX_LostItems_Location] ON [dbo].[LostItems]
(
	[LocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_LostItems_Status]    Script Date: 23-09-2026 19:43:39 ******/
CREATE NONCLUSTERED INDEX [IX_LostItems_Status] ON [dbo].[LostItems]
(
	[Status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Matches_FoundItem]    Script Date: 23-09-2026 19:43:39 ******/
CREATE NONCLUSTERED INDEX [IX_Matches_FoundItem] ON [dbo].[Matches]
(
	[FoundItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Matches_LostItem]    Script Date: 23-09-2026 19:43:39 ******/
CREATE NONCLUSTERED INDEX [IX_Matches_LostItem] ON [dbo].[Matches]
(
	[LostItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Users__A9D10534821FB921]    Script Date: 23-09-2026 19:43:39 ******/
ALTER TABLE [dbo].[Users] ADD UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_Users_Email]    Script Date: 23-09-2026 19:43:39 ******/
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [UQ_Users_Email] UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Claims] ADD  DEFAULT (getdate()) FOR [ClaimDate]
GO
ALTER TABLE [dbo].[Claims] ADD  DEFAULT ('Pending') FOR [Status]
GO
ALTER TABLE [dbo].[FoundItems] ADD  DEFAULT ('Found') FOR [Status]
GO
ALTER TABLE [dbo].[FoundItems] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[ItemImages] ADD  DEFAULT (getdate()) FOR [UploadedAt]
GO
ALTER TABLE [dbo].[LostItems] ADD  DEFAULT ('Lost') FOR [Status]
GO
ALTER TABLE [dbo].[LostItems] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Matches] ADD  DEFAULT ('Possible') FOR [MatchStatus]
GO
ALTER TABLE [dbo].[Matches] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Notifications] ADD  DEFAULT ((0)) FOR [IsRead]
GO
ALTER TABLE [dbo].[Notifications] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ('User') FOR [Role]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Claims]  WITH CHECK ADD  CONSTRAINT [FK_Claims_FoundItem] FOREIGN KEY([FoundItemID])
REFERENCES [dbo].[FoundItems] ([FoundItemID])
GO
ALTER TABLE [dbo].[Claims] CHECK CONSTRAINT [FK_Claims_FoundItem]
GO
ALTER TABLE [dbo].[Claims]  WITH CHECK ADD  CONSTRAINT [FK_Claims_User] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[Claims] CHECK CONSTRAINT [FK_Claims_User]
GO
ALTER TABLE [dbo].[FoundItems]  WITH CHECK ADD  CONSTRAINT [FK_FoundItems_Category] FOREIGN KEY([CategoryID])
REFERENCES [dbo].[Categories] ([CategoryID])
GO
ALTER TABLE [dbo].[FoundItems] CHECK CONSTRAINT [FK_FoundItems_Category]
GO
ALTER TABLE [dbo].[FoundItems]  WITH CHECK ADD  CONSTRAINT [FK_FoundItems_Location] FOREIGN KEY([LocationID])
REFERENCES [dbo].[Locations] ([LocationID])
GO
ALTER TABLE [dbo].[FoundItems] CHECK CONSTRAINT [FK_FoundItems_Location]
GO
ALTER TABLE [dbo].[FoundItems]  WITH CHECK ADD  CONSTRAINT [FK_FoundItems_User] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[FoundItems] CHECK CONSTRAINT [FK_FoundItems_User]
GO
ALTER TABLE [dbo].[ItemImages]  WITH CHECK ADD  CONSTRAINT [FK_ItemImages_Found] FOREIGN KEY([FoundItemID])
REFERENCES [dbo].[FoundItems] ([FoundItemID])
GO
ALTER TABLE [dbo].[ItemImages] CHECK CONSTRAINT [FK_ItemImages_Found]
GO
ALTER TABLE [dbo].[ItemImages]  WITH CHECK ADD  CONSTRAINT [FK_ItemImages_Lost] FOREIGN KEY([LostItemID])
REFERENCES [dbo].[LostItems] ([LostItemID])
GO
ALTER TABLE [dbo].[ItemImages] CHECK CONSTRAINT [FK_ItemImages_Lost]
GO
ALTER TABLE [dbo].[LostItems]  WITH CHECK ADD  CONSTRAINT [FK_LostItems_Category] FOREIGN KEY([CategoryID])
REFERENCES [dbo].[Categories] ([CategoryID])
GO
ALTER TABLE [dbo].[LostItems] CHECK CONSTRAINT [FK_LostItems_Category]
GO
ALTER TABLE [dbo].[LostItems]  WITH CHECK ADD  CONSTRAINT [FK_LostItems_Location] FOREIGN KEY([LocationID])
REFERENCES [dbo].[Locations] ([LocationID])
GO
ALTER TABLE [dbo].[LostItems] CHECK CONSTRAINT [FK_LostItems_Location]
GO
ALTER TABLE [dbo].[LostItems]  WITH CHECK ADD  CONSTRAINT [FK_LostItems_User] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[LostItems] CHECK CONSTRAINT [FK_LostItems_User]
GO
ALTER TABLE [dbo].[Matches]  WITH CHECK ADD  CONSTRAINT [FK_Matches_Found] FOREIGN KEY([FoundItemID])
REFERENCES [dbo].[FoundItems] ([FoundItemID])
GO
ALTER TABLE [dbo].[Matches] CHECK CONSTRAINT [FK_Matches_Found]
GO
ALTER TABLE [dbo].[Matches]  WITH CHECK ADD  CONSTRAINT [FK_Matches_Lost] FOREIGN KEY([LostItemID])
REFERENCES [dbo].[LostItems] ([LostItemID])
GO
ALTER TABLE [dbo].[Matches] CHECK CONSTRAINT [FK_Matches_Lost]
GO
ALTER TABLE [dbo].[Notifications]  WITH CHECK ADD  CONSTRAINT [FK_Notifications_User] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[Notifications] CHECK CONSTRAINT [FK_Notifications_User]
GO
ALTER TABLE [dbo].[Claims]  WITH CHECK ADD  CONSTRAINT [CK_Claims_Status] CHECK  (([Status]='Rejected' OR [Status]='Approved' OR [Status]='Pending'))
GO
ALTER TABLE [dbo].[Claims] CHECK CONSTRAINT [CK_Claims_Status]
GO
ALTER TABLE [dbo].[FoundItems]  WITH CHECK ADD  CONSTRAINT [CK_FoundItems_Status] CHECK  (([Status]='Closed' OR [Status]='Returned' OR [Status]='Claimed' OR [Status]='Found'))
GO
ALTER TABLE [dbo].[FoundItems] CHECK CONSTRAINT [CK_FoundItems_Status]
GO
ALTER TABLE [dbo].[LostItems]  WITH CHECK ADD  CONSTRAINT [CK_LostItems_Status] CHECK  (([Status]='Closed' OR [Status]='Recovered' OR [Status]='Matched' OR [Status]='Lost'))
GO
ALTER TABLE [dbo].[LostItems] CHECK CONSTRAINT [CK_LostItems_Status]
GO
ALTER TABLE [dbo].[Matches]  WITH CHECK ADD  CONSTRAINT [CK_Matches_Percentage] CHECK  (([MatchPercentage]>=(0) AND [MatchPercentage]<=(100)))
GO
ALTER TABLE [dbo].[Matches] CHECK CONSTRAINT [CK_Matches_Percentage]
GO
ALTER TABLE [dbo].[Matches]  WITH CHECK ADD  CONSTRAINT [CK_Matches_Status] CHECK  (([MatchStatus]='Rejected' OR [MatchStatus]='Confirmed' OR [MatchStatus]='Pending'))
GO
ALTER TABLE [dbo].[Matches] CHECK CONSTRAINT [CK_Matches_Status]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [CK_Users_Role] CHECK  (([Role]='Admin' OR [Role]='User'))
GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [CK_Users_Role]
GO
/****** Object:  StoredProcedure [dbo].[sp_AdminDashboardStats]    Script Date: 23-09-2026 19:43:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_AdminDashboardStats]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        (SELECT COUNT(*) FROM dbo.Users) AS TotalUsers,

        (SELECT COUNT(*)
         FROM dbo.LostItems
         WHERE Status <> 'Closed') AS ActiveLostItems,

        (SELECT COUNT(*)
         FROM dbo.FoundItems
         WHERE Status <> 'Closed') AS ActiveFoundItems,

        (SELECT COUNT(*)
         FROM dbo.Matches
         WHERE MatchStatus = 'Pending') AS PendingMatches,

        (SELECT COUNT(*)
         FROM dbo.Claims
         WHERE Status = 'Pending') AS PendingClaims,

        (SELECT COUNT(*)
         FROM dbo.LostItems
         WHERE Status = 'Recovered') AS RecoveredItems,

        (SELECT COUNT(*)
         FROM dbo.FoundItems
         WHERE Status = 'Returned') AS ReturnedItems;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ApproveClaim]    Script Date: 23-09-2026 19:43:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_ApproveClaim]
    @ClaimID INT,
    @AdminUserID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        BEGIN TRANSACTION;

        DECLARE @UserID INT;
        DECLARE @FoundItemID INT;
        DECLARE @LostItemID INT;

        /* =========================================
           1. Verify Admin
           ========================================= */

        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Users
            WHERE UserID = @AdminUserID
              AND Role = 'Admin'
        )
        BEGIN
            RAISERROR('Only an Admin can approve claims.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;


        /* =========================================
           2. Get Claim Information
           ========================================= */

        SELECT
            @UserID = UserID,
            @FoundItemID = FoundItemID
        FROM dbo.Claims
        WHERE ClaimID = @ClaimID
          AND Status = 'Pending';


        IF @UserID IS NULL
        BEGIN
            RAISERROR('Claim does not exist or is not pending.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;


        /* =========================================
           3. Find Matching Lost Item
           ========================================= */

        SELECT TOP 1
            @LostItemID = M.LostItemID
        FROM dbo.Matches M
        INNER JOIN dbo.LostItems L
            ON M.LostItemID = L.LostItemID
        WHERE M.FoundItemID = @FoundItemID
          AND L.UserID = @UserID
          AND M.MatchStatus = 'Pending'
        ORDER BY M.MatchPercentage DESC;


        /* =========================================
           4. Approve Claim
           ========================================= */

        UPDATE dbo.Claims
        SET Status = 'Approved',
            ClaimDate = ISNULL(ClaimDate, GETDATE())
        WHERE ClaimID = @ClaimID;


        /* =========================================
           5. Update Found Item
           ========================================= */

        UPDATE dbo.FoundItems
        SET Status = 'Returned'
        WHERE FoundItemID = @FoundItemID;


        /* =========================================
           6. Update Lost Item
           ========================================= */

        IF @LostItemID IS NOT NULL
        BEGIN
            UPDATE dbo.LostItems
            SET Status = 'Recovered'
            WHERE LostItemID = @LostItemID;
        END;


        /* =========================================
           7. Confirm Match
           ========================================= */

        IF @LostItemID IS NOT NULL
        BEGIN
            UPDATE dbo.Matches
            SET MatchStatus = 'Confirmed'
            WHERE LostItemID = @LostItemID
              AND FoundItemID = @FoundItemID;
        END;


        /* =========================================
           8. Create Notification
           ========================================= */

        INSERT INTO dbo.Notifications
        (
            UserID,
            Message,
            IsRead,
            CreatedAt
        )
        VALUES
        (
            @UserID,
            'Your lost and found claim has been approved by the administrator.',
            0,
            GETDATE()
        );


        /* =========================================
           9. Commit
           ========================================= */

        COMMIT TRANSACTION;


        /* =========================================
           10. Return Result
           ========================================= */

        SELECT
            'Claim approved successfully.' AS Message,
            @ClaimID AS ClaimID,
            @UserID AS UserID,
            @FoundItemID AS FoundItemID,
            @LostItemID AS LostItemID;

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_CreateNotification]    Script Date: 23-09-2026 19:43:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_CreateNotification]
    @UserID INT,
    @Message VARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Users
        WHERE UserID = @UserID
    )
    BEGIN
        RAISERROR('User does not exist.', 16, 1);
        RETURN;
    END;

    INSERT INTO dbo.Notifications
    (
        UserID,
        Message,
        IsRead,
        CreatedAt
    )
    VALUES
    (
        @UserID,
        @Message,
        0,
        GETDATE()
    );

    SELECT
        NotificationID,
        UserID,
        Message,
        IsRead,
        CreatedAt
    FROM dbo.Notifications
    WHERE NotificationID = SCOPE_IDENTITY();
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_FindMatches]    Script Date: 23-09-2026 19:43:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_FindMatches]
    @LostItemID INT
AS
BEGIN
    SET NOCOUNT ON;

    /* Remove previous pending matches for this lost item */
    DELETE FROM dbo.Matches
    WHERE LostItemID = @LostItemID
      AND MatchStatus = 'Pending';


    /* Generate new possible matches */

    INSERT INTO dbo.Matches
    (
        LostItemID,
        FoundItemID,
        MatchPercentage,
        MatchStatus,
        CreatedAt
    )
    SELECT
        L.LostItemID,
        F.FoundItemID,

        CAST(
            (
                /* Category = 30% */
                CASE
                    WHEN L.CategoryID = F.CategoryID
                    THEN 30
                    ELSE 0
                END

                +

                /* Location = 20% */
                CASE
                    WHEN L.LocationID = F.LocationID
                    THEN 20
                    ELSE 0
                END

                +

                /* Item name = 25% */
                CASE
                    WHEN LOWER(L.ItemName) = LOWER(F.ItemName)
                    THEN 25

                    WHEN LOWER(L.ItemName) LIKE
                         '%' + LOWER(F.ItemName) + '%'
                      OR LOWER(F.ItemName) LIKE
                         '%' + LOWER(L.ItemName) + '%'
                    THEN 15

                    ELSE 0
                END

                +

                /* Brand = 10% */
                CASE
                    WHEN L.Brand IS NOT NULL
                     AND F.Brand IS NOT NULL
                     AND LOWER(L.Brand) = LOWER(F.Brand)
                    THEN 10
                    ELSE 0
                END

                +

                /* Color = 10% */
                CASE
                    WHEN L.Color IS NOT NULL
                     AND F.Color IS NOT NULL
                     AND LOWER(L.Color) = LOWER(F.Color)
                    THEN 10
                    ELSE 0
                END

                +

                /* Description = 5% */
                CASE
                    WHEN L.Description IS NOT NULL
                     AND F.Description IS NOT NULL
                     AND (
                         LOWER(L.Description) LIKE
                         '%' + LOWER(F.ItemName) + '%'
                         OR
                         LOWER(F.Description) LIKE
                         '%' + LOWER(L.ItemName) + '%'
                     )
                    THEN 5
                    ELSE 0
                END
            ) AS DECIMAL(5,2)
        ) AS MatchPercentage,

        'Pending',
        GETDATE()

    FROM dbo.LostItems L
    CROSS JOIN dbo.FoundItems F

    WHERE L.LostItemID = @LostItemID

      /* Don't match already returned/closed items */
      AND F.Status IN ('Found', 'Claimed')

      /* Don't match an item with itself conceptually */
      AND NOT EXISTS
      (
          SELECT 1
          FROM dbo.Matches M
          WHERE M.LostItemID = L.LostItemID
            AND M.FoundItemID = F.FoundItemID
      );
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetFoundItems]    Script Date: 23-09-2026 19:43:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_GetFoundItems]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        F.FoundItemID,
        U.FullName,
        U.Email,
        C.CategoryName,
        L.LocationName,
        F.ItemName,
        F.Description,
        F.Color,
        F.Brand,
        F.DateFound,
        F.Status,
        F.CreatedAt
    FROM dbo.FoundItems F
    INNER JOIN dbo.Users U
        ON F.UserID = U.UserID
    INNER JOIN dbo.Categories C
        ON F.CategoryID = C.CategoryID
    INNER JOIN dbo.Locations L
        ON F.LocationID = L.LocationID
    ORDER BY F.CreatedAt DESC;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetLostItems]    Script Date: 23-09-2026 19:43:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_GetLostItems]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        L.LostItemID,
        U.FullName,
        U.Email,
        C.CategoryName,
        LC.LocationName,
        L.ItemName,
        L.Description,
        L.Color,
        L.Brand,
        L.DateLost,
        L.Status,
        L.CreatedAt
    FROM dbo.LostItems L
    INNER JOIN dbo.Users U
        ON L.UserID = U.UserID
    INNER JOIN dbo.Categories C
        ON L.CategoryID = C.CategoryID
    INNER JOIN dbo.Locations LC
        ON L.LocationID = LC.LocationID
    ORDER BY L.CreatedAt DESC;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetMyClaims]    Script Date: 23-09-2026 19:43:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_GetMyClaims]
    @UserID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        C.ClaimID,
        C.FoundItemID,
        F.ItemName,
        F.Description,
        F.Color,
        F.Brand,
        F.DateFound,
        C.ClaimDescription,
        C.ClaimDate,
        C.Status
    FROM dbo.Claims C
    INNER JOIN dbo.FoundItems F
        ON C.FoundItemID = F.FoundItemID
    WHERE C.UserID = @UserID
    ORDER BY C.ClaimDate DESC;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetMyFoundItems]    Script Date: 23-09-2026 19:43:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_GetMyFoundItems]
    @UserID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        F.FoundItemID,
        C.CategoryName,
        L.LocationName,
        F.ItemName,
        F.Description,
        F.Color,
        F.Brand,
        F.DateFound,
        F.Status,
        F.CreatedAt
    FROM dbo.FoundItems F
    INNER JOIN dbo.Categories C
        ON F.CategoryID = C.CategoryID
    INNER JOIN dbo.Locations L
        ON F.LocationID = L.LocationID
    WHERE F.UserID = @UserID
    ORDER BY F.CreatedAt DESC;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetMyLostItems]    Script Date: 23-09-2026 19:43:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_GetMyLostItems]
    @UserID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        L.LostItemID,
        C.CategoryName,
        LC.LocationName,
        L.ItemName,
        L.Description,
        L.Color,
        L.Brand,
        L.DateLost,
        L.Status,
        L.CreatedAt
    FROM dbo.LostItems L
    INNER JOIN dbo.Categories C
        ON L.CategoryID = C.CategoryID
    INNER JOIN dbo.Locations LC
        ON L.LocationID = LC.LocationID
    WHERE L.UserID = @UserID
    ORDER BY L.CreatedAt DESC;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetMyNotifications]    Script Date: 23-09-2026 19:43:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_GetMyNotifications]
    @UserID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        NotificationID,
        Message,
        IsRead,
        CreatedAt
    FROM dbo.Notifications
    WHERE UserID = @UserID
    ORDER BY CreatedAt DESC;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetPendingClaims]    Script Date: 23-09-2026 19:43:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_GetPendingClaims]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        C.ClaimID,
        C.FoundItemID,
        C.UserID,
        U.FullName,
        U.Email,
        F.ItemName,
        F.Description,
        F.Color,
        F.Brand,
        F.DateFound,
        C.ClaimDescription,
        C.ClaimDate,
        C.Status
    FROM dbo.Claims C
    INNER JOIN dbo.Users U
        ON C.UserID = U.UserID
    INNER JOIN dbo.FoundItems F
        ON C.FoundItemID = F.FoundItemID
    WHERE C.Status = 'Pending'
    ORDER BY C.ClaimDate DESC;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_MarkNotificationRead]    Script Date: 23-09-2026 19:43:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_MarkNotificationRead]
    @NotificationID INT,
    @UserID INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Notifications
    SET IsRead = 1
    WHERE NotificationID = @NotificationID
      AND UserID = @UserID;

    IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('Notification not found or does not belong to this user.', 16, 1);
        RETURN;
    END

    SELECT
        NotificationID,
        UserID,
        Message,
        IsRead,
        CreatedAt
    FROM Notifications
    WHERE NotificationID = @NotificationID;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_RejectClaim]    Script Date: 23-09-2026 19:43:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_RejectClaim]
    @ClaimID INT,
    @AdminUserID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        BEGIN TRANSACTION;

        DECLARE @UserID INT;
        DECLARE @FoundItemID INT;

        /* 1. Check Admin */

        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Users
            WHERE UserID = @AdminUserID
              AND Role = 'Admin'
        )
        BEGIN
            RAISERROR('Only an Admin can reject claims.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;


        /* 2. Get pending claim */

        SELECT
            @UserID = UserID,
            @FoundItemID = FoundItemID
        FROM dbo.Claims
        WHERE ClaimID = @ClaimID
          AND Status = 'Pending';


        IF @UserID IS NULL
        BEGIN
            RAISERROR('Claim does not exist or is not pending.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;


        /* 3. Reject claim */

        UPDATE dbo.Claims
        SET Status = 'Rejected'
        WHERE ClaimID = @ClaimID;


        /* 4. Notify user */

        INSERT INTO dbo.Notifications
        (
            UserID,
            Message,
            IsRead,
            CreatedAt
        )
        VALUES
        (
            @UserID,
            'Your lost and found claim has been rejected by the administrator.',
            0,
            GETDATE()
        );


        COMMIT TRANSACTION;


        SELECT
            'Claim rejected successfully.' AS Message,
            @ClaimID AS ClaimID,
            @UserID AS UserID,
            @FoundItemID AS FoundItemID;

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_SearchFoundItems]    Script Date: 23-09-2026 19:43:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_SearchFoundItems]
    @Search VARCHAR(100) = NULL,
    @CategoryID INT = NULL,
    @LocationID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        F.FoundItemID,
        U.FullName,
        C.CategoryName,
        L.LocationName,
        F.ItemName,
        F.Description,
        F.Color,
        F.Brand,
        F.DateFound,
        F.Status,
        F.CreatedAt
    FROM dbo.FoundItems F
    INNER JOIN dbo.Users U
        ON F.UserID = U.UserID
    INNER JOIN dbo.Categories C
        ON F.CategoryID = C.CategoryID
    INNER JOIN dbo.Locations L
        ON F.LocationID = L.LocationID
    WHERE
        F.Status = 'Found'
        AND
        (
            @Search IS NULL
            OR
            F.ItemName LIKE '%' + @Search + '%'
            OR F.Description LIKE '%' + @Search + '%'
            OR F.Brand LIKE '%' + @Search + '%'
            OR F.Color LIKE '%' + @Search + '%'
        )
        AND
        (@CategoryID IS NULL OR F.CategoryID = @CategoryID)
        AND
        (@LocationID IS NULL OR F.LocationID = @LocationID)
    ORDER BY F.CreatedAt DESC;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_SearchLostItems]    Script Date: 23-09-2026 19:43:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_SearchLostItems]
    @Search NVARCHAR(100) = NULL,
    @CategoryID INT = NULL,
    @LocationID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        L.LostItemID,
        U.FullName,
        C.CategoryName,
        LO.LocationName,
        L.ItemName,
        L.Description,
        L.Color,
        L.Brand,
        L.DateLost,
        L.Status,
        L.CreatedAt
    FROM dbo.LostItems AS L
    LEFT JOIN dbo.Users AS U
        ON L.UserID = U.UserID
    LEFT JOIN dbo.Categories AS C
        ON L.CategoryID = C.CategoryID
    LEFT JOIN dbo.Locations AS LO
        ON L.LocationID = LO.LocationID
    WHERE
        L.Status = 'Lost'
        AND
        (
            @Search IS NULL
            OR @Search = ''
            OR U.FullName LIKE '%' + @Search + '%'
            OR C.CategoryName LIKE '%' + @Search + '%'
            OR LO.LocationName LIKE '%' + @Search + '%'
            OR L.ItemName LIKE '%' + @Search + '%'
            OR L.Description LIKE '%' + @Search + '%'
            OR L.Brand LIKE '%' + @Search + '%'
            OR L.Color LIKE '%' + @Search + '%'
        )
        AND
        (
            @CategoryID IS NULL
            OR L.CategoryID = @CategoryID
        )
        AND
        (
            @LocationID IS NULL
            OR L.LocationID = @LocationID
        )
    ORDER BY L.CreatedAt DESC;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_SubmitClaim]    Script Date: 23-09-2026 19:43:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_SubmitClaim]
    @FoundItemID INT,
    @UserID INT,
    @ClaimDescription VARCHAR(1000)
AS
BEGIN
    SET NOCOUNT ON;

    /* Check that user exists */
    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Users
        WHERE UserID = @UserID
    )
    BEGIN
        RAISERROR('User does not exist.', 16, 1);
        RETURN;
    END;


    /* Check that found item exists */
    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.FoundItems
        WHERE FoundItemID = @FoundItemID
    )
    BEGIN
        RAISERROR('Found item does not exist.', 16, 1);
        RETURN;
    END;


    /* Don't allow duplicate pending claim */
    IF EXISTS
    (
        SELECT 1
        FROM dbo.Claims
        WHERE FoundItemID = @FoundItemID
          AND UserID = @UserID
          AND Status = 'Pending'
    )
    BEGIN
        RAISERROR('You already have a pending claim for this item.', 16, 1);
        RETURN;
    END;


    /* Create claim */
    INSERT INTO dbo.Claims
    (
        FoundItemID,
        UserID,
        ClaimDescription,
        ClaimDate,
        Status
    )
    VALUES
    (
        @FoundItemID,
        @UserID,
        @ClaimDescription,
        GETDATE(),
        'Pending'
    );


    /* Return newly created claim */
    SELECT
        ClaimID,
        FoundItemID,
        UserID,
        ClaimDescription,
        ClaimDate,
        Status
    FROM dbo.Claims
    WHERE ClaimID = SCOPE_IDENTITY();
END;
GO
USE [master]
GO
ALTER DATABASE [LostFoundDB] SET  READ_WRITE 
GO


