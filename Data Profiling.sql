


USE CopyBrazilianECommerce

-- All tables, their columns and their data types
SELECT Table_Name,
Column_Name,
Data_Type,
Character_Maximum_Length
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_CATALOG = 'CopyBrazilianECommerce' 
ORDER BY TABLE_NAME, ORDINAL_POSITION