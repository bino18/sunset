class TopController < ApplicationController
    require 'net/https'
    require 'uri'
    require 'json'

    def result
        if  params["date(1i)"]
            year = params["date(1i)"].to_i
            month = params["date(2i)"].to_i
            day = params["date(3i)"].to_i
            @city = params[:city]
            geocode = Geocoder.search(@city)
            lat = geocode.first.coordinates[0]
            lng = geocode.first.coordinates[1]
            @params= URI.encode_www_form(
            { mode: "sun_moon_rise_set", year: year, month: month, day: day, lat: lat, lng: lng}
            )
            uri = URI.parse("https://labs.bitmeister.jp/ohakon/json/?#{@params}")
            json = Net::HTTP.get_response(uri)
            result = JSON.parse(json.body)
            if result["rise_and_set"]
                @sunset_time = result["rise_and_set"]["sunset_hm"]
                h, m = @sunset_time.split(":").map(&:to_i)
                m = m.to_s
                if m.size == 1
                    m = "0" + m
                end
                @sunset = "#{h}時#{m}分"
            end
            @thi_ago = ago(30)
            @thi_late = late(30)
        end
    end

    private
    def ago(ago_m)
        h, m = @sunset_time.split(":").map(&:to_i)
        a_h = h
        a_m = m - ago_m
        if a_m < 0
            a_h -= 1
            a_m += 60
        end
        a_m = a_m.to_s
            if a_m.size == 1
                a_m = "0" + a_m
            end
        ago_time = "#{a_h}時#{a_m}分"
    end
      
    def late(late_m)
        h, m = @sunset_time.split(":").map(&:to_i)
        l_h = h
        l_m = m + late_m
        if l_m >= 60
            l_h += 1
            l_m -= 60
        end
        l_m = l_m.to_s
            if l_m.size == 1
                l_m = "0" + l_m
            end
        late_time = "#{l_h}時#{l_m}分"
    end

    

    
end
