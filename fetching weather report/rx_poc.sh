#! /bin/bash

# create a datestamped filename for the raw wttr data
today=$(date +%Y%m%d)
weather_report=raw_data_$today

# download today's weather report from wttr.in
city = Casablanca
curl wttr.in/city --output $weather_report

# extract all lines containing temperatutes from the weather report
grep °C $weather_report > temperatures.txt

# extract the current temperature
obs_tmp=$(cat -A temperatures.txt | head -1 | cut -d "+" -f2 | cut -d "^" -f1 )
echo "observed temperature = $obs_tmp"

# extract the forecast for noon tomorrow
fc_temp=$(cat -A temperatures.txt | head -3 | tail -1 | cut -d "+" -f2 | cut -d "(" -f1 | cut -d "^" -f1 )

# use command to store the hour, day, month, and year in corresponding variable
hour=$(TZ='Morocco/Casablanca' date -u +%H) 
day=$(TZ='Morocco/Casablanca' date -u +%d) 
month=$(TZ='Morocco/Casablanca' date +%m)
year=$(TZ='Morocco/Casablanca' date +%Y)

# create the record
record=$(echo -e "$year\t$month\t$day\t$obs_tmp\t$fc_temp")
echo $record>>rx_poc.log
