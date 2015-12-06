
require_relative "data_ml.class"
require          "colorize"

print "Please enter a mileage : "
rep = gets.chomp
rep = rep.to_f

data = Data_ml.new(".info.csv", "prediction")
if data.theta0 != 0 && data.theta1 != 0
    km_scale = data.scale(rep, "km")
    price_scale = data.estimate_price(km_scale)
    price = data.unscale(price_scale, "price")
else
    price = 0
end

puts "Price estimate : #{price} euro"
