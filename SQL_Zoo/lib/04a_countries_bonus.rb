# == Schema Information
#
# Table name: countries
#
#  name        :string       not null, primary key
#  continent   :string
#  area        :integer
#  population  :integer
#  gdp         :integer

require_relative './sqlzoo.rb'

# BONUS QUESTIONS: These problems require knowledge of aggregate
# functions. Attempt them after completing section 05.

def highest_gdp
  # Which countries have a GDP greater than every country in Europe? (Give the
  # name only. Some countries may have NULL gdp values)
  execute(<<-SQL)
  SELECT
    countries.name
  FROM
    countries
  WHERE
    countries.gdp > (
      SELECT
        countries.gdp
      FROM
        countries
      WHERE
        countries.continent = 'Europe' AND countries.gdp IS NOT NULL
      ORDER BY
        countries.gdp DESC
      LIMIT 1
    )
  SQL
end

def largest_in_continent
  # Find the largest country (by area) in each continent. Show the continent,
  # name, and area.
  execute(<<-SQL)
  SELECT
    DISTINCT ON (countries.continent) countries.continent, countries.name, countries.area
  FROM
    countries
  ORDER BY
     countries.continent, countries.area DESC, countries.name

  SQL
end

def large_neighbors
  # Some countries have populations more than three times that of any of their
  # neighbors (in the same continent). Give the countries and continents.
  execute(<<-SQL)
  SELECT
    MAX(t.population), Max(w.population)
  FROM
    (
      SELECT
        countries.name, countries.continent, countries.population
      FROM
        countries
      ORDER BY
        countries.continent, countries.population DESC
    ) as t
  JOIN
  (
    SELECT
      countries.name, countries.continent, countries.population
    FROM
      countries
    ORDER BY
      countries.continent, countries.population DESC
  ) as w ON t.name = w.name
  WHERE
    w.population <   (
        SELECT
          countries.name, countries.continent, MAX(countries.population)
        FROM
          countries
        GROUP BY
          countries.name
        ORDER BY
          countries.continent, countries.population DESC
      ) as t
  GROUP BY
    t.continent
  SQL
end
