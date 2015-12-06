
class   Data_ml
    def initialize(file, str)
        @data = Hash.new
        if str == "ML"
            self.read(file)
            self.data_fill
        else
            if self.read(file) == true
                @data = self.get_data_from_csv
            else
                @data["THETA_0"] = 0
                @data["THETA_1"] = 0
                @data["P_MIN"] = 0
                @data["P_MAX"] = 0
                @data["KM_MIN"] = 0
                @data["KM_MAX"] = 0
            end
            self.data_to_var
        end
    end

    def read(filename)
        if File.exist?(filename)
            file = File.open(filename)
            @content = file.read.split("\n")
            file.close
            return true
        else
            return false
        end
    end

    def save_data_to_csv(theta0, theta1)
        file = File.open(".info.csv", "w")
        file.write("THETA_0=" + theta0.to_s  + "\n")
        file.write("THETA_1=" + theta1.to_s  + "\n")
        file.write("P_MIN="   + @p_min.to_s  + "\n")
        file.write("P_MAX="   + @p_max.to_s  + "\n")
        file.write("KM_MIN="  + @km_min.to_s + "\n")
        file.write("KM_MAX="  + @km_max.to_s + "\n")
        file.close
    end

    def get_data_from_csv
        data = Hash.new
        for c in @content do
            k, v = c.split("=")
            data[k] = v
        end
        return data
    end

    def data_to_var
        @theta0 = @data["THETA_0"].to_f
        @theta1 = @data["THETA_1"].to_f
        @p_min  = @data["P_MIN"].to_f
        @p_max  = @data["P_MAX"].to_f
        @km_min = @data["KM_MIN"].to_f
        @km_max = @data["KM_MAX"].to_f
    end

    def data_fill
        @content.delete_at(0)
        for c in @content do
            key, value = get_key_value(c)
            @data[key.to_f] = value.to_f
        end
        self.scale_values
    end

    def get_key_value(line)
        val = line.split(",")
        key = val[0]
        value = val[1]
        return key, value
    end

    def estimate_price(mileage)
        return (@theta0 + (@theta1 * mileage))
    end
## SCALE METHOD ##
    def scale(val, type)
        if type == "price"
            return ( (val - @p_min) / (@p_max - @p_min) )
        else
            return ( (val - @km_min) / (@km_max - @km_min) )
        end
    end

    def unscale(val, type)
        if type == "price"
            return (val * (@p_max - @p_min) + @p_min)
        else
            return (val * (@km_max - @km_min) + @km_min)
        end
    end

    def scale_values()
        self.set_minmax_value
        neew = Hash.new()
        for km , price in @data
            km = self.scale(km, "km")
            price = self.scale(price, "price")
            neew[km] = price
        end
        @data = neew
    end

    def set_minmax_value
        @km_min = @data.min_by(&:first).first.to_f
        @km_max = @data.max_by(&:first).first.to_f
        @p_min  = @data.min_by(&:last).last.to_f
        @p_max  = @data.max_by(&:last).last.to_f
    end
##############

    def get_data() @data end
    def theta0() @theta0 end
    def theta1() @theta1 end
end
