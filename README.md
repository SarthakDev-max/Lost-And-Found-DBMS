# Lost and Found Management System

A DBMS-based Lost and Found Management System developed as a college project.

## Current Stage

This repository currently contains the SQL Server database implementation.

## Database

- Database: LostFoundDB
- DBMS: Microsoft SQL Server
- Tables: Users, Categories, Locations, LostItems, FoundItems, Claims, Matches, Notifications, ItemImages
- Views: Lost Items and Found Items
- Stored Procedures: Search, claims, matching, notifications, dashboard and item-management operations
- Constraints: Primary keys, foreign keys, check constraints and unique constraints

## Folder Structure

Lost-and-Found-DBMS/
|
|-- database/
|   -- LostFoundDB.sql
|
-- README.md

## How to Use

1. Open SQL Server Management Studio.
2. Open database/LostFoundDB.sql.
3. Execute the script on a SQL Server instance.
4. The database schema, sample data, views and stored procedures will be created.

## Note

The sample user credentials and contact information in the public SQL script have been replaced with non-sensitive test values.
