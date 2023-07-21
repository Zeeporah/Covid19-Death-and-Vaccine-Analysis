# Covid_Query

 This README document provides an overview of the COVID data analysis performed using SQL. It includes the SQL queries used to analyze the data and provides insights into the COVID cases, death rates, and vaccination progress in different locations.

Overview
The SQL queries in this analysis are focused on the Covid_death table and the Covid_vaccine table. The data is related to COVID-19 cases, deaths, and vaccination information. The main objective is to gain insights into the COVID-19 situation worldwide, examining death rates, infection rates, and vaccination progress in different countries and continents.

Queries and Insights
Select All Data

The initial step was to view the data in the Covid_death table by selecting all columns and rows to understand the dataset.

Data Type Modification

The total_cases and total_deaths columns were altered to be of data type INT.

Death Percentage Calculation

The query calculates the death percentage for each record by dividing total_deaths by total_cases and multiplying by 100.

Death Rate in Specific Countries (e.g., United Kingdom)

The query filters data for specific countries (e.g., United Kingdom) and calculates the death percentage.

Percentage of Population Affected by COVID-19

This query calculates the percentage of the population that has COVID-19 in specific countries (e.g., United Kingdom).

Top Ten Countries with the Highest Infection Rates

This query identifies the top ten countries with the highest infection rates compared to their populations.

Countries with the Highest Death Count per Population

The query identifies countries with the highest total death count per population.

Continents with the Highest Death Rates

The query drills down to analyze continents with the highest death rates.

Death Percentage by Date Across the World

This query calculates the death percentage by date for all available continents.

Total COVID-19 Cases in the World

The query provides the total number of COVID-19 cases, total deaths, and the death percentage worldwide.

Joining COVID-19 Death and Vaccination Data

The query joins the Covid_death and Covid_vaccine tables based on location and date to analyze COVID-19 vaccination data.

Population Vaccinated Percentage

This query calculates the percentage of the population that received vaccinations based on the Covid_death and Covid_vaccine data.

Creating a View

A view named PopulationVaccinated is created to simplify future queries related to population and vaccination data.

Tableau Queries

SQL queries for specific Tableau analyses were also provided in the SQL script.

Conclusion
This README provides an overview of the SQL analysis conducted on COVID-19 data. It includes a series of SQL queries that help in understanding the COVID-19 situation, death rates, infection rates, and vaccination progress across different countries and continents. The analysis can be further extended to provide more insights and visualizations using tools like Tableau.

Feel free to use and modify these SQL queries to conduct further analysis and gain deeper insights into the COVID-19 data.
