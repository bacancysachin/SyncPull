# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :property do
    request_id "MyString"
    requested_at "2014-08-15 14:35:47"
    lat 1.5
    lng 1.5
    year_built 1
    usecode "MyString"
    last_sold_on "2014-08-15 14:35:47"
    last_sold_price 1.5
    tax_assesment_year 1
    tax_assesment_amount 1.5
    zestimate_price 1.5
    zestimate_value_range_high 1
    zestimate_value_range_low 1
    zastimate_last_updated_on "2014-08-15 14:35:47"
    lot_size 1
    house_size 1
    zpid 1
  end
end
