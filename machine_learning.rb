
require_relative "data_ml.class"
require          'colorize'

THETA_0 = 0
THETA_1 = 1

class   Machine_learning
    @@theta0 = 0
    @@theta1 = 0
    def initialize(data)
        @data = data
        @len_data = @data.length
        @learning_rate = 0.1

        tmp_t0 = self.calc_tmp_theta_zero
        tmp_t1 = self.calc_tmp_theta_one
        @@theta0 -= tmp_t0
        @@theta1 -= tmp_t1
    end

    def estimate_price(mileage)
        return (@@theta0 + (@@theta1 * mileage))
    end

    def calc_somme_estimate_price(theta_nb)
        res = 0.0
        for mileage, price in @data
            val = (self.estimate_price(mileage) - price)
            val *= mileage if theta_nb == 1
            res += val
        end
        return res
    end

    def calc_tmp_theta_zero
        somme  = self.calc_somme_estimate_price(THETA_0)
        tmp_t0 = @learning_rate * (1.0 / @len_data) * somme
        return tmp_t0
    end

    def calc_tmp_theta_one
        somme  = self.calc_somme_estimate_price(THETA_1)
        tmp_t1 = @learning_rate * (1.0 / @len_data) * somme
        return tmp_t1
    end

    def print_theta
        puts "@@theta0 = #{@@theta0} | @@theta1 = #{@@theta1}"
    end

    def theta0() @@theta0 end
    def theta1() @@theta1 end
end

################# EXEC MACHINE LEARNING ###################

data_file = (ARGV[0]) ? ARGV[0] : ".data.csv"
data = Data_ml.new(data_file, "ML")
data_csv = data.get_data

for i in (0..15000)
    mach = Machine_learning.new(data_csv)
end
data.save_data_to_csv(mach.theta0, mach.theta1)
