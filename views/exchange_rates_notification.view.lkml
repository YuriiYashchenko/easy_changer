# view: exchange_rates_notification {
#   label: "Exchange Rates Notification"
#   derived_table: {
#     sql:
#     SELECT
#       CASE
#         -- Empty Notification for companies, which have only 1 currency (Ex: US companies)
#         WHEN COUNT(exchange) = 0 or -- There are no any currencies entered for company
#           (COUNT(DISTINCT exchange.LocationCurrencyCode) = 1
#           AND COUNT(DISTINCT if(exchange.LocationCurrencyCode = exchange.BaseCurrencyCode, exchange.LocationCurrencyCode,null)) = 1) -- distinguish case, when location filter is applied
#         THEN ""

#         -- Only open source data notification
#         WHEN
#           COUNT(DISTINCT exchange.ExchangeRateCHQ) = 0
#         THEN CONCAT("Exchange Rates to base company currency ", STRING_AGG(DISTINCT exchange.BaseCurrencyCode)," for ", CAST(COUNT(DISTINCT exchange.LocationCurrencyCode) AS STRING),
#           " currencies were used from https://openexchangerates.org/")

#         -- Only CHQ data notification
#         WHEN
#         -- If statement uses when there are 2 different exchange rates for 1 currency during period of dates
#           COUNT(DISTINCT exchange.LocationCurrencyCode) = COUNT(DISTINCT if(exchange.ExchangeRateCHQ IS NOT NULL, exchange.LocationCurrencyCode, null))
#         THEN "All Exchange Rates were used from CHQ"
#         -- Partitial sources data notification. The current priority - using CHQ data
#         ELSE CONCAT("Exchange Rates to base company currency ", STRING_AGG(DISTINCT exchange.BaseCurrencyCode), " for ", CAST(COUNT(DISTINCT if(exchange.ExchangeRateCHQ IS NOT NULL, exchange.LocationCurrencyCode, null)) AS STRING),
#                     " currencies were used from CHQ and for ", CAST((COUNT(DISTINCT exchange.LocationCurrencyCode) - COUNT(DISTINCT if(exchange.ExchangeRateCHQ IS NOT NULL, exchange.LocationCurrencyCode, null))) AS STRING),
#                     " currencies from https://openexchangerates.org/")

#       END AS ExchangeRateCHQ
#       FROM

#       bi_star.flat_sale t
#     WHERE (Date_Part >= CAST(COALESCE({% date_start date_filter %}, CAST("1990-01-01"/*CURRENT_DATE()*/ AS TIMESTAMP)) AS DATE)
#       AND Date_Part <= CAST(COALESCE({% date_end   date_filter %}, CAST("2099-01-01"/*CURRENT_DATE()*/ AS TIMESTAMP)) AS DATE))
#       AND {% condition retail_week_filter %} RetailWeek {% endcondition %}
#       AND {% condition retail_year_filter %} RetailYear {% endcondition %}
#       AND {% condition location_filter %} location.Label {% endcondition %}

#       {% endif %}
#     ;;
#   }

#   filter: date_filter {
#     label: "Gregorian Date Filter"
#     type: date
#   }

#   filter: retail_year_filter {
#     label: "Retail Year Filter"
#     type: number
#   }

#   filter: retail_week_filter {
#     label: "Retail Week Filter"
#     type: number
#   }

#   filter: location_filter {
#     label: "Location Filter"
#     type: string
#   }

# }
