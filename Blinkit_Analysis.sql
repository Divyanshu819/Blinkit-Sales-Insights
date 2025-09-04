Select * from blinkit_data;

-- DATA CLEANING

Select Distinct(item_Fat_Content) from blinkit_data;

UPDATE blinkit_data
SET Item_Fat_Content =
CASE
WHEN Item_Fat_Content in ('low fat', 'LF') then 'Low Fat'
WHEN Item_Fat_Content = 'reg' then 'Regular'
ELSE Item_Fat_Content
END;

Select Distinct(item_Fat_Content) from blinkit_data;

-- KPI REQUIREMENTS :-

--Total Sales

Select CAST(SUM(Total_Sales)/1000000 as DECIMAL(10,2)) as Total_Sales_Millions 
from blinkit_data;

-- Avg Sales

Select CAST(AVG(Total_Sales) as DECIMAL(10,1)) as Avg_Sales from blinkit_data;

-- No of Items

Select COUNT(*) as No_Of_Items from blinkit_data;

--Avg Rating

Select CAST(AVG(Rating) as DECIMAL(10,2))as Avg_Rating from blinkit_data;

-- CHARTS REQUIREMENT :-

--Total Sales by Fat Content

Select Item_fat_content, 
		CAST (Sum(Total_Sales) as DECIMAL(10,2)) as Total_Sales,
		CAST(AVG(Total_Sales) as DECIMAL(10,1)) as Avg_Sales,
		COUNT(*) as No_Of_Items,
		CAST(AVG(Rating) as DECIMAL(10,2))as Avg_Rating
from blinkit_data
Group by Item_Fat_Content
order by Total_Sales Desc;

-- Total Sales by Item Type

Select Item_Type, 
		CAST (Sum(Total_Sales) as DECIMAL(10,2)) as Total_Sales,
		CAST(AVG(Total_Sales) as DECIMAL(10,1)) as Avg_Sales,
		COUNT(*) as No_Of_Items,
		CAST(AVG(Rating) as DECIMAL(10,2))as Avg_Rating
from blinkit_data
Group by Item_Type
order by Total_Sales Desc;

-- Fat Content by Outlet for Total Sales

10-SELECT Outlet_Location_Type, 
       ISNULL([Low Fat], 0) AS Low_Fat, 
       ISNULL([Regular], 0) AS Regular
FROM 
(
    SELECT Outlet_Location_Type, Item_Fat_Content, 
           CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
    FROM blinkit_data
    GROUP BY Outlet_Location_Type, Item_Fat_Content
) AS SourceTable
PIVOT 
(
    SUM(Total_Sales) 
    FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY Outlet_Location_Type;

-- Total Sales by Outlet Establishment

Select Outlet_Establishment_Year,
		CAST(Sum(Total_Sales) as decimal(10,2)) as Total_Sales,
		CAST(AVG(Total_Sales) as DECIMAL(10,1)) as Avg_Sales,
		COUNT(*) as No_Of_Items,
		CAST(AVG(Rating) as DECIMAL(10,2))as Avg_Rating
from blinkit_data
Group by Outlet_Establishment_Year
order by Outlet_Establishment_Year Asc;

-- Percentage of Sales by Outlet Size

Select Outlet_Size,
		CAST(sum(Total_Sales) as DECIMAL(10,2))as Total_Sales,
		CAST((SUM(Total_Sales) *100 / SUM(SUM(Total_Sales)) over ()) as DECIMAL(10,2)) as Sales_Percentage
From blinkit_data
Group by Outlet_Size
Order by Total_Sales desc;

-- Sales by Outlet Location

Select Outlet_Location_Type,
		CAST(Sum(Total_Sales) as DECIMAL(10,2))as Total_Sales,
		CAST((SUM(Total_Sales) *100 / SUM(SUM(Total_Sales)) over ()) as DECIMAL(10,2)) as Sales_Percentage
From blinkit_data
Group by Outlet_Location_Type
Order by Total_Sales Desc;

-- All Metrics by Outlet Type

Select Outlet_Type,
		CAST(Sum(Total_Sales) as decimal(10,2)) as Total_Sales,
		CAST((SUM(Total_Sales) *100 / SUM(SUM(Total_Sales)) over ()) as DECIMAL(10,2)) as Sales_Percentage,
		CAST(AVG(Total_Sales) as DECIMAL(10,1)) as Avg_Sales,
		COUNT(*) as No_Of_Items,
		CAST(AVG(Rating) as DECIMAL(10,2))as Avg_Rating
from blinkit_data
Group by Outlet_Type
order by Total_Sales Desc;



