class TopController < ApplicationController
    require 'net/https'
    require 'uri'
    require 'json'
    require "date"

    def top
        
    end

    def detail
    end


    def result
        # 入力された値をそれぞれ変数に代入
        year = params["date(1i)"].to_i
        month = params["date(2i)"].to_i
        day = params["date(3i)"].to_i

        # 都市名から緯度経度を取得して変数に代入
        @city = params[:city]
        geocode = Geocoder.search(@city)
        lat = geocode.first.coordinates[0]
        lng = geocode.first.coordinates[1]

        # それぞれの値をURIの形式に変換し、変数paramsに代入
        @rise_set_params= URI.encode_www_form(
        { mode: "sun_moon_rise_set",
        year: year,
        month: month,
        day: day,
        lat: lat,
        lng: lng }
        )
        # APIを叩く
        rise_set_uri = URI.parse("https://labs.bitmeister.jp/ohakon/json/?#{@rise_set_params}")
        rise_set_json = Net::HTTP.get_response(rise_set_uri)
        
        rise_set_result = JSON.parse(rise_set_json.body)

        @sunrise_hm = rise_set_result["rise_and_set"]["sunrise_hm"]
        sunset = rise_set_result["rise_and_set"]["sunset"]
        @sunset_hm = rise_set_result["rise_and_set"]["sunset_hm"]
        @rise_time = time_label(@sunrise_hm)
        @set_time = time_label(@sunset_hm)
        
        @thi_ago = ago(30)
        @thi_late = late(30)
        @date = "#{year}年#{month}月#{day}日"
    end

    def privacy
    end

    def support
    end

    def terms
    end

    def time_label(rise_set_time)
        h, m = rise_set_time.split(":").map(&:to_i)
        h = h.to_s
        m = m.to_s
            if h.size == 1
                h = "0" + h
            end
            if m.size == 1
                m = "0" + m
            end
        "#{h}時#{m}分"
    end

    def ago(ago_m)
        h, m = @sunset_hm.split(":").map(&:to_i)
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
        h, m = @sunset_hm.split(":").map(&:to_i)
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
