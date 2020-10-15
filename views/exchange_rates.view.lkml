view: exchange_rates {
  derived_table: {
    sql: select * from `bi-twr.exchange_rates_US.rates` ;;
  }
  dimension: Date {
    type: date
  }
  dimension: cur_from_code {}
  dimension: cur_to_code {}
  measure: rate {
    type: number
  }
}
